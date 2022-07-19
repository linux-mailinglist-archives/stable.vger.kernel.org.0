Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F78F579C39
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiGSMh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbiGSMgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA98BDFF2;
        Tue, 19 Jul 2022 05:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC9CB81B29;
        Tue, 19 Jul 2022 12:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE27C341C6;
        Tue, 19 Jul 2022 12:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232822;
        bh=y9MZsfiKWmE9o7hdDmgnWIaSt3gGlLNSa1w+FAX5XZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ace7C8U114FOe7bb1ZjC9M1GVuRFSqvKswqP2rrWRxm0UAriWJ7untQ0beNdcEtCd
         9jHNiO78WjksPE1DBEacQxDL+dOusQFeAeBOkhzJ6tymvFq7vx93q1afpWfg0C7QeU
         66lF9RLHP9dJdrTnMh/g4gouaGA4ZY6zYk1IFqVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/167] drm/i915/uc: correctly track uc_fw init failure
Date:   Tue, 19 Jul 2022 13:53:30 +0200
Message-Id: <20220719114704.104835461@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 35d4efec103e1afde968cfc9305f00f9aceb19cc ]

The FAILURE state of uc_fw currently implies that the fw is loadable
(i.e init completed), so we can't use it for init failures and instead
need a dedicated error code.

Note that this currently does not cause any issues because if we fail to
init any of the firmwares we abort the load, but better be accurate
anyway in case things change in the future.

Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211211000756.1698923-2-daniele.ceraolospurio@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_huc.c    |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c  |  4 ++--
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h  | 17 +++++++++++------
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
index 76fe766ad1bc..bb951b8d5203 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
@@ -159,6 +159,6 @@ int intel_guc_fw_upload(struct intel_guc *guc)
 	return 0;
 
 out:
-	intel_uc_fw_change_status(&guc->fw, INTEL_UC_FIRMWARE_FAIL);
+	intel_uc_fw_change_status(&guc->fw, INTEL_UC_FIRMWARE_LOAD_FAIL);
 	return ret;
 }
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_huc.c b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
index fc5387b410a2..9ee22ac92540 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_huc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
@@ -191,7 +191,7 @@ int intel_huc_auth(struct intel_huc *huc)
 
 fail:
 	i915_probe_error(gt->i915, "HuC: Authentication failed %d\n", ret);
-	intel_uc_fw_change_status(&huc->fw, INTEL_UC_FIRMWARE_FAIL);
+	intel_uc_fw_change_status(&huc->fw, INTEL_UC_FIRMWARE_LOAD_FAIL);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 3a16d08608a5..6be7fbf9d18a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -526,7 +526,7 @@ int intel_uc_fw_upload(struct intel_uc_fw *uc_fw, u32 dst_offset, u32 dma_flags)
 	i915_probe_error(gt->i915, "Failed to load %s firmware %s (%d)\n",
 			 intel_uc_fw_type_repr(uc_fw->type), uc_fw->path,
 			 err);
-	intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_FAIL);
+	intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_LOAD_FAIL);
 	return err;
 }
 
@@ -544,7 +544,7 @@ int intel_uc_fw_init(struct intel_uc_fw *uc_fw)
 	if (err) {
 		DRM_DEBUG_DRIVER("%s fw pin-pages err=%d\n",
 				 intel_uc_fw_type_repr(uc_fw->type), err);
-		intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_FAIL);
+		intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_INIT_FAIL);
 	}
 
 	return err;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
index 99bb1fe1af66..c1a7246fb7d6 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
@@ -31,11 +31,12 @@ struct intel_gt;
  * |            |    MISSING <--/    |    \--> ERROR                |
  * |   fetch    |                    V                              |
  * |            |                 AVAILABLE                         |
- * +------------+-                   |                             -+
+ * +------------+-                   |   \                         -+
+ * |            |                    |    \--> INIT FAIL            |
  * |   init     |                    V                              |
  * |            |        /------> LOADABLE <----<-----------\       |
  * +------------+-       \         /    \        \           \     -+
- * |            |         FAIL <--<      \--> TRANSFERRED     \     |
+ * |            |    LOAD FAIL <--<      \--> TRANSFERRED     \     |
  * |   upload   |                  \           /   \          /     |
  * |            |                   \---------/     \--> RUNNING    |
  * +------------+---------------------------------------------------+
@@ -49,8 +50,9 @@ enum intel_uc_fw_status {
 	INTEL_UC_FIRMWARE_MISSING, /* blob not found on the system */
 	INTEL_UC_FIRMWARE_ERROR, /* invalid format or version */
 	INTEL_UC_FIRMWARE_AVAILABLE, /* blob found and copied in mem */
+	INTEL_UC_FIRMWARE_INIT_FAIL, /* failed to prepare fw objects for load */
 	INTEL_UC_FIRMWARE_LOADABLE, /* all fw-required objects are ready */
-	INTEL_UC_FIRMWARE_FAIL, /* failed to xfer or init/auth the fw */
+	INTEL_UC_FIRMWARE_LOAD_FAIL, /* failed to xfer or init/auth the fw */
 	INTEL_UC_FIRMWARE_TRANSFERRED, /* dma xfer done */
 	INTEL_UC_FIRMWARE_RUNNING /* init/auth done */
 };
@@ -121,10 +123,12 @@ const char *intel_uc_fw_status_repr(enum intel_uc_fw_status status)
 		return "ERROR";
 	case INTEL_UC_FIRMWARE_AVAILABLE:
 		return "AVAILABLE";
+	case INTEL_UC_FIRMWARE_INIT_FAIL:
+		return "INIT FAIL";
 	case INTEL_UC_FIRMWARE_LOADABLE:
 		return "LOADABLE";
-	case INTEL_UC_FIRMWARE_FAIL:
-		return "FAIL";
+	case INTEL_UC_FIRMWARE_LOAD_FAIL:
+		return "LOAD FAIL";
 	case INTEL_UC_FIRMWARE_TRANSFERRED:
 		return "TRANSFERRED";
 	case INTEL_UC_FIRMWARE_RUNNING:
@@ -146,7 +150,8 @@ static inline int intel_uc_fw_status_to_error(enum intel_uc_fw_status status)
 		return -ENOENT;
 	case INTEL_UC_FIRMWARE_ERROR:
 		return -ENOEXEC;
-	case INTEL_UC_FIRMWARE_FAIL:
+	case INTEL_UC_FIRMWARE_INIT_FAIL:
+	case INTEL_UC_FIRMWARE_LOAD_FAIL:
 		return -EIO;
 	case INTEL_UC_FIRMWARE_SELECTED:
 		return -ESTALE;
-- 
2.35.1



