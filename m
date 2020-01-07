Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7781332B2
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgAGVK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbgAGVKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:10:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF2C2072A;
        Tue,  7 Jan 2020 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431424;
        bh=GxdSfhBqdz7SBcFoNt6JEff3WqZ2sYPeWhFqyuzxB4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3tmiYL7TcotsAG81zxvJrwycmECdUEqIth2k11swh66mtz/mHBC9rcC4D+N/WyZj
         /ZnBSHoNHtLJbMV5KiXS2wJwK6Wn9r/m2+/x6jPIUefqwRpklpM+mkDqV2k2jszL+W
         I28VeZ+XDdJArGQ6BQ2Xi9/lRcBdELny/P3/R5b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Haener <michael.haener@siemens.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 51/74] platform/x86: pmc_atom: Add Siemens CONNECT X300 to critclk_systems DMI table
Date:   Tue,  7 Jan 2020 21:55:16 +0100
Message-Id: <20200107205217.422380999@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Haener <michael.haener@siemens.com>

commit e8796c6c69d129420ee94a1906b18d86b84644d4 upstream.

The CONNECT X300 uses the PMC clock for on-board components and gets
stuck during boot if the clock is disabled. Therefore, add this
device to the critical systems list.
Tested on CONNECT X300.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Signed-off-by: Michael Haener <michael.haener@siemens.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/pmc_atom.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -482,6 +482,14 @@ static const struct dmi_system_id critcl
 			DMI_MATCH(DMI_PRODUCT_VERSION, "6ES7647-8B"),
 		},
 	},
+	{
+		.ident = "CONNECT X300",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SIEMENS AG"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "A5E45074588"),
+		},
+	},
+
 	{ /*sentinel*/ }
 };
 


