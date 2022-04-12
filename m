Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865A84FD21D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351227AbiDLHKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351637AbiDLHDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:03:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F94145046;
        Mon, 11 Apr 2022 23:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B742DCE1C02;
        Tue, 12 Apr 2022 06:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE776C385A6;
        Tue, 12 Apr 2022 06:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746033;
        bh=dR1eDUy14Q8+3Bj84+YnRadS3mZCumZoB4jHrCCtm4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LI7PIt88JEKSadPx9nGlJ9l20G++Unc6+pqyRxY56zFt89hXEv/sNSnA9ih3N/S2W
         lnwzvzqonwVdgDSVh1I+6oFgHfxC19y1X4aw7pbD9zQzqE6BDelYEViQnKuLvetHGA
         wQxo6uScvJbjfUg5R8h0c5Bsq7YNax21zw02wJvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hyeonkook Kim <hk619.kim@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/277] serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()
Date:   Tue, 12 Apr 2022 08:28:57 +0200
Message-Id: <20220412062945.914558379@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
 drivers/tty/serial/samsung_tty.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/serial/samsung_tty.c b/drivers/tty/serial/samsung_tty.c
index e2f49863e9c2..319533b3c32a 100644
--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -922,11 +922,8 @@ static void s3c24xx_serial_tx_chars(struct s3c24xx_uart_port *ourport)
 		return;
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



