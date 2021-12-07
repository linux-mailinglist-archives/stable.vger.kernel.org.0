Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA86546AFCF
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 02:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhLGBgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 20:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbhLGBgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 20:36:10 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDAC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 17:32:40 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a18so26144876wrn.6
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 17:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen.nl; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ov6NmFfn2KOdbrAOSyyJhZZ3QFfk7XcAFTsXrWKZIFk=;
        b=hNXGWtgrTIt0EBrLBJry9rtHevgDCGyN5WKpj8eLt42+KR2R71Ttf8BfNdS1Ta4YXK
         3xFHWL24f+Pd6nkip0Dmxf2t4AzP9I8YeBHdhMQJn44OdPLy5rip9VVMQ7c/KK/JAJQz
         IEew6xJTnv9FN8f+iVRTwqMC8RoRnZWiS02UweW+aJjI5sXlEiKhOaZR16qZZPU+5LXZ
         16lztObWuPKNOYfep5z2dM5mE4KJggZXoXJVOClkbIbCiWTiSKpMQ4GSBI8BLoTIMHO0
         DTJvy7T+xS34hHqcEjSjlEV1fMe4/fB85z/pGU765iO9dqym+P1bOpzsUqZu+H/WN2Ng
         XLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ov6NmFfn2KOdbrAOSyyJhZZ3QFfk7XcAFTsXrWKZIFk=;
        b=0UzP0tpnHCe3BZhy10kpJOBoLQWVgEFFEF4zzg6kpgpmTCNNoLgHu+w8TmQm8stshj
         F6zk0csdeU/dpYDR/4FSowIYqsL4ThcIdLR6bVqlSPklf7roJ4/2vDE8Qem554/DYggV
         pq7knUzhh0t48/1PhePXrqelq1Gcv9Hawf6pvxYMthj5y5aWGEpgTY2NfBdjhSVbM5pJ
         VxdPH73UVDrCtBHtqzjMho8zg/O09hdNCOWUIhs46MhsJypWv2ijQ3oWGTobxuAE52UL
         ktbcD85BrHyOmYUNlACoFJrtKd6t6EQGqcNjJ+HGlEXC4MWwniyiIzMTQ1+wQWPM+csq
         SGUQ==
X-Gm-Message-State: AOAM530/GKtnCxtjNS/8P80kTxJ9p8Z28N/CRxzn+Q5HGduOHlI2RACP
        x+K+sO/Ahm/5GuJTXXyuKppyknBeUlStpg==
X-Google-Smtp-Source: ABdhPJz1v2UhAoPvMz7BxrFH9hPP7mcUYPVRgsZ3GGZ39+iG4CaJSv/xlTKE429w9hs98RBfBpYGYA==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr46741229wrn.472.1638840758785;
        Mon, 06 Dec 2021 17:32:38 -0800 (PST)
Received: from bas-workstation.. ([2a02:aa12:a77f:2000:7285:c2ff:fe67:a82f])
        by smtp.gmail.com with ESMTPSA id g198sm1010018wme.23.2021.12.06.17.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:32:38 -0800 (PST)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     dri-devel@lists.freedesktop.org
Cc:     david1.zhou@amd.com, christian.koenig@amd.com,
        lionel.g.landwerlin@intel.com,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        stable@vger.kernel.org
Subject: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
Date:   Tue,  7 Dec 2021 02:32:35 +0100
Message-Id: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

See the comments in the code. Basically if the seqno is already
signalled then we get a NULL fence. If we then put the NULL fence
in a binary syncobj it counts as unsignalled, making that syncobj
pretty much useless for all expected uses.

Not 100% sure about the transfer to a timeline syncobj but I
believe it is needed there too, as AFAICT the add_point function
assumes the fence isn't NULL.

Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between binary and timeline v2")
Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
---
 drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index fdd2ec87cdd1..eb28a40400d2 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -861,6 +861,19 @@ static int drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
 				     &fence);
 	if (ret)
 		goto err;
+
+	/* If the requested seqno is already signaled drm_syncobj_find_fence may
+	 * return a NULL fence. To make sure the recipient gets signalled, use
+	 * a new fence instead.
+	 */
+	if (!fence) {
+		fence = dma_fence_allocate_private_stub();
+		if (!fence) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
 	chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
 	if (!chain) {
 		ret = -ENOMEM;
@@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file *file_private,
 				     args->src_point, args->flags, &fence);
 	if (ret)
 		goto err;
+
+	/* If the requested seqno is already signaled drm_syncobj_find_fence may
+	 * return a NULL fence. To make sure the recipient gets signalled, use
+	 * a new fence instead.
+	 */
+	if (!fence) {
+		fence = dma_fence_allocate_private_stub();
+		if (!fence) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
 	drm_syncobj_replace_fence(binary_syncobj, fence);
 	dma_fence_put(fence);
 err:
-- 
2.34.1

