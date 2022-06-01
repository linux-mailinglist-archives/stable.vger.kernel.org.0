Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CD8539A49
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 02:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiFAAJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 20:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbiFAAJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 20:09:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F6E2A27B
        for <stable@vger.kernel.org>; Tue, 31 May 2022 17:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654042195; x=1685578195;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KbUFUKa0xNNrwnWIg7wRXELbPC4TrapU+Kx1YFcXwGE=;
  b=dcONkxLx7jVcwQJ33ROKlkaypA8PAYKXWlm3hgSAIYIsyb7lM1gYvUI4
   xizVsH7EYqsF/fV5zqt5Z1xBA4qSTfFOdnAC4eJ2SBA4VMP0P547F0sHe
   Bah6DJASPbT/mB3ne7amtOTJBIXnYHk9NPg1rgUkFGDXMfBUnzRbAVb1U
   NmYRAgjfAbMJLDesr3IX6XpPJU1+SjQSzA7Ij9ts1nOvdcyOMhGHLL8e9
   RfqcgpD+i/oTfurkQknPeG/pcaNy3qeWa0cZKoLTs/++kaYe1bErt0ROy
   gxsIGEgn/ESECynrEhWqlpcKkQQnT588+WSJSdjCbDRYROWPKECrfgUVE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="275431168"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="275431168"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 17:09:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="562554678"
Received: from weesiong-mobl.amr.corp.intel.com (HELO [192.168.1.137]) ([10.209.41.108])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 17:09:55 -0700
Subject: [PATCH] nvdimm: Fix badblocks clear off-by-one error
From:   Dan Williams <dan.j.williams@intel.com>
To:     nvdimm@lists.linux.dev
Cc:     stable@vger.kernel.org, Chris Ye <chris.ye@intel.com>
Date:   Tue, 31 May 2022 17:09:54 -0700
Message-ID: <165404219489.2445897.9792886413715690399.stgit@dwillia2-xfh>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Ye <chris.ye@intel.com>

nvdimm_clear_badblocks_region() validates badblock clearing requests
against the span of the region, however it compares the inclusive
badblock request range to the exclusive region range. Fix up the
off-by-one error.

Fixes: 23f498448362 ("libnvdimm: rework region badblocks clearing")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Ye <chris.ye@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7b0d1443217a..5db16857b80e 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -182,8 +182,8 @@ static int nvdimm_clear_badblocks_region(struct device *dev, void *data)
 	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
 
 	/* make sure we are in the region */
-	if (ctx->phys < nd_region->ndr_start
-			|| (ctx->phys + ctx->cleared) > ndr_end)
+	if (ctx->phys < nd_region->ndr_start ||
+	    (ctx->phys + ctx->cleared - 1) > ndr_end)
 		return 0;
 
 	sector = (ctx->phys - nd_region->ndr_start) / 512;

