Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC4160887E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbiJVIRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiJVIQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:16:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D7CFF20A;
        Sat, 22 Oct 2022 00:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4AE6B82DFE;
        Sat, 22 Oct 2022 07:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4CEC433C1;
        Sat, 22 Oct 2022 07:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424857;
        bh=Vp52VCPyvK1uo9tqWME7V3/uLHnMjoZvQgmyVTyQAMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz/wxypvxh9k7XoYZNbM4NAnmiI1ylJuujlR0akBjeXQrK2CjBljRyqGbN2feq44A
         z94UAqkUuU+ctabhyrVHLY1LWk+64e8llLRZ0DEM6gx+a+uqpBpy+41C+IzuPHxiZX
         9i931XEDDRxqBw3rCUQpeelbPl8/A/sMH+Q+ZMpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Lyude Paul <lyude@redhat.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 303/717] drm/dp_mst: fix drm_dp_dpcd_read return value checks
Date:   Sat, 22 Oct 2022 09:23:02 +0200
Message-Id: <20221022072506.436381005@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit 2ac6cdd581f48c8f68747156fde5868486a44985 ]

drm_dp_dpcd_read returns the number of bytes read. The previous code
would print garbage on DPCD error, and would exit with on error on
success.

Signed-off-by: Simon Ser <contact@emersion.fr>
Fixes: cb897542c6d2 ("drm/dp_mst: Fix W=1 warnings")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/473500/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 18f2b6075b78..28dd741f7da1 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -4916,14 +4916,14 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 		seq_printf(m, "dpcd: %*ph\n", DP_RECEIVER_CAP_SIZE, buf);
 
 		ret = drm_dp_dpcd_read(mgr->aux, DP_FAUX_CAP, buf, 2);
-		if (ret) {
+		if (ret != 2) {
 			seq_printf(m, "faux/mst read failed\n");
 			goto out;
 		}
 		seq_printf(m, "faux/mst: %*ph\n", 2, buf);
 
 		ret = drm_dp_dpcd_read(mgr->aux, DP_MSTM_CTRL, buf, 1);
-		if (ret) {
+		if (ret != 1) {
 			seq_printf(m, "mst ctrl read failed\n");
 			goto out;
 		}
@@ -4931,7 +4931,7 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 
 		/* dump the standard OUI branch header */
 		ret = drm_dp_dpcd_read(mgr->aux, DP_BRANCH_OUI, buf, DP_BRANCH_OUI_HEADER_SIZE);
-		if (ret) {
+		if (ret != DP_BRANCH_OUI_HEADER_SIZE) {
 			seq_printf(m, "branch oui read failed\n");
 			goto out;
 		}
-- 
2.35.1



