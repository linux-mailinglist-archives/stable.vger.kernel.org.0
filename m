Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9CA46C98E
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 01:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhLHAvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 19:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbhLHAvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 19:51:02 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C80C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 16:47:31 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c4so1113934wrd.9
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 16:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen.nl; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6CGinnKVmUuoVA3pKZ20f8NcVvDMutyfWlopXEN/60=;
        b=Ix0NTO76N4qPYCiIqjTTs9VBzmNnSsCvFmyO5+o6P4ccazYpYPJbD4jFAQ7wI4ldhN
         3uaQ6KCDX8tzFpQoa7vM7ph3oIMJVoJ731x9FtUKHlXhNQr29rrAKqw2DH6N9VGVLMJh
         iyo01bWH6YPNIW1kL+AgE2YgUHhsorPr7lbBUkyRiPyUDnptoJmxUCeOQL1j1TNvct+I
         dRuDcwHoP/rGH+e6c7PX7/JjyskJ8/RnJK6JTzrJqcZmUBdNs0WYX14TUBfmLs+Njuh/
         5woKf/NwWNmG/FOFv05zNmSMdGWfoCBsYmOOpq2jE2PAeHvxch13cPlc4unqSPQVd9mj
         wa5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6CGinnKVmUuoVA3pKZ20f8NcVvDMutyfWlopXEN/60=;
        b=g71O6NcC9Ik/sRVbuMPxBmDqpN1+PerLZX3u6IZhDAuBz4vtG37vasTz3a8qpz5jXb
         BGBejZPDqs6+CJQZgu5KkMluo/34qzHT0fR0SPcvTICmtBvCdeDKqi6ux2mx1x3aEUc7
         sKVzS0UKD84OX1gj2pi5oc8bbOELyi+lazgRA39bBEt5zbpVEqupgONS26rb+w2bHN6w
         3vnJ5VA3keV5xTSuB8uV0IjxUPxHE2fhZzWpJSENenMkjuza7k3o1d/S/iHQ85bhcuTF
         QdvZj2zZNLNDJFZFqPLHzsWEk5InrlrG9SS8sQr9KZEP9dosr2ewecx0vpnksbehNQF9
         7L3g==
X-Gm-Message-State: AOAM530nXMdnHkf6ktYTRfcihk4SqaWbE4RaWROpwT1WhP7R98YKv0gf
        1RxwhDUKGxPV6UhNLsVGHnvHcAWQXWEB8g==
X-Google-Smtp-Source: ABdhPJzlcP4pjEsfRhI3q7z7FSS1YHt6FMAJtfBSsExeJFTKlSwyVEcKxpWdtBZM54rwWW/yq2BOdQ==
X-Received: by 2002:adf:ed52:: with SMTP id u18mr54922763wro.609.1638924449714;
        Tue, 07 Dec 2021 16:47:29 -0800 (PST)
Received: from bas-workstation.. ([2a02:aa12:a77f:2000:7285:c2ff:fe67:a82f])
        by smtp.gmail.com with ESMTPSA id n184sm4190617wme.2.2021.12.07.16.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 16:47:29 -0800 (PST)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     dri-devel@lists.freedesktop.org
Cc:     christian.koenig@amd.com, lionel.g.landwerlin@intel.com,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.
Date:   Wed,  8 Dec 2021 01:47:26 +0100
Message-Id: <20211208004726.4136-1-bas@basnieuwenhuizen.nl>
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
 drivers/gpu/drm/drm_syncobj.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index fdd2ec87cdd1..e772ca3e1e13 100644
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
@@ -861,6 +870,7 @@ static int drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
 				     &fence);
 	if (ret)
 		goto err;
+
 	chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
 	if (!chain) {
 		ret = -ENOMEM;
@@ -890,6 +900,7 @@ drm_syncobj_transfer_to_binary(struct drm_file *file_private,
 				     args->src_point, args->flags, &fence);
 	if (ret)
 		goto err;
+
 	drm_syncobj_replace_fence(binary_syncobj, fence);
 	dma_fence_put(fence);
 err:
-- 
2.34.1

