Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B690C50132F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbiDNOFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347297AbiDNN6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F5118385;
        Thu, 14 Apr 2022 06:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 188B661D29;
        Thu, 14 Apr 2022 13:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A34C385A1;
        Thu, 14 Apr 2022 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944162;
        bh=leA5SjVEI+OFdMEEiqCpgxxL7VQwPeWyvqNgqzEKnOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKGdTCNRLDccHF1FSyS7JW2CuHlPmBiKkCSnvbGBMKgfwLjm6TKmG+0a6B5wXl472
         chuNPTeW0GACoFttFuEMySb32QwIpfN9q4hgG+/a18czoZVVqSwXaYPuRqnQrARskd
         uKRjXfKPjag3rbM1Ot/S3RpFzNuWBTgxyJBnKPWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hyeonkook Kim <hk619.kim@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 416/475] serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()
Date:   Thu, 14 Apr 2022 15:13:21 +0200
Message-Id: <20220414110906.705000925@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 988c7c00691008ea1daaa1235680a0da49dab4e8 ]

The commit c15c3747ee32 (serial: samsung: fix potential soft lockup
during uart write) added an unlock of port->lock before
uart_write_wakeup() and a lock after it. It was always problematic to
write data from tty_ldisc_ops::write_wakeup and it was even documented
that way. We fixed the line disciplines to conform to this recently.
So if there is still a missed one, we should fix them instead of this
workaround.

On the top of that, s3c24xx_serial_tx_dma_complete() in this driver
still holds the port->lock while calling uart_write_wakeup().

So revert the wrap added by the commit above.

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Hyeonkook Kim <hk619.kim@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220308115153.4225-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/samsung.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c7683beb3412..6040d5a6139a 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -761,11 +761,8 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 		goto out;
 	}
 
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS) {
-		spin_unlock(&port->lock);
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
-		spin_lock(&port->lock);
-	}
 
 	if (uart_circ_empty(xmit))
 		s3c24xx_serial_stop_tx(port);
-- 
2.35.1



