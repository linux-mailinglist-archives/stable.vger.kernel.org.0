Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327212DFA1C
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgLUIsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLUIsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:48:13 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467AAC061248
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:33 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 9so10604173oiq.3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=auzb+IbQH96MeFrxoC0H6UvH3kmzyCZ5vmcXQO/iNac=;
        b=cLtDWp+Tg4tqVzR6qaDR7kb8m4B1OZ20RQIOimKiTi1BZPIvijx5vvMA06eLguVWYG
         2htFwkWvrf1ZOzkisiQfXUjrYk8Hqk3vMhcvaO3B5Is4HegTHZdrd4KfMVTzID7iRTtZ
         7T0KDTB7t/CYcjW3Usq7tqecaMsu4fM1/Xip8rtcbjSd4pttdOvfGSMLE0VWvtmeN0n3
         ZE6t+qMqWzTkgcKSjKHh1DeRL5qS0hNOKVH6NzRRbhY30AviO/Qq75xtnX555WZpjNZf
         zp/kLnu3dm4AFv2X6E64t8oTu7X6VqGaiPnjBqfKtdUaRMV37CfmuO1gMJzGFg0tYeCM
         7aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=auzb+IbQH96MeFrxoC0H6UvH3kmzyCZ5vmcXQO/iNac=;
        b=IlfjG9u2PwhaZizwsTg8QRg5VqlcRLDxaORH6tpGL6koCrMdlAfWh1PXQdnL/PIviX
         86k4ooidrdJLCxincC37PWtxEVCqNKkG40EcIaoyifQ3noBv2qBnWVT4UbrJ1ieYpc/n
         GRc30rDUlMEFIfXHIMub3RNcyaZ56ty/en+3VYAJMEvd2Fy48Juh3l+lyDVxx0JRgMBP
         d3HlYmnYDaQZw0MtpGCvlLccbMRhvQy3EK0TNOGnkQm4KCyvqofXqzTh1EMZKF/FBE6O
         OFNGNoLAIl4Z2TqTCmnh70/1iz1ZXFWGRDuGmrqONW4CJDniw0zMz5g0zZjfyl4U6vSq
         ZsGQ==
X-Gm-Message-State: AOAM531sSa1s6tr+Z4FGynxUERvjsWCCHqOunyW+hvchZuFEc4QXAfgi
        /DO6R9HMt1RgRBnQ2YVyzwo=
X-Google-Smtp-Source: ABdhPJzMdEsiyIoJtP0qZFb+5SgZQzVWslWgAOijm9RD2IfjJjlPcWvV9Ay87zx/3XD7l0vGLmT3zw==
X-Received: by 2002:a54:4785:: with SMTP id o5mr10361276oic.139.1608540452777;
        Mon, 21 Dec 2020 00:47:32 -0800 (PST)
Received: from XChen-BuildServer.amd.com ([165.204.77.1])
        by smtp.gmail.com with ESMTPSA id i24sm3611270oot.42.2020.12.21.00.47.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 00:47:32 -0800 (PST)
From:   "Xiaogang.Chen" <chenxiaogang888@gmail.com>
X-Google-Original-From: "Xiaogang.Chen" <xiaogang.chen@amd.com>
To:     xiaogang.chen@amd.com
Cc:     Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1 01/14] Revert "serial: uartps: Fix error path when alloc failed"
Date:   Mon, 21 Dec 2020 02:47:06 -0600
Message-Id: <1608540439-28772-2-git-send-email-xiaogang.chen@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit b6fd2dbbd649b89a3998528994665ded1e3fbf7f upstream.

This reverts commit 32cf21ac4edd6c0d5b9614368a83bcdc68acb031.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/46cd7f039db847c08baa6508edd7854f7c8ff80f.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index d8910c5..f9297ee 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1554,10 +1554,8 @@ static int cdns_uart_probe(struct platform_device *pdev)
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 	cdns_uart_console = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_console),
 					 GFP_KERNEL);
-	if (!cdns_uart_console) {
-		rc = -ENOMEM;
-		goto err_out_id;
-	}
+	if (!cdns_uart_console)
+		return -ENOMEM;
 
 	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
 		sizeof(cdns_uart_console->name));
-- 
2.7.4

