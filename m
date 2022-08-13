Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2AE591A5A
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiHMMvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbiHMMvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:51:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2358914D38
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5956CE0025
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2ECC433C1;
        Sat, 13 Aug 2022 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395099;
        bh=Uo+C122sHW/sfOSASXjsLdz5rWxlbihovEj1Q0husV8=;
        h=Subject:To:Cc:From:Date:From;
        b=1BUnb7HnTpUFtE8S3GNzpBofhK3ybVNpUoeO5P4VYGpHdbfR+jpmDlGuyFRn4tJ3Z
         kK9MMI+BgHwki0Kr+OzWo3vIPDQwLdWbvzS/T8JARY/t6vHjEvw1vEvzIDVnw9+Erh
         J/zDaznxCz6wQkOD4BzdTKJ6/LqNZHX6YdZlGm2w=
Subject: FAILED: patch "[PATCH] drm/dp/mst: Read the extended DPCD capabilities during system" failed to apply to 5.18-stable tree
To:     imre.deak@intel.com, jani.nikula@intel.com, lyude@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:51:36 +0200
Message-ID: <1660395096239162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a710a8bc909313951eb9252d8419924c771d7c2 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Tue, 14 Jun 2022 12:45:37 +0300
Subject: [PATCH] drm/dp/mst: Read the extended DPCD capabilities during system
 resume

The WD22TB4 Thunderbolt dock at least will revert its DP_MAX_LINK_RATE
from HBR3 to HBR2 after system suspend/resume if the DP_DP13_DPCD_REV
registers are not read subsequently also as required.

Fix this by reading DP_DP13_DPCD_REV registers as well, matching what is
done during connector detection. While at it also fix up the same call
in drm_dp_mst_dump_topology().

Cc: Lyude Paul <lyude@redhat.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5292
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v5.14+
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220614094537.885472-1-imre.deak@intel.com

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 9aa2c20904e3..93651bc9a02c 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3860,9 +3860,7 @@ int drm_dp_mst_topology_mgr_resume(struct drm_dp_mst_topology_mgr *mgr,
 	if (!mgr->mst_primary)
 		goto out_fail;
 
-	ret = drm_dp_dpcd_read(mgr->aux, DP_DPCD_REV, mgr->dpcd,
-			       DP_RECEIVER_CAP_SIZE);
-	if (ret != DP_RECEIVER_CAP_SIZE) {
+	if (drm_dp_read_dpcd_caps(mgr->aux, mgr->dpcd) < 0) {
 		drm_dbg_kms(mgr->dev, "dpcd read failed - undocked during suspend?\n");
 		goto out_fail;
 	}
@@ -4910,8 +4908,7 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 		u8 buf[DP_PAYLOAD_TABLE_SIZE];
 		int ret;
 
-		ret = drm_dp_dpcd_read(mgr->aux, DP_DPCD_REV, buf, DP_RECEIVER_CAP_SIZE);
-		if (ret) {
+		if (drm_dp_read_dpcd_caps(mgr->aux, buf) < 0) {
 			seq_printf(m, "dpcd read failed\n");
 			goto out;
 		}

