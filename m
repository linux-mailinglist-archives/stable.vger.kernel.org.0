Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AA53DDF8F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhHBSse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:48:33 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D4EC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 11:48:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so20688392plr.11
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 11:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gVuPVb9PUy9T8xqfWMZnMlNSFh/ILfUtx1Y/wV7SiUI=;
        b=P6mfgP8HT+fX067rmCwrI1MxKNpYiaUa3ozc/YCtF6JfcbbFixeUYIqp7mlzTFvxax
         R2Iw6yRqBWRLjBIcI6Ae98gJurofpT1M2G46l9tffCkEOCOSgdpuzi9zZFzih5S8qDpK
         L5daEd875rL1N2wejtZ0yNlhl9i/8D2SJHZ48N58pGtzaiu/Si4G2KyycTVd/nCCo+8W
         Xj8O2SbqHdBi0MFBVd2mDn9tnCVXd/XPkQkywnxUNwKYYvYjs/ESpfk4dPok4iDQG6Df
         gukpKPtWHs21kV1lS6iIJXWR92TmXQMCrhIKpzoVgteGDjkqfB1mmRuGhJhMBcAepMYw
         IW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gVuPVb9PUy9T8xqfWMZnMlNSFh/ILfUtx1Y/wV7SiUI=;
        b=oTmWfkLtFZUGTSec8tQKXtn00NssHWtNiec3xGiXFr5VB681Jd/Z5SI6LGA+j1YkuY
         g63ZGCG8x7NqDv+vmNrXHI3f3a/98XMzkbgIOCsU2ZSUxeVi5b5kqODNWTdAYek2g1Y5
         pw6QlPlh/L07L68JwL8ZVTElCo527nXlEMvLuKiC7C+uAW1hFikt340e8XssIdVgdz+q
         J1Uy0L9ShTyJ//QFo58rLgjEoCzVOE92vOzPqVPkKWPnSKHLFMmub5ZCEoOFD2yXEK1B
         r/W2Mk5Ma6aeq2+WaDG7H0i6E5kwaLHIF6/1drEaoR4FWNMgEOoGw+UTy7gXFUY3i4nY
         kXuw==
X-Gm-Message-State: AOAM532jHYJmNkNJLfw4uUtPUWfH1VtwhgDNBhRaHSMurN/OleaLYuSN
        bAx7neOMuJNpyl0fBMzGE4OOi1Nuw93kRrB7
X-Google-Smtp-Source: ABdhPJwgqz3+STAwefN7MJVeY6mQ1J4zNYz9z1p/JbAZ5ScCvx7HNQLajBePqhLyoGTboONwl/Pmzg==
X-Received: by 2002:a63:5d4d:: with SMTP id o13mr2688542pgm.173.1627930102350;
        Mon, 02 Aug 2021 11:48:22 -0700 (PDT)
Received: from omlet.lan ([134.134.137.81])
        by smtp.gmail.com with ESMTPSA id n4sm7987819pfj.62.2021.08.02.11.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:48:22 -0700 (PDT)
From:   Jason Ekstrand <jason@jlekstrand.net>
To:     stable@vger.kernel.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>
Subject: [PATCH 0/2] BACKPORT: drm/i915: Get rid of fence error propagation
Date:   Mon,  2 Aug 2021 13:48:17 -0500
Message-Id: <20210802184819.414914-1-jason@jlekstrand.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a back-port of the following patches from torvalds/master to 5.13:

 - 686c7c35abc2 ("drm/i915/gem: Asynchronous cmdparser")
 - 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")

Jason Ekstrand (2):
  drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
  Revert "drm/i915: Propagate errors on awaiting already signaled
    fences"

 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 227 +-----------------
 .../i915/gem/selftests/i915_gem_execbuffer.c  |   4 +
 drivers/gpu/drm/i915/i915_cmd_parser.c        | 118 +++++----
 drivers/gpu/drm/i915/i915_drv.h               |   7 +-
 drivers/gpu/drm/i915/i915_request.c           |   8 +-
 5 files changed, 93 insertions(+), 271 deletions(-)

-- 
2.31.1

