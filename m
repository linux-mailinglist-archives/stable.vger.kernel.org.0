Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C14643318
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiLETeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbiLETdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A8429C86
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:28:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FAEDB81151
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E6C433C1;
        Mon,  5 Dec 2022 19:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268535;
        bh=uRiz/7ZR84PYbS5hlv7q4zz95OQcM1eDd4FDAbcQ+BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIqxfsCu3eUHhPIwmFsADVB8MaPfkC5xRXiBSH6Z5udjObpq3KIFTwOXbPoFhZDcl
         JMzjzzPha/nITOdwvti6z03ENBy8rtK0SoqdGbTaq5okD3EwoabKCxOVH1258QTKc/
         6gg79qGmnIHXKUY7M1J5ixWW7nhrlMhBvTf0dqkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lyude Paul <lyude@redhat.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/92] drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code
Date:   Mon,  5 Dec 2022 20:09:18 +0100
Message-Id: <20221205190803.649979530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 2f3a1273862cb82cca227630cc7f04ce0c94b6bb ]

Looks like that we're accidentally dropping a pretty important return code
here. For some reason, we just return -EINVAL if we fail to get the MST
topology state. This is wrong: error codes are important and should never
be squashed without being handled, which here seems to have the potential
to cause a deadlock.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Fixes: 8ec046716ca8 ("drm/dp_mst: Add helper to trigger modeset on affected DSC MST CRTCs")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 4272cd3622f8..0feeac52e4eb 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -5238,7 +5238,7 @@ int drm_dp_mst_add_affected_dsc_crtcs(struct drm_atomic_state *state, struct drm
 	mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 
 	if (IS_ERR(mst_state))
-		return -EINVAL;
+		return PTR_ERR(mst_state);
 
 	list_for_each_entry(pos, &mst_state->vcpis, next) {
 
-- 
2.35.1



