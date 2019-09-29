Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C88C1590
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfI2OA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfI2OA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:00:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9752E2082F;
        Sun, 29 Sep 2019 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765657;
        bh=0ypLSC/KcmwjLgn3ht6PIFJ6s8BN10R4v6dsLwp00z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ga/9oN/LnA0XE4kzQ9i1O1dAnFRA24WdDxcl7V1gvHkqPyuI3uo66jDiYhl+se+n+
         2vw7qmSMVeQhLoVMbzkv3eV4v2smc/m1WpLUC7hcqt9oGPnRiTiyxhetIqFJlR7nA/
         1ZDuCukxxzGir6lV/PKrBtY/I9pSDAO5fw+ZBx5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Francis <david.francis@amd.com>
Subject: [PATCH 5.2 07/45] drm/amd/display: Skip determining update type for async updates
Date:   Sun, 29 Sep 2019 15:55:35 +0200
Message-Id: <20190929135026.938374147@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 43d10d30df156f7834fa91aecb69614fefc8bb0a upstream.

[Why]
By passing through the dm_determine_update_type_for_commit for atomic
commits that can be done asynchronously we are incurring a
performance penalty by locking access to the global private object
and holding that access until the end of the programming sequence.

This is also allocating a new large dc_state on every access in addition
to retaining all the references on each stream and plane until the end
of the programming sequence.

[How]
Shift the determination for async update before validation. Return early
if it's going to be an async update.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: David Francis <david.francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   27 ++++++++++++++++------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6788,6 +6788,26 @@ static int amdgpu_dm_atomic_check(struct
 	if (ret)
 		goto fail;
 
+	if (state->legacy_cursor_update) {
+		/*
+		 * This is a fast cursor update coming from the plane update
+		 * helper, check if it can be done asynchronously for better
+		 * performance.
+		 */
+		state->async_update =
+			!drm_atomic_helper_async_check(dev, state);
+
+		/*
+		 * Skip the remaining global validation if this is an async
+		 * update. Cursor updates can be done without affecting
+		 * state or bandwidth calcs and this avoids the performance
+		 * penalty of locking the private state object and
+		 * allocating a new dc_state.
+		 */
+		if (state->async_update)
+			return 0;
+	}
+
 	/* Check scaling and underscan changes*/
 	/* TODO Removed scaling changes validation due to inability to commit
 	 * new stream into context w\o causing full reset. Need to
@@ -6840,13 +6860,6 @@ static int amdgpu_dm_atomic_check(struct
 			ret = -EINVAL;
 			goto fail;
 		}
-	} else if (state->legacy_cursor_update) {
-		/*
-		 * This is a fast cursor update coming from the plane update
-		 * helper, check if it can be done asynchronously for better
-		 * performance.
-		 */
-		state->async_update = !drm_atomic_helper_async_check(dev, state);
 	}
 
 	/* Must be success */


