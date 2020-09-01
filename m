Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D5259905
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgIAQff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730597AbgIAPaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6333D20684;
        Tue,  1 Sep 2020 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974219;
        bh=629+49mpM0RMi+i39YNvE37+uGnqLXIa4iJPk9vUMew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmhQatE4cyyvSdOJsvA8aSfk4LdGlpiu/0SvebG04YvVZJQR5HuBG+oW4eoZ77STT
         vaYkv+Kz6v4ksQaHE9FkNyd8WCVuoihbUgX9lf4hnQz+eX5BgVjrKLojF8rU8yJNCv
         0YFrcZ8cFFqj6m8X+yBkyH/SIJeIOo/Bb3+vw1mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/214] EDAC: sb_edac: get rid of unused vars
Date:   Tue,  1 Sep 2020 17:09:30 +0200
Message-Id: <20200901150957.306703857@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit 323014d85d2699b2879ecb15cd06a15408e3e801 ]

There are several vars unused on this driver, probably because
it was a modified copy of another driver. Get rid of them.

	drivers/edac/sb_edac.c: In function ‘knl_get_dimm_capacity’:
	drivers/edac/sb_edac.c:1343:16: warning: variable ‘sad_size’ set but not used [-Wunused-but-set-variable]
	 1343 |  u64 sad_base, sad_size, sad_limit = 0;
	      |                ^~~~~~~~
	drivers/edac/sb_edac.c: In function ‘sbridge_mce_output_error’:
	drivers/edac/sb_edac.c:2955:8: warning: variable ‘type’ set but not used [-Wunused-but-set-variable]
	 2955 |  char *type, *optype, msg[256];
	      |        ^~~~
	drivers/edac/sb_edac.c: In function ‘sbridge_unregister_mci’:
	drivers/edac/sb_edac.c:3203:22: warning: variable ‘pvt’ set but not used [-Wunused-but-set-variable]
	 3203 |  struct sbridge_pvt *pvt;
	      |                      ^~~
	At top level:
	drivers/edac/sb_edac.c:266:18: warning: ‘correrrthrsld’ defined but not used [-Wunused-const-variable=]
	  266 | static const u32 correrrthrsld[] = {
	      |                  ^~~~~~~~~~~~~
	drivers/edac/sb_edac.c:257:18: warning: ‘correrrcnt’ defined but not used [-Wunused-const-variable=]
	  257 | static const u32 correrrcnt[] = {
	      |                  ^~~~~~~~~~

Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/sb_edac.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index f743502ca9b72..a2fd39d330d67 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -254,18 +254,20 @@ static const u32 rir_offset[MAX_RIR_RANGES][MAX_RIR_WAY] = {
  * FIXME: Implement the error count reads directly
  */
 
-static const u32 correrrcnt[] = {
-	0x104, 0x108, 0x10c, 0x110,
-};
-
 #define RANK_ODD_OV(reg)		GET_BITFIELD(reg, 31, 31)
 #define RANK_ODD_ERR_CNT(reg)		GET_BITFIELD(reg, 16, 30)
 #define RANK_EVEN_OV(reg)		GET_BITFIELD(reg, 15, 15)
 #define RANK_EVEN_ERR_CNT(reg)		GET_BITFIELD(reg,  0, 14)
 
+#if 0 /* Currently unused*/
+static const u32 correrrcnt[] = {
+	0x104, 0x108, 0x10c, 0x110,
+};
+
 static const u32 correrrthrsld[] = {
 	0x11c, 0x120, 0x124, 0x128,
 };
+#endif
 
 #define RANK_ODD_ERR_THRSLD(reg)	GET_BITFIELD(reg, 16, 30)
 #define RANK_EVEN_ERR_THRSLD(reg)	GET_BITFIELD(reg,  0, 14)
@@ -1340,7 +1342,7 @@ static void knl_show_mc_route(u32 reg, char *s)
  */
 static int knl_get_dimm_capacity(struct sbridge_pvt *pvt, u64 *mc_sizes)
 {
-	u64 sad_base, sad_size, sad_limit = 0;
+	u64 sad_base, sad_limit = 0;
 	u64 tad_base, tad_size, tad_limit, tad_deadspace, tad_livespace;
 	int sad_rule = 0;
 	int tad_rule = 0;
@@ -1427,7 +1429,6 @@ static int knl_get_dimm_capacity(struct sbridge_pvt *pvt, u64 *mc_sizes)
 		edram_only = KNL_EDRAM_ONLY(dram_rule);
 
 		sad_limit = pvt->info.sad_limit(dram_rule)+1;
-		sad_size = sad_limit - sad_base;
 
 		pci_read_config_dword(pvt->pci_sad0,
 			pvt->info.interleave_list[sad_rule], &interleave_reg);
@@ -2952,7 +2953,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	struct mem_ctl_info *new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	enum hw_event_mc_err_type tp_event;
-	char *type, *optype, msg[256];
+	char *optype, msg[256];
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -2981,14 +2982,11 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	if (uncorrected_error) {
 		core_err_cnt = 1;
 		if (ripv) {
-			type = "FATAL";
 			tp_event = HW_EVENT_ERR_FATAL;
 		} else {
-			type = "NON_FATAL";
 			tp_event = HW_EVENT_ERR_UNCORRECTED;
 		}
 	} else {
-		type = "CORRECTED";
 		tp_event = HW_EVENT_ERR_CORRECTED;
 	}
 
@@ -3200,7 +3198,6 @@ static struct notifier_block sbridge_mce_dec = {
 static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 {
 	struct mem_ctl_info *mci = sbridge_dev->mci;
-	struct sbridge_pvt *pvt;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
 		edac_dbg(0, "MC: dev = %p\n", &sbridge_dev->pdev[0]->dev);
@@ -3209,8 +3206,6 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 		return;
 	}
 
-	pvt = mci->pvt_info;
-
 	edac_dbg(0, "MC: mci = %p, dev = %p\n",
 		 mci, &sbridge_dev->pdev[0]->dev);
 
-- 
2.25.1



