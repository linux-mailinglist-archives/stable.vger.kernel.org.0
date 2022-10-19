Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAF603D77
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiJSJCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiJSJBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:01:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61AC8E0E8;
        Wed, 19 Oct 2022 01:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA13617E8;
        Wed, 19 Oct 2022 08:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A164FC433D6;
        Wed, 19 Oct 2022 08:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169656;
        bh=C1rwG8z2GfL29LvFgqELgKitE9ciVJlqDiNdRtp24lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uskLR9PpRwBmdDUryxzBYZrn1AgMU2WmV2Ly73iF9bFE4BeedQ9yDKkBayLBZ4ZqH
         75Ngbqi+reJWgWbThZhOUdmOf/gkASwFIfKVjpW4gfs2LCV4Hi/pU5Q65ZfAik2aLg
         nxTcRKQCoPNkwyJhlouwad8wVycDPN+UXv4aNOcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Lyude Paul <lyude@redhat.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 358/862] drm/dp_mst: fix drm_dp_dpcd_read return value checks
Date:   Wed, 19 Oct 2022 10:27:25 +0200
Message-Id: <20221019083305.822247722@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 57e65423e50d..7a94a5288e8d 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -4907,14 +4907,14 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
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
@@ -4922,7 +4922,7 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 
 		/* dump the standard OUI branch header */
 		ret = drm_dp_dpcd_read(mgr->aux, DP_BRANCH_OUI, buf, DP_BRANCH_OUI_HEADER_SIZE);
-		if (ret) {
+		if (ret != DP_BRANCH_OUI_HEADER_SIZE) {
 			seq_printf(m, "branch oui read failed\n");
 			goto out;
 		}
-- 
2.35.1



