Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8E23E803F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhHJRrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233060AbhHJRpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A1FE61245;
        Tue, 10 Aug 2021 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617211;
        bh=M4uIk6HnIuaXHioYD4GBx7fOuXBr8/MhwfLnOPzphCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+OruZ2PEK7ZNNe4fwnOKpHBQZY0wkUmnSZXDy+PX9Fnv2gRLmxHrSh/I/o5l8BKy
         6/ksjPbWkUNL4WBqM0bq8Ca3a7nE+dxqsRm2YXRIR6H3/Bs1Tg3EtOMormLju90Bnf
         4apJ5tdgcPGK8+XhRPTJZ1+WwUqlCJr8kQhFlpcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.10 094/135] serial: tegra: Only print FIFO error message when an error occurs
Date:   Tue, 10 Aug 2021 19:30:28 +0200
Message-Id: <20210810172958.952262066@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit cc9ca4d95846cbbece48d9cd385550f8fba6a3c1 upstream.

The Tegra serial driver always prints an error message when enabling the
FIFO for devices that have support for checking the FIFO enable status.
Fix this by displaying the error message, only when an error occurs.

Finally, update the error message to make it clear that enabling the
FIFO failed and display the error code.

Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
Cc: <stable@vger.kernel.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20210630125643.264264-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1040,9 +1040,11 @@ static int tegra_uart_hw_init(struct teg
 
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
-		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(tup->uport.dev,
+				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
+		}
 	} else {
 		/*
 		 * For all tegra devices (up to t210), there is a hardware


