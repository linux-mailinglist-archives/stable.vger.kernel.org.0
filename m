Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1743E59A6E5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 22:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351728AbiHSUJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 16:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351700AbiHSUJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 16:09:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3FAC12FB
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 13:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660939778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4WKsTj80+KlAOcyLxVq2MH02vD1fdMO95DXY/VPgDU4=;
        b=bo+c7wwj9NWoNQf2mVjNEB8yu6Dhiymgq8cavu0w/xqveKZEjXbXDklObkdJlaZ0SEM1Zl
        FygO+k0IyjZvMo9fT4tYP15WDy++/7c1YfquprAqnTaeLMYVIM9e3JK8/mqgE8bKjb2YpH
        D2rQNKPt6H1ioitmoJzLEpvJRMq83Ok=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-u8wIbwlPOW2iOi2LdIJ7WQ-1; Fri, 19 Aug 2022 16:09:37 -0400
X-MC-Unique: u8wIbwlPOW2iOi2LdIJ7WQ-1
Received: by mail-wm1-f70.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso4745375wmq.4
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 13:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=4WKsTj80+KlAOcyLxVq2MH02vD1fdMO95DXY/VPgDU4=;
        b=SRuMR4QWA6bBXrtfufcH9JVO0pVvyx5Qr/4PEtw1BihT0y8kUGr16zkKiJh+Da6gEj
         Lb9ULhBYPbeK1EVw64iKu46t3nH1hvUadJGbXs1cy4G31buNVydS80L6rL84YfsDHCpR
         8JwnT6ACGIXF7qc2t/pWFYzfgfXpR5Lj2bzdd2htw1mqAet+IPv5Jqgp5Wi86KUOhiiL
         TQKxiT+sYw6PcmjuuFpPktUrlqVUVZq7jRTyRSQoI36oUagfeudFvNkP9PWuKACOefW7
         wehNNoK245p0WN39+wTxnbtNzT7ovCay8kdSNBZ+warJlbWj59YESapddpjnjqgoQjpg
         eNpw==
X-Gm-Message-State: ACgBeo3NAmyq1Kt4DXikiuwaAR+9pcPxyU7MKIlyLD6yRPYyWB2n4Th4
        xQngT5dpti9OUn8zHDZX1POhov5pGQ3H/ypLiJIdY2pno7kmk+2MAC2eWxC9Ae4v/iLOkH5tERu
        4pIA9rA6acuQ3ANXZ
X-Received: by 2002:a05:6000:18c:b0:21f:170d:446e with SMTP id p12-20020a056000018c00b0021f170d446emr5029335wrx.304.1660939775655;
        Fri, 19 Aug 2022 13:09:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR41MvAqMhAqH36jAsYe/x4lLfhc9bERm3BktAuEeK79ImvBnIv/1szPfEWDOHxRsmuy+tKIGA==
X-Received: by 2002:a05:6000:18c:b0:21f:170d:446e with SMTP id p12-20020a056000018c00b0021f170d446emr5029327wrx.304.1660939775474;
        Fri, 19 Aug 2022 13:09:35 -0700 (PDT)
Received: from kherbst.pingu.com ([31.16.187.72])
        by smtp.gmail.com with ESMTPSA id u18-20020adfdb92000000b0021eaf4138aesm5991920wri.108.2022.08.19.13.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 13:09:34 -0700 (PDT)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Karol Herbst <kherbst@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf
Date:   Fri, 19 Aug 2022 22:09:28 +0200
Message-Id: <20220819200928.401416-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is a bit unlcear to us why that's helping, but it does and unbreaks
suspend/resume on a lot of GPUs without any known drawbacks.

Cc: stable@vger.kernel.org # v5.15+
Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/156
Signed-off-by: Karol Herbst <kherbst@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 35bb0bb3fe61..126b3c6e12f9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -822,6 +822,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict,
 		if (ret == 0) {
 			ret = nouveau_fence_new(chan, false, &fence);
 			if (ret == 0) {
+				/* TODO: figure out a better solution here
+				 *
+				 * wait on the fence here explicitly as going through
+				 * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
+				 *
+				 * Without this the operation can timeout and we'll fallback to a
+				 * software copy, which might take several minutes to finish.
+				 */
+				nouveau_fence_wait(fence, false, false);
 				ret = ttm_bo_move_accel_cleanup(bo,
 								&fence->base,
 								evict, false,
-- 
2.37.1

