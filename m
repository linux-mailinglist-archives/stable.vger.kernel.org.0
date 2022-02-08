Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D14ADE62
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 17:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383461AbiBHQdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 11:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383453AbiBHQdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 11:33:20 -0500
X-Greylist: delayed 77 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 08:33:18 PST
Received: from nef.ens.fr (nef2.ens.fr [129.199.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D538C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 08:33:18 -0800 (PST)
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1644337996; bh=v1TTUcoPWZhk5mbmkObylO9a7Qp5YW8ShXwjANkaXNM=;
        h=From:To:Cc:Subject:Date:From;
        b=YHIrag+TI+TZxcgWZcCoaYXLpSHU5Tm7Jn/ap8UMeJm+nZSNbSMExaEcn71CzTCAr
         WAXUBLY4VeTIT91aN0+2a4P2q0yyHXhHfER0m2u+tMDckh0avEqiHmCbh//o4Jcmmd
         r8BRpQWZljr7+b7mzQlSc9wjT4AgWRnXqV1IoH8c=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 218GXFCZ012690
          ; Tue, 8 Feb 2022 17:33:16 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 218GX7HP098149 ; Tue, 8 Feb 2022 17:33:15 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [PATCH 4.9] Input: i8042 - Fix misplaced backport of "add ASUS Zenbook Flip to noselftest list"
Date:   Tue,  8 Feb 2022 17:33:02 +0100
Message-Id: <1644337982-23738-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 08 Feb 2022 17:33:16 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit b5d6e7ab7fe7 ("Input: i8042 - add ASUS Zenbook Flip to
noselftest list") inserted a new entry in the `i8042_dmi_noselftest_table`
table, further patched by commit daa58c8eec0a ("Input: i8042 - fix Pegatron
C15B ID entry") to insert a missing separator.

However, their backported version in stable (commit e9e8b3769099
("Input: i8042 - add ASUS Zenbook Flip to noselftest list") and
commit c551d20d487a ("Input: i8042 - fix Pegatron C15B ID entry"))
inserted this entry in `i8042_dmi_forcemux_table` instead.

This patch moves the entry back into `i8042_dmi_noselftest_table`.

Fixes: e9e8b3769099 ("Input: i8042 - add ASUS Zenbook Flip to noselftest list")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 drivers/input/serio/i8042-x86ia64io.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 323b86b..6cd2ae9 100644
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

