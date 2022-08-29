Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C5C5A4BA9
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiH2M0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiH2M0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:26:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620811D0E3;
        Mon, 29 Aug 2022 05:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C0FDB80F9F;
        Mon, 29 Aug 2022 11:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6C0C433D7;
        Mon, 29 Aug 2022 11:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771392;
        bh=ZDiK8jX6cb1oKsAdnCNZLZhtFnRPXVYAq73tA3QscPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bW2rBlWFSQkZYJaZvwDwm83gLn0yeu+8BSSYVZoJcR616otj/L7RAXHgsIiBai++P
         BsID7wkXjRtv6pTt02HnwxAdrZ9t3TB9miCN3YxeeqoL//1Pb+w+5eFpduqywx9ua+
         wYWc1okWqxXvfJiqAWj6z7XyoMyBPxuKr3A7Q3So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 026/158] nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout
Date:   Mon, 29 Aug 2022 12:57:56 +0200
Message-Id: <20220829105809.876472837@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
index 2caf997f9bc94..07596bf5f7d6d 100644
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



