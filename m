Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAA26DEE0D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjDLIjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjDLIj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D4F7DAF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8864263009
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B69AC433EF;
        Wed, 12 Apr 2023 08:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288619;
        bh=q1DQk/1pjkmNJsf5daQsG6IumlFBB/C9fgO6YQ7Nafs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KC77IQaV9m4SqMJQASI2m9szw9Y0CgUjGRf5o9cnRQGgFHPG1gVu9gR58kLqa9Kxb
         xOI8OTyL2TyhlSGicJs/YT4NoXEoewy6CtOYk0DBi9XEDv4RTz2f72qu+eizD92P4g
         E7tpS0BDXazkH3iBRlckQu/RkMhVYycTO1ooWmfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simei Su <simei.su@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/93] ice: fix wrong fallback logic for FDIR
Date:   Wed, 12 Apr 2023 10:33:47 +0200
Message-Id: <20230412082825.090000139@linuxfoundation.org>
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

From: Simei Su <simei.su@intel.com>

[ Upstream commit b4a01ace20f5c93c724abffc0a83ec84f514b98d ]

When adding a FDIR filter, if ice_vc_fdir_set_irq_ctx returns failure,
the inserted fdir entry will not be removed and if ice_vc_fdir_write_fltr
returns failure, the fdir context info for irq handler will not be cleared
which may lead to inconsistent or memory leak issue. This patch refines
failure cases to resolve this issue.

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Simei Su <simei.su@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 4b738f7391097..2254cae817c16 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -2136,7 +2136,7 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_dbg(dev, "VF %d: set FDIR context failed\n", vf->vf_id);
-		goto err_free_conf;
+		goto err_rem_entry;
 	}
 
 	ret = ice_vc_fdir_write_fltr(vf, conf, true, is_tun);
@@ -2145,15 +2145,16 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_err(dev, "VF %d: writing FDIR rule failed, ret:%d\n",
 			vf->vf_id, ret);
-		goto err_rem_entry;
+		goto err_clr_irq;
 	}
 
 exit:
 	kfree(stat);
 	return ret;
 
-err_rem_entry:
+err_clr_irq:
 	ice_vc_fdir_clear_irq_ctx(vf);
+err_rem_entry:
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 err_free_conf:
 	devm_kfree(dev, conf);
-- 
2.39.2



