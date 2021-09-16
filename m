Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846C540DEF6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbhIPQFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240539AbhIPQFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C321561241;
        Thu, 16 Sep 2021 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808253;
        bh=LDOCNYiRG8y48Kp3dDBTvpKz232yVRp7s0kGyjwtVgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDrvZQzFPP8V8heeJl9qvN/tShQY50BqWYyY9I8RFUuGDIGA72/l/wMv8xZMh3UCf
         uhwi+6oTpZ318qkk4ZWVAdl3HO+Lzdr2NlS4DGTZax/4IOrM7VfqZ8Qo8qGFJueSHf
         mYGYKv2ok7gZokhXGu4nVvuJjiF1uyDldA8yBDNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 018/306] clk: socfpga: agilex: fix the parents of the psi_ref_clk
Date:   Thu, 16 Sep 2021 17:56:03 +0200
Message-Id: <20210916155754.547037615@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 9d563236cca43fc4fe190b3be173444bd48e2a3b upstream.

The psi_ref_clk comes from the C2 node of the main_pll and periph_pll,
not the C3.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210713144621.605140-1-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/clk-agilex.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -107,10 +107,10 @@ static const struct clk_parent_data gpio
 };
 
 static const struct clk_parent_data psi_ref_free_mux[] = {
-	{ .fw_name = "main_pll_c3",
-	  .name = "main_pll_c3", },
-	{ .fw_name = "peri_pll_c3",
-	  .name = "peri_pll_c3", },
+	{ .fw_name = "main_pll_c2",
+	  .name = "main_pll_c2", },
+	{ .fw_name = "peri_pll_c2",
+	  .name = "peri_pll_c2", },
 	{ .fw_name = "osc1",
 	  .name = "osc1", },
 	{ .fw_name = "cb-intosc-hs-div2-clk",


