Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1220404FC4
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhIIMWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353009AbhIIMUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6327861AA4;
        Thu,  9 Sep 2021 11:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188225;
        bh=KyrPSSFkkaFfgTa331w9So5Bp9nfhgXOj9h8Ox5YpWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCZxFB3KDyt7K+H8L3j5KIyFRIasm00QLWnxRJ0twVErgGX8h9shJIOS6T7r4RoW+
         0R5zAxyPzh9PZR6k57oGVixYfSjyAF64qRfDZMqrQi/FMQ4k+atVDgLe+nipJuyZqp
         UAhSV9LtpV3YhfZrfk+C6KORKqOuhcLbIuF7AH1sfhESBUjUJU7xM1nrBZ5C/qR/zJ
         zq2Dg+1Ov5XWwiP7tymLA6tBBKbkHTNAXjlSfvH4mkfgT/pajgSiYV06D6YQRL/gOq
         rRGvwMrXrLA9UWo6X/tJSYFMcXSoLSH8VAwS4g9jntP2M7lrMJ2AIRsoGUUeuS2j4s
         e0JFQNbAsdw8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 178/219] ASoC: Intel: Skylake: Fix module configuration for KPB and MIXER
Date:   Thu,  9 Sep 2021 07:45:54 -0400
Message-Id: <20210909114635.143983-178-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit e4e0633bcadc950b4b4af06c7f1bb7f7e3e86321 ]

KeyPhrasebuffer, Mixin and Mixout modules configuration is described by
firmware's basic module configuration structure. There are no extended
parameters required. Update functions taking part in building
INIT_INSTANCE IPC payload to reflect that.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Link: https://lore.kernel.org/r/20210818075742.1515155-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-messages.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-messages.c b/sound/soc/intel/skylake/skl-messages.c
index 476ef1897961..79c6cf2c14bf 100644
--- a/sound/soc/intel/skylake/skl-messages.c
+++ b/sound/soc/intel/skylake/skl-messages.c
@@ -802,9 +802,12 @@ static u16 skl_get_module_param_size(struct skl_dev *skl,
 
 	case SKL_MODULE_TYPE_BASE_OUTFMT:
 	case SKL_MODULE_TYPE_MIC_SELECT:
-	case SKL_MODULE_TYPE_KPB:
 		return sizeof(struct skl_base_outfmt_cfg);
 
+	case SKL_MODULE_TYPE_MIXER:
+	case SKL_MODULE_TYPE_KPB:
+		return sizeof(struct skl_base_cfg);
+
 	default:
 		/*
 		 * return only base cfg when no specific module type is
@@ -857,10 +860,14 @@ static int skl_set_module_format(struct skl_dev *skl,
 
 	case SKL_MODULE_TYPE_BASE_OUTFMT:
 	case SKL_MODULE_TYPE_MIC_SELECT:
-	case SKL_MODULE_TYPE_KPB:
 		skl_set_base_outfmt_format(skl, module_config, *param_data);
 		break;
 
+	case SKL_MODULE_TYPE_MIXER:
+	case SKL_MODULE_TYPE_KPB:
+		skl_set_base_module_format(skl, module_config, *param_data);
+		break;
+
 	default:
 		skl_set_base_module_format(skl, module_config, *param_data);
 		break;
-- 
2.30.2

