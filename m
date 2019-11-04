Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82EEEF66
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388469AbfKDWVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730062AbfKDV6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:06 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926B9214D8;
        Mon,  4 Nov 2019 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904685;
        bh=fxdugRaZcLgOseleGocQUAJOQjGs8F4EZ2YaQ26avFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMBIixcTaa70qZMS5tL+urMhR27b5VPO5fs8umG9nh6jSjqlaeNVtkXNOZMeis0U6
         bKRGiiuuR5bGYyb6qv4AXlC4D75uQ2e8P55IOqPkIe9otk41bL2CBnNrpZM3jbBXe1
         ryXDozvgGhkjcxA37E+byVRbHCXf5lwYg9bQ6IBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neil@brown.name>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/149] staging: mt7621-pinctrl: use pinconf-generic for dt_node_to_map and dt_free_map
Date:   Mon,  4 Nov 2019 22:43:45 +0100
Message-Id: <20191104212137.998449589@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 0ca1f90861b6d64386261096b42bfc81ce11948a ]

Instead of reimplement afunction to do 'dt_node_to_map' task like
'rt2880_pinctrl_dt_node_to_map' make use of 'pinconf_generic_dt_node_to_map_all'
generic function for this task. Also use its equivalent function for free which
is 'pinconf_generic_dt_free_map'. Remove 'rt2880_pinctrl_dt_node_to_map' function
which is not needed anymore. This decrease a bit driver LOC and make it more
generic. To properly compile this changes 'GENERIC_PINCONF' option is selected
with the driver in its Kconfig file.

This also fix a problem with function 'rt2880_pinctrl_dt_node_to_map' which was
calling internally 'pinctrl_utils_reserve_map' which expects 'num_maps' to be initialized.
It does a memory allocation based on the value, and triggers the following
warning if is not properly set:

if (unlikely(order >= MAX_ORDER)) {
        WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
        return NULL;
}

Generic function 'pinconf_generic_dt_node_to_map_all' initializes properly
'num_maps' to zero fixing the problem.

Fixes: e12a1a6e087b ("staging: mt7621-pinctrl: refactor rt2880_pinctrl_dt_node_to_map function")
Reported-by: NeilBrown <neil@brown.name>
Tested-by: NeilBrown <neil@brown.name>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pinctrl/Kconfig        |  1 +
 .../staging/mt7621-pinctrl/pinctrl-rt2880.c   | 41 ++-----------------
 2 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/mt7621-pinctrl/Kconfig b/drivers/staging/mt7621-pinctrl/Kconfig
index 37cf9c3273beb..fc36127113072 100644
--- a/drivers/staging/mt7621-pinctrl/Kconfig
+++ b/drivers/staging/mt7621-pinctrl/Kconfig
@@ -2,3 +2,4 @@ config PINCTRL_RT2880
 	bool "RT2800 pinctrl driver for RALINK/Mediatek SOCs"
 	depends on RALINK
 	select PINMUX
+	select GENERIC_PINCONF
diff --git a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
index aa98fbb170139..80e7067cfb797 100644
--- a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
+++ b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/machine.h>
@@ -73,48 +74,12 @@ static int rt2880_get_group_pins(struct pinctrl_dev *pctrldev,
 	return 0;
 }
 
-static int rt2880_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrldev,
-					 struct device_node *np_config,
-					 struct pinctrl_map **map,
-					 unsigned int *num_maps)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-	struct property *prop;
-	const char *function_name, *group_name;
-	int ret;
-	int ngroups = 0;
-	unsigned int reserved_maps = 0;
-
-	for_each_node_with_property(np_config, "group")
-		ngroups++;
-
-	*map = NULL;
-	ret = pinctrl_utils_reserve_map(pctrldev, map, &reserved_maps,
-					num_maps, ngroups);
-	if (ret) {
-		dev_err(p->dev, "can't reserve map: %d\n", ret);
-		return ret;
-	}
-
-	of_property_for_each_string(np_config, "group", prop, group_name) {
-		ret = pinctrl_utils_add_map_mux(pctrldev, map, &reserved_maps,
-						num_maps, group_name,
-						function_name);
-		if (ret) {
-			dev_err(p->dev, "can't add map: %d\n", ret);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static const struct pinctrl_ops rt2880_pctrl_ops = {
 	.get_groups_count	= rt2880_get_group_count,
 	.get_group_name		= rt2880_get_group_name,
 	.get_group_pins		= rt2880_get_group_pins,
-	.dt_node_to_map		= rt2880_pinctrl_dt_node_to_map,
-	.dt_free_map		= pinctrl_utils_free_map,
+	.dt_node_to_map		= pinconf_generic_dt_node_to_map_all,
+	.dt_free_map		= pinconf_generic_dt_free_map,
 };
 
 static int rt2880_pmx_func_count(struct pinctrl_dev *pctrldev)
-- 
2.20.1



