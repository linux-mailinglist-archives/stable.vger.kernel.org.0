Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB294C1561
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfI2ODk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbfI2ODi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:03:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BE32082F;
        Sun, 29 Sep 2019 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765817;
        bh=rbXEIdkzDEquccJX/DA62GHbuC8xB3mFSYJCqj+weoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TemSYIfQFhaIwnRVWx7l8rdOAcr3zkGYcwPJrOsDwlsuYLas3ghH63Jma7spEc3/q
         1k+tfTXySpt4l6xdng7D+aAT8Wx/HIKFCPeQuILvXQzRJ57vS5KPA2DfOnsNFa6UJE
         XWCE+/P4/RbfO50/2xpcIEqtenhRjZbG2bIgu+us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Francis <david.francis@amd.com>
Subject: [PATCH 5.3 06/25] drm/amd/display: Dont replace the dc_state for fast updates
Date:   Sun, 29 Sep 2019 15:56:09 +0200
Message-Id: <20190929135010.611715359@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit bd200d190f45b62c006d1ad0a63eeffd87db7a47 upstream.

[Why]
DRM private objects have no hw_done/flip_done fencing mechanism on their
own and cannot be used to sequence commits accordingly.

When issuing commits that don't touch the same set of hardware resources
like page-flips on different CRTCs we can run into the issue below
because of this:

1. Client requests non-blocking Commit #1, has a new dc_state #1,
state is swapped, commit tail is deferred to work queue

2. Client requests non-blocking Commit #2, has a new dc_state #2,
state is swapped, commit tail is deferred to work queue

3. Commit #2 work starts, commit tail finishes,
atomic state is cleared, dc_state #1 is freed

4. Commit #1 work starts,
commit tail encounters null pointer deref on dc_state #1

In order to change the DC state as in the private object we need to
ensure that we wait for all outstanding commits to finish and that
any other pending commits must wait for the current one to finish as
well.

We do this for MEDIUM and FULL updates. But not for FAST updates, nor
would we want to since it would cause stuttering from the delays.

FAST updates that go through dm_determine_update_type_for_commit always
create a new dc_state and lock the DRM private object if there are
any changed planes.

We need the old state to validate, but we don't actually need the new
state here.

[How]
If the commit isn't a full update then the use after free can be
resolved by simply discarding the new state entirely and retaining
the existing one instead.

With this change the sequence above can be reexamined. Commit #2 will
still free Commit #1's reference, but before this happens we actually
added an additional reference as part of Commit #2.

If an update comes in during this that needs to change the dc_state
it will need to wait on Commit #1 and Commit #2 to finish. Then it'll
swap the state, finish the work in commit tail and drop the last
reference on Commit #2's dc_state.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204181
Fixes: 004b3938e637 ("drm/amd/display: Check scaling info when determing update type")

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: David Francis <david.francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7346,6 +7346,29 @@ static int amdgpu_dm_atomic_check(struct
 			ret = -EINVAL;
 			goto fail;
 		}
+	} else {
+		/*
+		 * The commit is a fast update. Fast updates shouldn't change
+		 * the DC context, affect global validation, and can have their
+		 * commit work done in parallel with other commits not touching
+		 * the same resource. If we have a new DC context as part of
+		 * the DM atomic state from validation we need to free it and
+		 * retain the existing one instead.
+		 */
+		struct dm_atomic_state *new_dm_state, *old_dm_state;
+
+		new_dm_state = dm_atomic_get_new_state(state);
+		old_dm_state = dm_atomic_get_old_state(state);
+
+		if (new_dm_state && old_dm_state) {
+			if (new_dm_state->context)
+				dc_release_state(new_dm_state->context);
+
+			new_dm_state->context = old_dm_state->context;
+
+			if (old_dm_state->context)
+				dc_retain_state(old_dm_state->context);
+		}
 	}
 
 	/* Must be success */


