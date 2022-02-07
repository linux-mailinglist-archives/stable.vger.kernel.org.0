Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161B74ABFD8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiBGNoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358103AbiBGN1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:27:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B3FC043181
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 05:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644240429; x=1675776429;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Set1mcUkQ4+KFe79Ox6jaYcx/9lWkeScNRjlFJWUwQY=;
  b=SdPslxNLsCJKoOuNY9GK/XupueYNZucRTPH2mPV9QBVBK6NWR32zwdLl
   K5FgX8DSOls9ydzyciAhCbJ7VcAMTWHh2Hay/Qk39pd/gA8LKQM7U7Pdo
   27ZaFcV6iaDXLj/GDXU8kTwhQquoMuKUnVX2x1P11Sdp16yHsuX5o6+cn
   mCRjq4JL2oBxGc+C6GNi5puLZwhVcub7bYgDiWU6c1Mz/NJzjngVKCRNd
   EZihCHf5UihiBaF870tuf3CP7soxn7Jwh4gOqQ1PWL99IMrAIHcBLzofX
   diAXr5hkSqWYM5jiinm/9rFSMhNF1o2/oiX8SoFomZDij8S9yx3ugycp0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10250"; a="228682715"
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="228682715"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 05:27:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="525132955"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga007.jf.intel.com with SMTP; 07 Feb 2022 05:27:00 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 07 Feb 2022 15:27:00 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i195: Fix dbuf slice config lookup
Date:   Mon,  7 Feb 2022 15:26:59 +0200
Message-Id: <20220207132700.481-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Apparently I totally fumbled the loop condition when I
removed the ARRAY_SIZE() stuff from the dbuf slice config
lookup. Comparing the loop index with the active_pipes bitmask
is utter nonsense, what we want to do is check to see if the
mask is zero or not.

Cc: stable@vger.kernel.org
Fixes: 05e8155afe35 ("drm/i915: Use a sentinel to terminate the dbuf slice arrays")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 02084652fe3d..da721aea70ff 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4848,7 +4848,7 @@ static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus,
 {
 	int i;
 
-	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
+	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {
 		if (dbuf_slices[i].active_pipes == active_pipes &&
 		    dbuf_slices[i].join_mbus == join_mbus)
 			return dbuf_slices[i].dbuf_mask[pipe];
-- 
2.34.1

