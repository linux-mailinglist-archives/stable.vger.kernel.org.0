Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B370EB9159
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbfITOEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:04:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44362 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfITOEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:04:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id q15so3216548pll.11
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lTw5XUGJVR48uPMVk5aXIBlvJhVRgMUDCJD05MX4Aw4=;
        b=poviuBVe8r0VI/3t1rC05aha1Km8QPTpMxsQh+lSRV7dkF/J935t3tM/J++EPQJIN7
         MzosHaE5Jc/7vRQLzG6zh8fahxc468lGs255iX/2+6Wkq2e3QAf5Cb8Khe4BaDLBeuJl
         xJbTwdbW6dfm2mrWKfGYWHOnWCn40ytONZURhzeQi6OOR+dqfiN/K9TnAxfxABqySJSa
         HMURd1COcz7S7/MpVXasaPRduAL0QShSpcSlduJac5JPSxStZuWzqkSZoifccKy2DAYv
         2gzn+azO9/jTyrMOvhGBmkWCp1DgghK8zNKC0yY/Tj31lvaMF65neNAaQHVt3lg3UvFX
         zQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lTw5XUGJVR48uPMVk5aXIBlvJhVRgMUDCJD05MX4Aw4=;
        b=nr1ESdM5Xe5PR0PJCr1gqSBdnn9HJlWpI1ruQ4xXqDen9LYbfOqliauKoFsdyvvGO1
         wsVK+BHp7oDC4t2gSkAu777T5wkP5KPGl0yrc4b6FI+pZiUBt7ZDWBuPF04C4JA8sXDT
         cxBDYG97V46POJYa1b6mB/8wp8XfQdfL7Cyjfa1v/QPDIVE48VMVCsEYrDm29IUwu4xg
         pDaFWEJfgwxrMXcI5A1BSBO1J7kQmWjWZNSePZGZX2tcvKZhiEiADsh2XhGLwdnTKLhh
         1hm5g8LAbsraqF6ay4PJsMa0o9acBDQotZVUFM9rl9TEV0ak2rzekIud4m5oc9TxKGZ9
         OcLw==
X-Gm-Message-State: APjAAAUD2kSvJyl1COmP5dPvlRexVx2PBav4JHUpddPM28BltBuBmbLO
        +N9soq6itKSxpZ4eFyvWh729tbgU
X-Google-Smtp-Source: APXvYqzAxxMvfkNZ2pV7rWnSdR2rhtdpdcrnIxGJGsvIJZXkc0iVgBOYVKPGTIT0W2d1nt3ENSk8nw==
X-Received: by 2002:a17:902:8f88:: with SMTP id z8mr3058285plo.232.1568988241221;
        Fri, 20 Sep 2019 07:04:01 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id 8sm2232180pgd.87.2019.09.20.07.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 07:04:00 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     nicholas.kazlauskas@amd.com,
        Alex Deucher <alexander.deucher@amd.com>,
        David Francis <david.francis@amd.com>
Subject: [PATCH 3/3] drm/amd/display: Don't replace the dc_state for fast updates
Date:   Fri, 20 Sep 2019 09:03:38 -0500
Message-Id: <20190920140338.3172-4-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920140338.3172-1-alexander.deucher@amd.com>
References: <20190920140338.3172-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

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

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=204181
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: David Francis <david.francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd200d190f45b62c006d1ad0a63eeffd87db7a47)
Cc: stable@vger.kernel.org
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8df49740518e..beb2d268d1ef 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7346,6 +7346,29 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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
-- 
2.20.1

