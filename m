Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7FE3E81B6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhHJSBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238389AbhHJR7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F25613BD;
        Tue, 10 Aug 2021 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617587;
        bh=mZeIxsdURR5OkVvnLv8FSnYIW8IK2nSTtUf4eC7nvAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzXabYtRIfcE2pm0Ww1hQbAc5UMKqDgUNsxPaXpFkLXpLnXWwirOm4fkOacfl6MK+
         s7SycZXrZ067KcR/lYghf0JPoBn6h1aXz08XtkJ2kOPxCnXoRAlYKnvW0/VmNdb2/q
         TIh4TGp9mrLS8a4P+LNzYGIFrAfcgusp617lubJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.13 124/175] serial: tegra: Only print FIFO error message when an error occurs
Date:   Tue, 10 Aug 2021 19:30:32 +0200
Message-Id: <20210810173005.036632950@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
@@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct teg
 
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


