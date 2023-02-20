Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E31F69CDB5
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjBTNwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjBTNwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7731E5E7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEEB6B80D4E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E9C433EF;
        Mon, 20 Feb 2023 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901116;
        bh=ux566SMcxf5tinG2b7keNJbkGbj86VcKuIV+OtvWxq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umxf/Z3elHeeW8IUg0PjL66+RFu754q/0dsreRlTTU8mtzZoOxcgdFmDdK1BD9br/
         P3Un5YC/Zki7NOPt8B2CR/IAotwpZC6Y7NwTrjoP1nULbUNxnfVahLfqj4+WpDzWk9
         SQriE1ChW/0iS1Qp33Q3S5UN6UGtcX2HuqvddFi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leo Li <sunpeng.li@amd.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 36/83] drm/amd/display: Fail atomic_check early on normalize_zpos error
Date:   Mon, 20 Feb 2023 14:36:09 +0100
Message-Id: <20230220133554.922991644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Li <sunpeng.li@amd.com>

commit 2a00299e7447395d0898e7c6214817c06a61a8e8 upstream.

[Why]

drm_atomic_normalize_zpos() can return an error code when there's
modeset lock contention. This was being ignored.

[How]

Bail out of atomic check if normalize_zpos() returns an error.

Fixes: b261509952bc ("drm/amd/display: Fix double cursor on non-video RGB MPO")
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10889,7 +10889,11 @@ static int amdgpu_dm_atomic_check(struct
 	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
 	 * atomic state, so call drm helper to normalize zpos.
 	 */
-	drm_atomic_normalize_zpos(dev, state);
+	ret = drm_atomic_normalize_zpos(dev, state);
+	if (ret) {
+		drm_dbg(dev, "drm_atomic_normalize_zpos() failed\n");
+		goto fail;
+	}
 
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {


