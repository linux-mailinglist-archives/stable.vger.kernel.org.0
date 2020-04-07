Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A96F1A0739
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgDGG0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 02:26:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37262 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgDGG0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 02:26:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id u65so333600pfb.4
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 23:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jy977meOP1x2g1uwfOo8VvxcnJENx8VXf+a5CPnPB0Y=;
        b=MZIdjAh2Ez1wofKZ+wn7aL/BWxBmauimXI6PRuJC1wV41Pype8abxbRAKRBfYlA9SF
         YHFrCNT7SO8xuqpwrEZEjxmgp8MQrkvLe7ple9w6bij6CUE4z4yv2G0u04mbdx9VPncb
         VLyeLjUjxBhtMkxxmm2JUwKCqTzVo9WT/oc5GLTzDXAW9fosw0giH/52NDqWXuhsmmFi
         E/Jp6/VymRPhe8BpSmy2r/yXB1vBnyMIKqfCDXzhqU2Yxh+/iPHgelcU2SB7ff4N8ivx
         DQ1ve9DdBdIPhAFqRYvqJozJMszZOzq6TbNICy9V7a75FHQ1Knt6C+qeY7diaUF9AfuY
         gbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=jy977meOP1x2g1uwfOo8VvxcnJENx8VXf+a5CPnPB0Y=;
        b=nZL4OQGKmQHzAwH3WOD6JXW+kGCQPF9QZIpobf078/3ZVCLAutxwpbKG5GXtgEVH5p
         j7hotFst0xIc8wz+DBW+Gn1POstq54DjEN4Wr7I2G19icOLI70kIFkvIo30crPm13NkY
         ZU7NhHjpZdtd+dfBnn/dMa9zAuRUR8VNOc9otCM+RPqEYGjCxmdA4eCYgDDNV1FquXbj
         ZAgXxde83/I1RcwnkdZasVBqsnXWAQz7RMudXgIWbXY3sXGpXw7f5IJLc31FqbVF+iFu
         041+lCa9wP+cDvXEeXtTRS/l5qvd8nodijMIo6AB0JgHZlDmngiGoyGqZIQMUYdBJldX
         PFiA==
X-Gm-Message-State: AGi0PuZByWF8jkDIZy4keR3/RMlJQAJelgxLe+bAN4orMlAoKOO9glkV
        HmFlgc1nl0bd2dDEWxOaRBsg7vHd
X-Google-Smtp-Source: APiQypIilbINLPrUGoKy7ywgHGom36AC24wZuq/hJ3V4bFgUTJoRJ1cFGpR+3vP9+2DVN6t9y8vLYg==
X-Received: by 2002:a63:a51e:: with SMTP id n30mr552785pgf.414.1586240813483;
        Mon, 06 Apr 2020 23:26:53 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id y9sm13554620pfo.135.2020.04.06.23.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 23:26:52 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     stable@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH 0/1] drm/i915: Fix a deadlock that only affects 5.4
Date:   Mon,  6 Apr 2020 23:26:21 -0700
Message-Id: <20200407062622.6443-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

Hi,

There's a mutex lock deadlock in i915 that only affects 5.4, but was fixed in
5.5. Normally, I would send a backport of the fix from 5.5, but the patch set
that fixes the deadlock involves massive changes that are neither feasible nor
desirable for backporting [1][2][3]. Therefore, I've made a small patch that
only addresses the deadlock specifically for 5.4.

Thanks,
Sultan

[1] 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
[2] 093b92287363 ("drm/i915: Split i915_active.mutex into an irq-safe spinlock for the rbtree")
[3] 750bde2fd4ff ("drm/i915: Serialise with remote retirement")

Sultan Alsawaf (1):
  drm/i915: Fix ref->mutex deadlock in i915_active_wait()

 drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
 drivers/gpu/drm/i915/i915_active.h |  4 ++--
 2 files changed, 25 insertions(+), 6 deletions(-)

-- 
2.26.0

