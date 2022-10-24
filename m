Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F330B60B1FC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiJXQlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiJXQlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:41:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF1BCA8A1;
        Mon, 24 Oct 2022 08:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AC5DB8198E;
        Mon, 24 Oct 2022 12:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE3BC433D6;
        Mon, 24 Oct 2022 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615342;
        bh=uCwDTPvAmBCJuKXN3Jqav2b+F4g1SwvzbWav77fECBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eX3/GCNJmrxOGXBx1nSk6LRQObe3P+t/WfrFflcpfs0sgJWe+TTKR3Ly1hgyw5IIm
         VyfhvZRIwXFHA/l0rRVZEvQUtW1oDqO/+zsm3gYEoz7SuXoH9CqThKiwW0CfsDO5ge
         6cCVUqTCEwDfsSs9aTejCp3g68B7NvUZ+W/DJlNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Lyude Paul <lyude@redhat.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/530] drm/dp_mst: fix drm_dp_dpcd_read return value checks
Date:   Mon, 24 Oct 2022 13:29:18 +0200
Message-Id: <20221024113054.766507107@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/gpu/drm/drm_dp_mst_topology.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 2a586e6489da..9bf9430209b0 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4899,14 +4899,14 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
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
@@ -4914,7 +4914,7 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 
 		/* dump the standard OUI branch header */
 		ret = drm_dp_dpcd_read(mgr->aux, DP_BRANCH_OUI, buf, DP_BRANCH_OUI_HEADER_SIZE);
-		if (ret) {
+		if (ret != DP_BRANCH_OUI_HEADER_SIZE) {
 			seq_printf(m, "branch oui read failed\n");
 			goto out;
 		}
-- 
2.35.1



