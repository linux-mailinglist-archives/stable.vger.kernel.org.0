Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7500224B553
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgHTKWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbgHTKWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:22:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BAD2072D;
        Thu, 20 Aug 2020 10:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918934;
        bh=waKOxP2EoxmQLPxYJ+CiiK3DCgizWITSQZ996hG1mjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+3A36GVaFvdbnphROjEJxUHHr0yTBTGwM/AUw6szS3VcyOUAWoz8+o5PsyQXtRXK
         oqQn+ytd0uEIKhuABIY4t0ZipmIGnMrHm9ixHgYxEMmMNEJh9lm5NwWlzh08LWwBGi
         l/9ckpyH5+0VAPYNkIZFS6QVfGIl4YeB9FQMb+cQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Fustini <drew@beagleboard.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 103/149] pinctrl-single: fix pcs_parse_pinconf() return value
Date:   Thu, 20 Aug 2020 11:23:00 +0200
Message-Id: <20200820092130.693973088@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Drew Fustini <drew@beagleboard.org>

[ Upstream commit f46fe79ff1b65692a65266a5bec6dbe2bf7fc70f ]

This patch causes pcs_parse_pinconf() to return -ENOTSUPP when no
pinctrl_map is added.  The current behavior is to return 0 when
!PCS_HAS_PINCONF or !nconfs.  Thus pcs_parse_one_pinctrl_entry()
incorrectly assumes that a map was added and sets num_maps = 2.

Analysis:
=========
The function pcs_parse_one_pinctrl_entry() calls pcs_parse_pinconf()
if PCS_HAS_PINCONF is enabled.  The function pcs_parse_pinconf()
returns 0 to indicate there was no error and num_maps is then set to 2:

 980 static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 981                                                 struct device_node *np,
 982                                                 struct pinctrl_map **map,
 983                                                 unsigned *num_maps,
 984                                                 const char **pgnames)
 985 {
<snip>
1053         (*map)->type = PIN_MAP_TYPE_MUX_GROUP;
1054         (*map)->data.mux.group = np->name;
1055         (*map)->data.mux.function = np->name;
1056
1057         if (PCS_HAS_PINCONF && function) {
1058                 res = pcs_parse_pinconf(pcs, np, function, map);
1059                 if (res)
1060                         goto free_pingroups;
1061                 *num_maps = 2;
1062         } else {
1063                 *num_maps = 1;
1064         }

However, pcs_parse_pinconf() will also return 0 if !PCS_HAS_PINCONF or
!nconfs.  I believe these conditions should indicate that no map was
added by returning -ENOTSUPP. Otherwise pcs_parse_one_pinctrl_entry()
will set num_maps = 2 even though no maps were successfully added, as
it does not reach "m++" on line 940:

 895 static int pcs_parse_pinconf(struct pcs_device *pcs, struct device_node *np,
 896                              struct pcs_function *func,
 897                              struct pinctrl_map **map)
 898
 899 {
 900         struct pinctrl_map *m = *map;
<snip>
 917         /* If pinconf isn't supported, don't parse properties in below. */
 918         if (!PCS_HAS_PINCONF)
 919                 return 0;
 920
 921         /* cacluate how much properties are supported in current node */
 922         for (i = 0; i < ARRAY_SIZE(prop2); i++) {
 923                 if (of_find_property(np, prop2[i].name, NULL))
 924                         nconfs++;
 925         }
 926         for (i = 0; i < ARRAY_SIZE(prop4); i++) {
 927                 if (of_find_property(np, prop4[i].name, NULL))
 928                         nconfs++;
 929         }
 930         if (!nconfs)
 919                 return 0;
 932
 933         func->conf = devm_kcalloc(pcs->dev,
 934                                   nconfs, sizeof(struct pcs_conf_vals),
 935                                   GFP_KERNEL);
 936         if (!func->conf)
 937                 return -ENOMEM;
 938         func->nconfs = nconfs;
 939         conf = &(func->conf[0]);
 940         m++;

This situtation will cause a boot failure [0] on the BeagleBone Black
(AM3358) when am33xx_pinmux node in arch/arm/boot/dts/am33xx-l4.dtsi
has compatible = "pinconf-single" instead of "pinctrl-single".

The patch fixes this issue by returning -ENOSUPP when !PCS_HAS_PINCONF
or !nconfs, so that pcs_parse_one_pinctrl_entry() will know that no
map was added.

Logic is also added to pcs_parse_one_pinctrl_entry() to distinguish
between -ENOSUPP and other errors.  In the case of -ENOSUPP, num_maps
is set to 1 as it is valid for pinconf to be enabled and a given pin
group to not any pinconf properties.

[0] https://lore.kernel.org/linux-omap/20200529175544.GA3766151@x1/

Fixes: 9dddb4df90d1 ("pinctrl: single: support generic pinconf")
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20200608125143.GA2789203@x1
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1071,7 +1071,7 @@ static int pcs_parse_pinconf(struct pcs_
 
 	/* If pinconf isn't supported, don't parse properties in below. */
 	if (!PCS_HAS_PINCONF)
-		return 0;
+		return -ENOTSUPP;
 
 	/* cacluate how much properties are supported in current node */
 	for (i = 0; i < ARRAY_SIZE(prop2); i++) {
@@ -1083,7 +1083,7 @@ static int pcs_parse_pinconf(struct pcs_
 			nconfs++;
 	}
 	if (!nconfs)
-		return 0;
+		return -ENOTSUPP;
 
 	func->conf = devm_kzalloc(pcs->dev,
 				  sizeof(struct pcs_conf_vals) * nconfs,
@@ -1196,9 +1196,12 @@ static int pcs_parse_one_pinctrl_entry(s
 
 	if (PCS_HAS_PINCONF) {
 		res = pcs_parse_pinconf(pcs, np, function, map);
-		if (res)
+		if (res == 0)
+			*num_maps = 2;
+		else if (res == -ENOTSUPP)
+			*num_maps = 1;
+		else
 			goto free_pingroups;
-		*num_maps = 2;
 	} else {
 		*num_maps = 1;
 	}


