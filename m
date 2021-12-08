Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A5E46CAF8
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 03:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhLHCnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 21:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhLHCnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 21:43:12 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC3DC061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 18:39:40 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d24so1566124wra.0
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 18:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen.nl; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y2cG9RurA34K51qCt0uYNk1CDMkoujSFBImeM3uamz8=;
        b=UzOyzJv1zQBIjcFOw1Es8PZO4aLajWtYPSZ7cKoNVKnboa8mRra2EM6EQmzRUqQQTs
         vvLYdurxIQhdboidCqOZ23paP1jqwL367Be8uaYQFilhPo5am4PgqGJSJ7cDPh123QQ9
         oS49H5jjklopum9WtOyhg18iD8Bnfl9Uajk9A8ja0prPn4mjgVTPC97TY4KjntU2EF4X
         kXzjYltzH8dY+N1NqMxTEtieF5PbimF2FOYOBB+9U4PVNzO6x/DivrtSTK6AD5GFm1xx
         IaKrGHH8NiS/OYnZN7h2UpY2Qk9c06DRXhVLIxIp4hrHnpIHBN6ZeDhFrsO/6dGQJr8u
         vLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y2cG9RurA34K51qCt0uYNk1CDMkoujSFBImeM3uamz8=;
        b=zRb6zL7tsrwFdUbdo/Xw3KHb1ucusBS7XZm4clDW7dCfxGH9BRrbW43GyQWj759CCJ
         /+WoXcuQvFB0kH991XoVBcRJGStn0YKDlTb5awE0yOUZwLlHTgyEUd+NfOxtVmdmHyYE
         28Bg6xwid18q3YtgrpF8SFMOADFFW9k1JhOPVxTEAEqwKZMCmu1xBUGEHQF0zQvN8SLZ
         gaDg0a848PDm+hY1OqjWyOoRpaX2NYd4jI860/xFRjC+40gRDaB4+SfSU8Ir3C4VK0yY
         SH4QsQ/uxvqVur2kJpaWhhKsJcOkUHn6cgmhEHbW3pARRXNAI1M2n6FlyleOI9V+xhTr
         BA5g==
X-Gm-Message-State: AOAM532ajwuRHBVIz4sJckJS8VsHh0D9j5mWJSW/ah2A+lDcLvHQPUQm
        zXkntYhO8VdMreeY9mB+utMjlA==
X-Google-Smtp-Source: ABdhPJwjkZM/xSwajxgDmE8oCD81SLQpLOp7+iHdbxo8zb0q3rvqJsJskb1Ko0jsrCdVjIO3vz/+pw==
X-Received: by 2002:a05:6000:1788:: with SMTP id e8mr58984781wrg.45.1638931179330;
        Tue, 07 Dec 2021 18:39:39 -0800 (PST)
Received: from bas-workstation.. ([2a02:aa12:a77f:2000:7285:c2ff:fe67:a82f])
        by smtp.gmail.com with ESMTPSA id 21sm1230098wmj.18.2021.12.07.18.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 18:39:38 -0800 (PST)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     dri-devel@lists.freedesktop.org
Cc:     christian.koenig@amd.com, lionel.g.landwerlin@intel.com,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.
Date:   Wed,  8 Dec 2021 03:39:35 +0100
Message-Id: <20211208023935.17018-1-bas@basnieuwenhuizen.nl>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

dma_fence_chain_find_seqno only ever returns the top fence in the
chain or an unsignalled fence. Hence if we request a seqno that
is already signalled it returns a NULL fence. Some callers are
not prepared to handle this, like the syncobj transfer functions
for example.

This behavior is "new" with timeline syncobj and it looks like
not all callers were updated. To fix this behavior make sure
that a successful drm_sync_find_fence always returns a non-NULL
fence.

v2: Move the fix to drm_syncobj_find_fence from the transfer
    functions.

Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between binary and timeline v2")
Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
---
 drivers/gpu/drm/drm_syncobj.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index fdd2ec87cdd1..11be91b5709b 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -404,8 +404,17 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
 
 	if (*fence) {
 		ret = dma_fence_chain_find_seqno(fence, point);
-		if (!ret)
+		if (!ret) {
+			/* If the requested seqno is already signaled
+			 * drm_syncobj_find_fence may return a NULL
+			 * fence. To make sure the recipient gets
+			 * signalled, use a new fence instead.
+			 */
+			if (!*fence)
+				*fence = dma_fence_get_stub();
+
 			goto out;
+		}
 		dma_fence_put(*fence);
 	} else {
 		ret = -EINVAL;
-- 
2.34.1

