Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1144ABFDB
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353403AbiBGNoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378937AbiBGN2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:28:10 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 05:28:09 PST
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD7EC043188
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 05:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644240489; x=1675776489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R8OE7+G9G6ox8L1pd9KS7MLF8Tsh+GrRnlJOa0YFpmM=;
  b=fBOa6bn139VVCJIduaWtEcn4fW+xr/YDzoUOKBf22EdyKQyc2JzE1Pr1
   EfxZkyflr/DapJSwkiNlUAj2/wQEhfz1Nlu6iWIshCtG0yiTYz883l4Y6
   6yB0a4jtsGLB59Nm0b9SR4GmHC1pFGyQfKPcq9xSw/zjytNYmJd94yMOJ
   CJMrVyxXPf8QG2rhNf2ef/qgllEXMVULLw90GZAuOEUvWIknviicWWkGm
   LaUt7lS9ar0dDN6hAMVEgNxGalREIYS+n5jVWybCjso4z5MhHdY/7A9k7
   8Wbtz83Vdq1lnUcqvH1kN25uNawSPbZbHg2zXwAjZN25LCQDvcQfhkCJu
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10250"; a="309456133"
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="309456133"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 05:27:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="484419454"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga006.jf.intel.com with SMTP; 07 Feb 2022 05:27:03 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 07 Feb 2022 15:27:03 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915: Fix mbus join config lookup
Date:   Mon,  7 Feb 2022 15:27:00 +0200
Message-Id: <20220207132700.481-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207132700.481-1-ville.syrjala@linux.intel.com>
References: <20220207132700.481-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The bogus loop from compute_dbuf_slices() was copied into
check_mbus_joined() as well. So this lookup is wrong as well.
Fix it.

Cc: stable@vger.kernel.org
Fixes: f4dc00863226 ("drm/i915/adl_p: MBUS programming")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index da721aea70ff..23d4bb011fc8 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4831,7 +4831,7 @@ static bool check_mbus_joined(u8 active_pipes,
 {
 	int i;
 
-	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
+	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {
 		if (dbuf_slices[i].active_pipes == active_pipes)
 			return dbuf_slices[i].join_mbus;
 	}
-- 
2.34.1

