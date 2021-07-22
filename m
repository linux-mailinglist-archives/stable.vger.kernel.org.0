Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2923A3D2A59
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhGVQK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234409AbhGVQIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF66E61DC4;
        Thu, 22 Jul 2021 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972516;
        bh=56C54re7AaBKrvgLt+YMW0rAGOyOEn9kcPJOeaNd6+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWGNrw9wEUN3I7EZ7c+leeIaCwvsLuyMJRbjZBGf6tYlwcNYXpa7SNBATb2sjScRS
         +91A0dO99SamllWKtvncv34oTvmwiiZh+JyRFu42r0mQ9+qHycW1O2zkhLYbvGC7xO
         YLpRx/X/RQvXI34OT7sBgUrinwzgQMNslVjt4Oww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.13 141/156] ARM: dts: tacoma: Add phase corrections for eMMC
Date:   Thu, 22 Jul 2021 18:31:56 +0200
Message-Id: <20210722155632.908287671@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

commit 2d6608b57c50c54c3e46649110e8ea5a40959c30 upstream.

The degree values were reversed out from the magic tap values of 7 (in)
and 15 + inversion (out) initially suggested by Aspeed.

With the patch tacoma survives several gigabytes of reads and writes
using dd while without it locks up randomly during the boot process.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20210625061017.1149942-1-andrew@aj.id.au
Fixes: 2fc88f92359d ("mmc: sdhci-of-aspeed: Expose clock phase controls")
Fixes: 961216c135a8 ("ARM: dts: aspeed: Add Rainier system")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
@@ -186,6 +186,7 @@
 
 &emmc {
 	status = "okay";
+	clk-phase-mmc-hs200 = <36>, <270>;
 };
 
 &fsim0 {


