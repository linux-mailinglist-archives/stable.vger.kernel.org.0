Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED511CDA28
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 14:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgEKMiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 08:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729343AbgEKMiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 08:38:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2208DC061A0C;
        Mon, 11 May 2020 05:38:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j5so10772072wrq.2;
        Mon, 11 May 2020 05:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/7g+Dk3ulGJzA1ZqqgcvZurwlfTuEzqTNp6ZYliVW4=;
        b=rtJPvnSDjKuOSMfGnG/B2uMl5ngrAGDoVHkoFM4MO24RwTb42n3UNtiOk15NtGYfw6
         8uw/mobincTc+Y1Dkrvw/+WuIIuPaIq4L3JrxEXscFXkOmgnK3a0EGRruaG/y7P5pTGN
         UJTYd5NQPGskTdo/EGmEmU8Bd8ohjtqoxp5vsyER/31I7feNHy0o6/WafUuZ8Zfr4w5o
         2FjhCHhqKubUuAaxtQTRSLsgQdFULhaTkFhV3SU1nncjaR2nRuZmYNLQOlQHxW3Z1rT6
         0M4+3kC4kP54w1YR9rdllPZaWEy/BqE3uPY18dCH5TKgpeFk9hJpb/UyeX9ZNIk+TWsx
         jpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/7g+Dk3ulGJzA1ZqqgcvZurwlfTuEzqTNp6ZYliVW4=;
        b=Fh9xnkTiFBeCjUErL4O+cB0RS1AyKUdTENAjua+XEB7JXY1BJqroEte9euCdjbV6M8
         7wSfCZHoSCGUgu7SXb8Kgejlq4Y4jU5roOE7ZW2bCMKd4sOPLU0LBRSkhO4JaUFLJfkn
         rsGEOksXE/nHJIq/9zW5MIdGifYtJm2faP8qYKsRGS+3aUIs60fo1P7T0MBiS9pKw9iV
         KW+0MIQ/I7WSEwu5P5HdxTIdGr0bJ8AO7fFNeM/6LZqNheeGXshyccZ3nDrWr+Jd2L8p
         QJ5aarrWt8/lwzNUl5757ezrgMr0B6tFu6MhEv58sC5gyFoziaRszeg8P/10yWZ0pQiA
         b3SQ==
X-Gm-Message-State: AGi0Pub2CwP5iZHcfA8INMGCAYsPdFAdayQQwSLQWtVR9XraZI5G+qBa
        j7r9UVS4SMMDYevs9h7iAjZsAnaJsTwkBQ==
X-Google-Smtp-Source: APiQypIEWKDu44A+npU7MmH4oc2np5qOouKCs0oVitxMIUb0GK3Z+Ab/RzdBhjYvMZAXgblwnKWCFQ==
X-Received: by 2002:a5d:4801:: with SMTP id l1mr18074398wrq.235.1589200729281;
        Mon, 11 May 2020 05:38:49 -0700 (PDT)
Received: from localhost.localdomain.at (62-178-82-229.cable.dynamic.surfer.at. [62.178.82.229])
        by smtp.gmail.com with ESMTPSA id y3sm16965388wrt.87.2020.05.11.05.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 05:38:48 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/etnaviv: fix perfmon domain interation
Date:   Mon, 11 May 2020 14:38:41 +0200
Message-Id: <20200511123846.96594-1-christian.gmeiner@gmail.com>
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
index e6795bafcbb9..35f7171e779a 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
@@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
 		if (!(gpu->identity.features & meta->feature))
 			continue;
 
-		if (meta->nr_domains < (index - offset)) {
+		if ((meta->nr_domains - 1) < (index - offset)) {
 			offset += meta->nr_domains;
 			continue;
 		}
-- 
2.26.2

