Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208876DEE0E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjDLIjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjDLIja (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E447AAA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A47E63007
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC7CC433D2;
        Wed, 12 Apr 2023 08:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288621;
        bh=YWIk9rT/Gtmv4gf/oTVvDysdaVPmfHuPrk0fUPlqNAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lqq7XvXeeleU9sXkoFNaPvXTubBlcsW219o/zuOzN63HPcG1oan6Bk/5w1hhVpgpH
         1rWVEjuECd0nWCvyh4C6Ju4Kihp7bdzg1mcZrNNRb+me/6gmwJgZSOcTPyv6HXNS3Q
         ZOeiW9nM8jk4hZYMA96dCxIaClUZnxi1Ab9hptho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Junfeng Guo <junfeng.guo@intel.com>,
        Lingyu Liu <lingyu.liu@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/93] ice: Reset FDIR counter in FDIR init stage
Date:   Wed, 12 Apr 2023 10:33:48 +0200
Message-Id: <20230412082825.130302728@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lingyu Liu <lingyu.liu@intel.com>

[ Upstream commit 83c911dc5e0e8e6eaa6431c06972a8f159bfe2fc ]

Reset the FDIR counters when FDIR inits. Without this patch,
when VF initializes or resets, all the FDIR counters are not
cleaned, which may cause unexpected behaviors for future FDIR
rule create (e.g., rule conflict).

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Junfeng Guo <junfeng.guo@intel.com>
Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_fdir.c   | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 2254cae817c16..412deb36b645b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -731,6 +731,21 @@ static void ice_vc_fdir_rem_prof_all(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_vc_fdir_reset_cnt_all - reset all FDIR counters for this VF FDIR
+ * @fdir: pointer to the VF FDIR structure
+ */
+static void ice_vc_fdir_reset_cnt_all(struct ice_vf_fdir *fdir)
+{
+	enum ice_fltr_ptype flow;
+
+	for (flow = ICE_FLTR_PTYPE_NONF_NONE;
+	     flow < ICE_FLTR_PTYPE_MAX; flow++) {
+		fdir->fdir_fltr_cnt[flow][0] = 0;
+		fdir->fdir_fltr_cnt[flow][1] = 0;
+	}
+}
+
 /**
  * ice_vc_fdir_has_prof_conflict
  * @vf: pointer to the VF structure
@@ -2263,6 +2278,7 @@ void ice_vf_fdir_init(struct ice_vf *vf)
 	spin_lock_init(&fdir->ctx_lock);
 	fdir->ctx_irq.flags = 0;
 	fdir->ctx_done.flags = 0;
+	ice_vc_fdir_reset_cnt_all(fdir);
 }
 
 /**
-- 
2.39.2



