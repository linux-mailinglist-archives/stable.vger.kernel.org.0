Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B9C19AFDA
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbgDAQVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732316AbgDAQVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B202720658;
        Wed,  1 Apr 2020 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758094;
        bh=7degDOeCs59BBBBJ9Nmvb+EqwBBNDXJkLd6Ox/OUxjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0N0TtmNLHhV+A7xLHupg7dTG3Jvfar9NBq41d5SL1LMwaTjpiLg+U4nJZlnR65CbS
         G4dhpVtPHgtK73n/zzJhB1j3P1DcCagmWdCl8trCqZaGtyzoKogQAN1kfw9ldpyG79
         EVxklMnrH2XMspzNwIfoWt3AgTTjnTqa+3DV5Vg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Georg=20M=C3=BCller?= <georgmueller@gmx.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 10/27] platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table
Date:   Wed,  1 Apr 2020 18:17:38 +0200
Message-Id: <20200401161424.506308560@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georg Müller <georgmueller@gmx.net>

commit 95b31e35239e5e1689e3d965d692a313c71bd8ab upstream.

The Lex 2I385SW board has two Intel I211 ethernet controllers. Without
this patch, only the first port is usable. The second port fails to
start with the following message:

    igb: probe of 0000:02:00.0 failed with error -2

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Tested-by: Georg Müller <georgmueller@gmx.net>
Signed-off-by: Georg Müller <georgmueller@gmx.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/pmc_atom.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -385,6 +385,14 @@ static const struct dmi_system_id critcl
 	},
 	{
 		/* pmc_plt_clk* - are used for ethernet controllers */
+		.ident = "Lex 2I385SW",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "2I385SW"),
+		},
+	},
+	{
+		/* pmc_plt_clk* - are used for ethernet controllers */
 		.ident = "Beckhoff CB3163",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Beckhoff Automation"),


