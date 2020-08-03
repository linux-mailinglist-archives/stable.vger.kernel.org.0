Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AA423A409
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgHCMWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgHCMWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E0C520738;
        Mon,  3 Aug 2020 12:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457319;
        bh=NR5D6eysUwhAEOc3EJ8CMwbgDVnOf+TBq5t1G37/qQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YW4g96wkHLDQRpKtepPS2keaoTpsq7fvENnWjutPsZPNqzLV0T4cq8Fes5hsnGu2W
         uW62ZJUfb9I188BWKafSCjejFhHWeL1GoyPXJbdaarHm8TkaVXZ85wU54EgkQ3AuWQ
         gYhnGNa0kvRAA5ktuzQFNoPBhKOCWAgMjnGuB1wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>,
        Mazin Rezk <mnrzk@protonmail.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 024/120] drm/amd/display: Clear dm_state for fast updates
Date:   Mon,  3 Aug 2020 14:18:02 +0200
Message-Id: <20200803121904.022636587@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mazin Rezk <mnrzk@protonmail.com>

commit fde9f39ac7f1ffd799a96ffa1e06b2051f0898f1 upstream.

This patch fixes a race condition that causes a use-after-free during
amdgpu_dm_atomic_commit_tail. This can occur when 2 non-blocking commits
are requested and the second one finishes before the first. Essentially,
this bug occurs when the following sequence of events happens:

1. Non-blocking commit #1 is requested w/ a new dm_state #1 and is
deferred to the workqueue.

2. Non-blocking commit #2 is requested w/ a new dm_state #2 and is
deferred to the workqueue.

3. Commit #2 starts before commit #1, dm_state #1 is used in the
commit_tail and commit #2 completes, freeing dm_state #1.

4. Commit #1 starts after commit #2 completes, uses the freed dm_state
1 and dereferences a freelist pointer while setting the context.

Since this bug has only been spotted with fast commits, this patch fixes
the bug by clearing the dm_state instead of using the old dc_state for
fast updates. In addition, since dm_state is only used for its dc_state
and amdgpu_dm_atomic_commit_tail will retain the dc_state if none is found,
removing the dm_state should not have any consequences in fast updates.

This use-after-free bug has existed for a while now, but only caused a
noticeable issue starting from 5.7-rc1 due to 3202fa62f ("slub: relocate
freelist pointer to middle of object") moving the freelist pointer from
dm_state->base (which was unused) to dm_state->context (which is
dereferenced).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207383
Fixes: bd200d190f45 ("drm/amd/display: Don't replace the dc_state for fast updates")
Reported-by: Duncan <1i5t5.duncan@cox.net>
Signed-off-by: Mazin Rezk <mnrzk@protonmail.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   36 ++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8489,20 +8489,38 @@ static int amdgpu_dm_atomic_check(struct
 		 * the same resource. If we have a new DC context as part of
 		 * the DM atomic state from validation we need to free it and
 		 * retain the existing one instead.
+		 *
+		 * Furthermore, since the DM atomic state only contains the DC
+		 * context and can safely be annulled, we can free the state
+		 * and clear the associated private object now to free
+		 * some memory and avoid a possible use-after-free later.
 		 */
-		struct dm_atomic_state *new_dm_state, *old_dm_state;
 
-		new_dm_state = dm_atomic_get_new_state(state);
-		old_dm_state = dm_atomic_get_old_state(state);
+		for (i = 0; i < state->num_private_objs; i++) {
+			struct drm_private_obj *obj = state->private_objs[i].ptr;
 
-		if (new_dm_state && old_dm_state) {
-			if (new_dm_state->context)
-				dc_release_state(new_dm_state->context);
+			if (obj->funcs == adev->dm.atomic_obj.funcs) {
+				int j = state->num_private_objs-1;
 
-			new_dm_state->context = old_dm_state->context;
+				dm_atomic_destroy_state(obj,
+						state->private_objs[i].state);
 
-			if (old_dm_state->context)
-				dc_retain_state(old_dm_state->context);
+				/* If i is not at the end of the array then the
+				 * last element needs to be moved to where i was
+				 * before the array can safely be truncated.
+				 */
+				if (i != j)
+					state->private_objs[i] =
+						state->private_objs[j];
+
+				state->private_objs[j].ptr = NULL;
+				state->private_objs[j].state = NULL;
+				state->private_objs[j].old_state = NULL;
+				state->private_objs[j].new_state = NULL;
+
+				state->num_private_objs = j;
+				break;
+			}
 		}
 	}
 


