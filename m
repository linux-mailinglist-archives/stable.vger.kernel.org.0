Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D154A72A3
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 15:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiBBODe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 09:03:34 -0500
Received: from nef2.ens.fr ([129.199.96.40]:55028 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234105AbiBBODe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Feb 2022 09:03:34 -0500
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643810613; bh=0JfkBqUxlIZjr9PsG82jFbbr33+9rYTMKO+9EXwHt7w=;
        h=From:To:Cc:Subject:Date:From;
        b=d4DCSixQQ2xpEsgoRHv/JROvbGWHdKWcN8ly5yFh3sQjKPqFAE/nDj+r1obRFtUfz
         WBWGLmJytaLhfhNTfg6fcf9V0aqJO64va7gjJEJOBCMWeIQYEdpD1yH5Ct9wadwEwp
         sSPRRYR075XfU+726LlRQiOrtYn9RQgzjM06We74=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 212E3WNI003995
          ; Wed, 2 Feb 2022 15:03:32 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 212E3SZH021460 ; Wed, 2 Feb 2022 15:03:32 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [PATCH 4.4] Input: i8042 - Fix misplaced backport of "add ASUS Zenbook Flip to noselftest list"
Date:   Wed,  2 Feb 2022 15:03:23 +0100
Message-Id: <1643810603-6968-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Wed, 02 Feb 2022 15:03:33 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit b5d6e7ab7fe7 ("Input: i8042 - add ASUS Zenbook Flip to
noselftest list") inserted a new entry in the `i8042_dmi_noselftest_table`
table, further patched by commit daa58c8eec0a ("Input: i8042 - fix Pegatron
C15B ID entry") to insert a missing separator.

However, their backported version in stable (commit e480ccf433be
("Input: i8042 - add ASUS Zenbook Flip to noselftest list") and
commit 7444a4152ac3 ("Input: i8042 - fix Pegatron C15B ID entry"))
inserted this entry in `i8042_dmi_forcemux_table` instead.

This patch moves the entry back into `i8042_dmi_noselftest_table`.

Fixes: e480ccf433be ("Input: i8042 - add ASUS Zenbook Flip to noselftest list")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 drivers/input/serio/i8042-x86ia64io.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 323b86b..a380676 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -586,11 +586,6 @@ static const struct dmi_system_id i8042_dmi_forcemux_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-CS"),
 		},
-	}, {
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
-		},
 	},
 	{ }
 };
@@ -677,6 +672,12 @@ static const struct dmi_system_id i8042_dmi_noselftest_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z450LA"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
+		},
+	},
 	{ }
 };
 static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
--
2.7.4

