Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D39540E467
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347252AbhIPQ6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346808AbhIPQ4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E72D161AE1;
        Thu, 16 Sep 2021 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809848;
        bh=9foygNpkQDwOr2qCWW90C35W1j1hFTBdaVPZhzHL2Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gThQKtZ2yOlaDe8JyLHzJtEI8Mp5gWa1bKj6F56ccopHyGfbib55XeYCnF46cxOS
         AnJt7N3W7KPALlj++ZsndCaxOco4MMCLDXCZ3fY2TFtbq2JtN5YeC+wqzzhHTFrmzV
         9bxCKLNUTPg3HosYfETUzBkAqXG/RcABTI7XG3OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gustaw Lewandowski <gustaw.lewandowski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 305/380] ASoC: Intel: Skylake: Fix passing loadable flag for module
Date:   Thu, 16 Sep 2021 18:01:02 +0200
Message-Id: <20210916155814.435986102@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustaw Lewandowski <gustaw.lewandowski@linux.intel.com>

[ Upstream commit c5ed9c547cba1dc1238c6e8a0c290fd62ee6e127 ]

skl_get_module_info() tries to set mconfig->module->loadable before
mconfig->module has been assigned thus flag was always set to false
and driver did not try to load module binaries.

Signed-off-by: Gustaw Lewandowski <gustaw.lewandowski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Link: https://lore.kernel.org/r/20210818075742.1515155-7-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-pcm.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index b1ca64d2f7ea..031d5dc7e660 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1317,21 +1317,6 @@ static int skl_get_module_info(struct skl_dev *skl,
 		return -EIO;
 	}
 
-	list_for_each_entry(module, &skl->uuid_list, list) {
-		if (guid_equal(uuid_mod, &module->uuid)) {
-			mconfig->id.module_id = module->id;
-			if (mconfig->module)
-				mconfig->module->loadable = module->is_loadable;
-			ret = 0;
-			break;
-		}
-	}
-
-	if (ret)
-		return ret;
-
-	uuid_mod = &module->uuid;
-	ret = -EIO;
 	for (i = 0; i < skl->nr_modules; i++) {
 		skl_module = skl->modules[i];
 		uuid_tplg = &skl_module->uuid;
@@ -1341,10 +1326,18 @@ static int skl_get_module_info(struct skl_dev *skl,
 			break;
 		}
 	}
+
 	if (skl->nr_modules && ret)
 		return ret;
 
+	ret = -EIO;
 	list_for_each_entry(module, &skl->uuid_list, list) {
+		if (guid_equal(uuid_mod, &module->uuid)) {
+			mconfig->id.module_id = module->id;
+			mconfig->module->loadable = module->is_loadable;
+			ret = 0;
+		}
+
 		for (i = 0; i < MAX_IN_QUEUE; i++) {
 			pin_id = &mconfig->m_in_pin[i].id;
 			if (guid_equal(&pin_id->mod_uuid, &module->uuid))
@@ -1358,7 +1351,7 @@ static int skl_get_module_info(struct skl_dev *skl,
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int skl_populate_modules(struct skl_dev *skl)
-- 
2.30.2



