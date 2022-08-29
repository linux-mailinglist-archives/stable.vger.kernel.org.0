Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D685A4A51
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiH2LhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiH2LgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:36:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1953B7D7BC;
        Mon, 29 Aug 2022 04:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2688B80F3B;
        Mon, 29 Aug 2022 11:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EFDC433C1;
        Mon, 29 Aug 2022 11:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771107;
        bh=IAXDwtfFOmitaIKfjHPlHTXJpqG+oOz2KWYeG26f2ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHRk26T30VgQYp8PHv14XxNkkFQXoenkAQaVRynMEQAl333u5U0A4lOLBnPKYCUe4
         ckKRPS/k7fz3Zlmdo+whB1jlHHhC5W/q6buIRgeLEbdu8/2US3nA44G0+yExe2K0Bw
         pdneKWEF4vPOYOLX6IP/MHZAO7BJP5bN/VKoLFwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/86] nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout
Date:   Mon, 29 Aug 2022 12:58:48 +0200
Message-Id: <20220829105757.429379589@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit f1e941dbf80a9b8bab0bffbc4cbe41cc7f4c6fb6 ]

When the pn532 uart device is detaching, the pn532_uart_remove()
is called. But there are no functions in pn532_uart_remove() that
could delete the cmd_timeout timer, which will cause use-after-free
bugs. The process is shown below:

    (thread 1)                  |        (thread 2)
                                |  pn532_uart_send_frame
pn532_uart_remove               |    mod_timer(&pn532->cmd_timeout,...)
  ...                           |    (wait a time)
  kfree(pn532) //FREE           |    pn532_cmd_timeout
                                |      pn532_uart_send_frame
                                |        pn532->... //USE

This patch adds del_timer_sync() in pn532_uart_remove() in order to
prevent the use-after-free bugs. What's more, the pn53x_unregister_nfc()
is well synchronized, it sets nfc_dev->shutting_down to true and there
are no syscalls could restart the cmd_timeout timer.

Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/uart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index a0665d8ea85bc..e92535ebb5287 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -310,6 +310,7 @@ static void pn532_uart_remove(struct serdev_device *serdev)
 	pn53x_unregister_nfc(pn532->priv);
 	serdev_device_close(serdev);
 	pn53x_common_clean(pn532->priv);
+	del_timer_sync(&pn532->cmd_timeout);
 	kfree_skb(pn532->recv_skb);
 	kfree(pn532);
 }
-- 
2.35.1



