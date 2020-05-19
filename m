Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB71E1D8F36
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 07:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgESFaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 01:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgESFaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 01:30:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAEDC061A0C;
        Mon, 18 May 2020 22:30:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z4so1671506wmi.2;
        Mon, 18 May 2020 22:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWDo42nhd4sqFdF5voa++LZ2U/jNdAL9z6XA6dzl6uE=;
        b=lyoVSu9rXYV0z0/+Rous+Dp3s7nEhkenGZzIKs1ZkqzeVNnzUhZcV3wJk5agDUJWbq
         rcMHz/OC6/O9K9mRBTR4etcp+DUNsQGvLrwM7631Ph+y5HupMNjZ6YJP9pwXyFcPTQ3n
         rpeHKC6bentSXGu9z8YeO6/i5banBuwyfNSzFDnamYwrBYT6tr6ewd2oejfZ198De8Uo
         oMbwLHNjlSyaSrXA4ZVCfOuElXeeqPDEsTNsgsri89E5veLZHoregF69qi3u2F//PP2O
         NFh616lyMXgCUGQIZIIVM4dqr9jCQaHnX6JII1Cn+qy9RPqL/ESxxK0FrwBOxEyQbDQP
         mlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWDo42nhd4sqFdF5voa++LZ2U/jNdAL9z6XA6dzl6uE=;
        b=btEkPZxR97+P7TheQSGsWfh1TFCUH0kMgLURUFctj/gQNu8g55heESaxDITiUMtta4
         IAObIk/FFVTa0mS5cxIw6lPpZQNbWHmG33kzeXYGnzC+KBm3Z0Ie4DGg40OdPHbynqAj
         HdQQP87BLHEF0KjkgUwRgTWLeP9Lu8oyn/4YwJLG4WKkSmUIZAM8UYzdDtOx8jeLHudz
         iyRxalMWwlCrQ5zArHJSp1K059ca8+ndzCtogMHNv2nVOB1YQUHaIOYWK7P1iE6eVHSe
         1SnL3f7eDqGt4bripaNLj6i3qzJZtp4hzdsrurG1kvPEn60LRvXFfOB/rgb6NpronYFi
         IVVQ==
X-Gm-Message-State: AOAM531GzT8Kub8xnNlkHZk3LEso4D44wewhrZcQykO/uXv2gTJy36BP
        Gry1HSKoswmhRCG6rBa1atfWSzPl7Vk3Kw==
X-Google-Smtp-Source: ABdhPJyq7IUvmim5jAxuLmb0uu1FuRmT4ZBQmSjs1Ixu/wTOC9lspqVblmVqEC+1r4ogbwM7wq2uPA==
X-Received: by 2002:a1c:2e4d:: with SMTP id u74mr3310071wmu.145.1589866222870;
        Mon, 18 May 2020 22:30:22 -0700 (PDT)
Received: from localhost.localdomain (62-178-82-229.cable.dynamic.surfer.at. [62.178.82.229])
        by smtp.gmail.com with ESMTPSA id f123sm2312114wmf.44.2020.05.18.22.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 22:30:22 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2] drm/etnaviv: fix perfmon domain interation
Date:   Tue, 19 May 2020 07:30:15 +0200
Message-Id: <20200519053019.48376-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GC860 has one GPU device which has a 2d and 3d core. In this case
we want to expose perfmon information for both cores.

The driver has one array which contains all possible perfmon domains
with some meta data - doms_meta. Here we can see that for the GC860
two elements of that array are relevant:

  doms_3d: is at index 0 in the doms_meta array with 8 perfmon domains
  doms_2d: is at index 1 in the doms_meta array with 1 perfmon domain

The userspace driver wants to get a list of all perfmon domains and
their perfmon signals. This is done by iterating over all domains and
their signals. If the userspace driver wants to access the domain with
id 8 the kernel driver fails and returns invalid data from doms_3d with
and invalid offset.

This results in:
  Unable to handle kernel paging request at virtual address 00000000

On such a device it is not possible to use the userspace driver at all.

The fix for this off-by-one error is quite simple.

Reported-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Paul Cercueil <paul@crapouillou.net>
Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

---
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
index e6795bafcbb9..75f9db8f7bec 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
@@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
 		if (!(gpu->identity.features & meta->feature))
 			continue;
 
-		if (meta->nr_domains < (index - offset)) {
+		if (index - offset >= meta->nr_domains) {
 			offset += meta->nr_domains;
 			continue;
 		}
-- 
2.26.2

