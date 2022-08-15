Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7880C5944D3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350493AbiHOWMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343878AbiHOWJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692CC118DF3;
        Mon, 15 Aug 2022 12:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD90161089;
        Mon, 15 Aug 2022 19:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8107C433C1;
        Mon, 15 Aug 2022 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592288;
        bh=4kWpvds5+KHinS6js9xlfUJTVF6X7GeWKvqhOatybJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeDIsoYfF3oKNyRSQrvMjHp82eX8kMovMwdaK3SCcKJ5pW6abN6wJ78dhHAFloPYK
         fRs8QWFYzTDiuqPb1yh2PZMR85g2Rd7O4EVgqZYPrFqLV21WnF9Tj6sEBZzKe4AGLd
         LShpctS16X3w2BzBU0rV3MrsytGOMjJFKzNTzXAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.19 0088/1157] drm/dp/mst: Read the extended DPCD capabilities during system resume
Date:   Mon, 15 Aug 2022 19:50:44 +0200
Message-Id: <20220815180443.089201685@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 7a710a8bc909313951eb9252d8419924c771d7c2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3860,9 +3860,7 @@ int drm_dp_mst_topology_mgr_resume(struc
 	if (!mgr->mst_primary)
 		goto out_fail;
 
-	ret = drm_dp_dpcd_read(mgr->aux, DP_DPCD_REV, mgr->dpcd,
-			       DP_RECEIVER_CAP_SIZE);
-	if (ret != DP_RECEIVER_CAP_SIZE) {
+	if (drm_dp_read_dpcd_caps(mgr->aux, mgr->dpcd) < 0) {
 		drm_dbg_kms(mgr->dev, "dpcd read failed - undocked during suspend?\n");
 		goto out_fail;
 	}
@@ -4911,8 +4909,7 @@ void drm_dp_mst_dump_topology(struct seq
 		u8 buf[DP_PAYLOAD_TABLE_SIZE];
 		int ret;
 
-		ret = drm_dp_dpcd_read(mgr->aux, DP_DPCD_REV, buf, DP_RECEIVER_CAP_SIZE);
-		if (ret) {
+		if (drm_dp_read_dpcd_caps(mgr->aux, buf) < 0) {
 			seq_printf(m, "dpcd read failed\n");
 			goto out;
 		}


