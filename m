Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8BFB9158
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfITOEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:04:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42173 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfITOEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:04:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id e5so3228900pls.9
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Om1JqaE5KxgQvQwZzqNbgCMsa6iHsu4Wwmv1NUU4z3k=;
        b=JMA0k9vy3SykO/9xluzAh946vrLbwimrgakldlb5SW4povusBp4vRncxdzhtAWOP9h
         CZ8IySj7kq5gI9tKZobIAzUoO76esEkiQQ2nttKnq7uXxoHMjcdnn5amZnLk3AwznzVB
         j9eR2hX3ApbqRziAfBFfKVSl28s3GyKQxXWqPJ7B26RlcXU6q+nMSFg3KTUHCiAGwqg6
         +sXGRAJI4aP+tYVtyCIWgziAq8ZkB1iJfXuzATFcNvILsi8vrw1nD2Mh780nlZoV+n5i
         NnMqQgMRuE5E7J6+1eaEUnEfKR6E7tr4FkIpa7YiModXs1On7w7U0L9qGYnljTicTXo8
         2z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Om1JqaE5KxgQvQwZzqNbgCMsa6iHsu4Wwmv1NUU4z3k=;
        b=HYGAvo5Ha9iF67vPxLvppl5M/52Igu03ojuDVhtw8xOfhI2hzXevUChdqfEJ64VmXv
         XAhDqEH5NaZrNR9v0ltcA8n16tOcQ0B0YMQomJCi2DvPd6ha6WIgSAcK5DkslD3aycdP
         0CDd17bOF/RdiF10RdpL7woCjc3gb2xngUZW0/VeEQz/5mu9bpvbwnR/cGsTV7DpTeF8
         yYRhocspag3IXp3bytcAjFWAHMS5r4xJxkANOsiJm9DqooDlZPUeebnT0XdKOTjRcYmY
         Z4Qaejg3KnGYJHTIjFZPWVJAQXI37M+/lNyNyyGcRwOLSB+RH4PtByJgzhpGoDEhEWVq
         he9Q==
X-Gm-Message-State: APjAAAWob0+hDklZ+EMwCAxgRLIchmDmOs/uVQEq0tdMuU2cOcoTuEj6
        GGcNpKqAF5jUABtpPJTPmrLqiElC
X-Google-Smtp-Source: APXvYqwI1LYDgdKoAiR9Ns6HqncBaemLJl5jEXfbACUTpLyz6WHi2qM9jysGpASo+Kk+9JQEVqrYag==
X-Received: by 2002:a17:902:7d92:: with SMTP id a18mr16896394plm.243.1568988239048;
        Fri, 20 Sep 2019 07:03:59 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id 8sm2232180pgd.87.2019.09.20.07.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 07:03:58 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     nicholas.kazlauskas@amd.com,
        Alex Deucher <alexander.deucher@amd.com>,
        David Francis <david.francis@amd.com>
Subject: [PATCH 2/3] drm/amd/display: Skip determining update type for async updates
Date:   Fri, 20 Sep 2019 09:03:37 -0500
Message-Id: <20190920140338.3172-3-alexander.deucher@amd.com>
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

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=204181
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: David Francis <david.francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 43d10d30df156f7834fa91aecb69614fefc8bb0a)
Cc: stable@vger.kernel.org
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ab341fca9647..8df49740518e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7274,6 +7274,26 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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
@@ -7326,13 +7346,6 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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
-- 
2.20.1

