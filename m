Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8199F624A7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfGHPWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387541AbfGHPWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97547216C4;
        Mon,  8 Jul 2019 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599338;
        bh=Nf2YQlA6/8uRbuf11XOZ+HRCsHe6fw5Z0BmejLtcxfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3ZDQ0NF/RwvVw/wCPuINkm5H/wmyV+/SQBJMZSOFVJ7y4QE9oUyu4uXBrVO9LzGL
         Z4OUzVp96MkwdiwgogDineyjpuSriUiZZ7p11sEpwd27bmEGalDpy8MFzboX0usWjz
         RsOTtgtd7R62OR1SUfAZKoxW+0oTFtggehtXuISc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 4.9 082/102] clk: sunxi: fix uninitialized access
Date:   Mon,  8 Jul 2019 17:13:15 +0200
Message-Id: <20190708150530.716651984@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 4e903450bcb9a6bc90733b981d7cb8b3c4996a0e upstream.

gcc-8 reports an uninitialized variable access in a code path
that we would see with incorrect DTB input:

drivers/clk/sunxi/clk-sun8i-bus-gates.c: In function 'sun8i_h3_bus_gates_init':
drivers/clk/sunxi/clk-sun8i-bus-gates.c:85:27: error: 'clk_parent' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This works around by skipping invalid input and printing a warning
instead if it ever happens. The problem was apparently part of the
initiali driver submission, but older compilers don't notice it.

Fixes: ab6e23a4e388 ("clk: sunxi: Add H3 clocks support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/sunxi/clk-sun8i-bus-gates.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/clk/sunxi/clk-sun8i-bus-gates.c
+++ b/drivers/clk/sunxi/clk-sun8i-bus-gates.c
@@ -78,6 +78,10 @@ static void __init sun8i_h3_bus_gates_in
 			clk_parent = APB1;
 		else if (index >= 96 && index <= 127)
 			clk_parent = APB2;
+		else {
+			WARN_ON(true);
+			continue;
+		}
 
 		clk_reg = reg + 4 * (index / 32);
 		clk_bit = index % 32;


