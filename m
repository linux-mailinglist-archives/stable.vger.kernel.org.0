Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F362701E4
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 18:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIRQPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 12:15:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:62825 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgIRQPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 12:15:52 -0400
IronPort-SDR: jkgQm8eCGE4IFWZjti0VCM6CAaLXUHVtxOJ7NlhaNmIQviGyWaZXNtf2GcAuapuv3f1geGTchr
 j/Djkyq/MkKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="157371539"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="157371539"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 09:15:49 -0700
IronPort-SDR: RX8HhHWiI6IVzixkdl7mac6iA1gg5yNnS0nNUKcLnMYJ+o/B8lsV7gU+2yYDnNTq4nH6Yj+oY0
 x+tJRZljAsew==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="307920854"
Received: from tsecasiu-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.213.179.236])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 09:15:48 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] ASoC: SOF: intel: hda: support also devices with 1 and 3 dmics
Date:   Fri, 18 Sep 2020 11:15:33 -0500
Message-Id: <20200918161533.166533-1-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@linux.intel.com>

[ Backported from Upstream commit 3dca35e35b42b3405ddad7ee95c02a2d8cf28592]

Currently the dmic check code supports only devices with 2 or 4 dmics.
With other dmic counts the function will return 0. Lately we've seen
devices with only 1 dmic thus enable also configurations with 1, and
possibly 3, dmics. Add also topology postfix -1ch and -3ch for new dmic
configuration.

Signed-off-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20200825235040.1586478-4-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
---

Note to -stable maintainers:

The Upstream commit 3dca35e35b42b3405ddad7ee95c02a2d8cf28592 can be
cherry-picked as is for kernel 5.6+. For kernel 5.4 and 5.5, the
backport provided in this patch is required (same functionality,
different location). Let me know in case I missed required information
(tags, etc).

 sound/soc/sof/intel/hda.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 91bd88fddac7..a3465e857c59 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -305,7 +305,7 @@ static int check_nhlt_dmic(struct snd_sof_dev *sdev)
 	if (nhlt) {
 		dmic_num = intel_nhlt_get_dmic_geo(sdev->dev, nhlt);
 		intel_nhlt_free(nhlt);
-		if (dmic_num == 2 || dmic_num == 4)
+		if (dmic_num >= 1 || dmic_num <= 4)
 			return dmic_num;
 	}
 
@@ -442,9 +442,15 @@ static int hda_init_caps(struct snd_sof_dev *sdev)
 				dmic_num = hda_dmic_num;
 
 			switch (dmic_num) {
+			case 1:
+				dmic_str = "-1ch";
+				break;
 			case 2:
 				dmic_str = "-2ch";
 				break;
+			case 3:
+				dmic_str = "-3ch";
+				break;
 			case 4:
 				dmic_str = "-4ch";
 				break;
-- 
2.25.1

