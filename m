Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84E56EEE29
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 08:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjDZGRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 02:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbjDZGR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 02:17:29 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292FB2684;
        Tue, 25 Apr 2023 23:17:29 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-524c7deb811so508144a12.1;
        Tue, 25 Apr 2023 23:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682489848; x=1685081848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=54QT2qvIeWHdzjZ4EieSD34moWDamE7VGmQ7alnRC98=;
        b=sF+P8bb8uMhYrTOmSX99gvg7Hru+61Rlk2NYSAmxAbzFaHJ9SIj7+SjR0pxefdjN5r
         hFt9x6840LiGIIMysJkU+WbnAdwbMxBdQRsv/pQrZFRnzdw7LUC+D7MPgj8wTiFc/CuG
         KkXY6/Ys64F/aPaHUC3zG+MRUxVRpg53YaqUDLsd15CspB+8+5RQaMlfn4SbQfjNu0kS
         dbIa5Kkbv2TcP2OsDQiaFCYdjxrqsfpR7tTz+JtD37h9tS3/rUfWxdRwIjanZySnRYYf
         uONLqV8nBibPXcOKjU5MrwR8k7x5nIpa3dAiDegXDvl8HbdhPmjxIEtceUBAHzPpomst
         xVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682489848; x=1685081848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54QT2qvIeWHdzjZ4EieSD34moWDamE7VGmQ7alnRC98=;
        b=g34gNDosekFQ8xDn5M0aPVynUl8zVcrvNpvdlWZU8I5P56zWJFhHNjNs0lb2vbgCK+
         XKydpOkpMJq/66gegmAapQMN1C9kUiuzt657JywO0sFKygQgD9T+sRmTEwDrcqebywV9
         CYZPThI81U0FfaTQkyQJRl90He4yApG7z6pEVshUAss7vN16DU/2MB1lOZNvipaFsvEy
         B9IlktWyr24lH9C6rHVycPHGFJ8/eFKcxoi+i337RPh5b6Ti65yPWIMDQRN5giTmpgmT
         wVSpv+1DRQyBrqGxT1tYnsmqyCm8OSsdIBPc1VFQJ7ZzS6sX2vXD8A7ol8CD2kSWLj3z
         tjTQ==
X-Gm-Message-State: AAQBX9fHww3yQuqEedx1h6MOfl5vSzLRGvsJrPHNPv5d3e2Rw3XtllHv
        IdnOUe4PJ9xuaGFgDEt7P78=
X-Google-Smtp-Source: AKy350aycLnLbKLXtxd6n+hL6qzyM3+dfBPm8y7nLsLJ95s7tYOugYfR14+YBfg9XJq9kFbAi7tIog==
X-Received: by 2002:a05:6a20:1608:b0:c0:2875:9e8c with SMTP id l8-20020a056a20160800b000c028759e8cmr25435942pzj.1.1682489848305;
        Tue, 25 Apr 2023 23:17:28 -0700 (PDT)
Received: from olv-ct-22.c.googlers.com.com (217.108.125.34.bc.googleusercontent.com. [34.125.108.217])
        by smtp.gmail.com with ESMTPSA id i23-20020aa796f7000000b0063f0068cf6csm7034692pfq.198.2023.04.25.23.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 23:17:27 -0700 (PDT)
From:   Chia-I Wu <olvaffe@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Date:   Tue, 25 Apr 2023 23:17:14 -0700
Message-ID: <20230426061718.755586-1-olvaffe@gmail.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mgr->ctx_handles should be protected by mgr->lock.

v2: improve commit message

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
index e9b45089a28a6..863b2a34b2d64 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
@@ -38,6 +38,7 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
 {
 	struct fd f = fdget(fd);
 	struct amdgpu_fpriv *fpriv;
+	struct amdgpu_ctx_mgr *mgr;
 	struct amdgpu_ctx *ctx;
 	uint32_t id;
 	int r;
@@ -51,8 +52,11 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
 		return r;
 	}
 
-	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
+	mgr = &fpriv->ctx_mgr;
+	mutex_lock(&mgr->lock);
+	idr_for_each_entry(&mgr->ctx_handles, ctx, id)
 		amdgpu_ctx_priority_override(ctx, priority);
+	mutex_unlock(&mgr->lock);
 
 	fdput(f);
 	return 0;
-- 
2.40.1.495.gc816e09b53d-goog

