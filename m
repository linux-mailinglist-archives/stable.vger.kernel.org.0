Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E056318E2E
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBKPWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbhBKPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19DFE64F18;
        Thu, 11 Feb 2021 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055973;
        bh=ZLAd1ORv4C/sSjMP2qyD98YmhB+xZSs3D8tlisBUf6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPRA04MEPBKIIheOC+hAmf4uuoY7RoVYqSMbRPDO6ATmKmsghp26XsKTo+XjkG6Pq
         kasLb14h8+ehoJ6byhimBCxJp3WqcSGzLcWD4yOwqJQ9yt9+w7Y+TOs1y+Q5ORbhzk
         0lS/eFwfwFsdxztNkUB6EX/+uvr19eLLVXrn+3fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/24] ASoC: Intel: Skylake: Zero snd_ctl_elem_value
Date:   Thu, 11 Feb 2021 16:02:28 +0100
Message-Id: <20210211150148.752537565@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 1d8fe0648e118fd495a2cb393a34eb8d428e7808 ]

Clear struct snd_ctl_elem_value before calling ->put() to avoid any data
leak.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210121171644.131059-2-ribalda@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index 2cb719893324a..1940b17f27efa 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -3632,7 +3632,7 @@ static void skl_tplg_complete(struct snd_soc_component *component)
 		sprintf(chan_text, "c%d", mach->mach_params.dmic_num);
 
 		for (i = 0; i < se->items; i++) {
-			struct snd_ctl_elem_value val;
+			struct snd_ctl_elem_value val = {};
 
 			if (strstr(texts[i], chan_text)) {
 				val.value.enumerated.item[0] = i;
-- 
2.27.0



