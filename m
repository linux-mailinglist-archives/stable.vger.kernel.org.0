Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2031972CC
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 05:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgC3DbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 23:31:09 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52170 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgC3DbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 23:31:08 -0400
Received: by mail-pj1-f65.google.com with SMTP id w9so6974297pjh.1
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 20:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=otJu+eX4lgoyY7c5aWHtihsc0UqeTjjXfeFh1YkhPAI=;
        b=Cg/JgVh6ZFguiHH+MX9rN4p9sfqLyGbfezUgcNzj3PHFsHNEPTJ4eDqohWJ4ix+cfq
         86+xeolceCPoieZ4AwmrsKl0k1viscu053//IHabzLzbRgGRuwz91UWfge1NA1kJpPAt
         OiZauC4SIqmZg5wDrWWvMU7VzLEFI5QSSin7xgcZzrr7Mzldg1WsAULMQgHJrduk1ghb
         EbatZdXWg6ONHp3dbk5q8xho6821nsd06f1nVuq551l4cNjiHs8zJsBEE13n0Sqk/yGW
         9KqSIFtcbBBlsAuKvBrpmEgSusp0QN9PJPC8yZY6Cbjb7LaTPE12iGjL5Razi2DAmK+B
         Dblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=otJu+eX4lgoyY7c5aWHtihsc0UqeTjjXfeFh1YkhPAI=;
        b=PBG20AFVNrm9jaFRWvoG3RMDmTuKmZA+s8oR+TI82GZ7PT+OiZ2OZ3GOAIsg5DOr8A
         CY7isWCSmiwwNX4pHCfhBo9UxZmwYfJDEvrfGdMSFcXs8qG/01sdRHupb510IJFSSSoR
         RtR38BKsEWChTkFhTuSqCIMmxiDCrA600K8yXXslDMK2ZCgr7J8gLZoSbvBXU6ene3jP
         a1WSWWm47cIYHCaSotfjmrxn6rJ801hFrd1IjpTwHvVSG/oaKICRbkHJz5BkJ3aXl26W
         2ibEqPp9dHm3YD4NJgR50/lri8RuVySgAauULecb1dhurUOIqKyottDJDq/zR+zsdpPf
         fuSw==
X-Gm-Message-State: AGi0PubD+GjzHz6qEm3OqAOmTlrCqWYkf1TyFjnxFbG1nEPF5AjMiPbO
        8sWRxzpQNFpbpZcSbJ/9J2ljmzHd
X-Google-Smtp-Source: APiQypLx8oHfbCFmO4ZmoFs0bDixro1EhUtuQnWSXNZzicy+ylzwCez86O6anrnKbIzQEyN3nR61jw==
X-Received: by 2002:a17:90a:77c7:: with SMTP id e7mr1907667pjs.100.1585539067134;
        Sun, 29 Mar 2020 20:31:07 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id y193sm8512447pgd.87.2020.03.29.20.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 20:31:06 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     stable@vger.kernel.org
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH 0/2] A couple of important fixes for i915 on 5.4
Date:   Sun, 29 Mar 2020 20:30:55 -0700
Message-Id: <20200330033057.2629052-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

Hi,

This patchset contains fixes for two pesky i915 bugs that exist in 5.4.

The first bug, fixed by
"drm/i915/gt: Schedule request retirement when timeline idles" upstream, is very
high power consumption by i915 hardware due to an old commit that broke the RC6
power state for the iGPU on Skylake+. On my laptop, a Dell Precision 5540 with
an i9-9880H, the idle power consumption of my laptop with this commit goes down
from 10 W to 2 W, saving a massive 8 W of power. On other Skylake+ laptops I
tested, this commit reduced idle power consumption by at least a few watts. The
difference in power consumption can be observed by running `powertop` while
disconnected from the charger, or by using the intel-undervolt tool [1] and
running `intel-undervolt measure` which doesn't require being disconnected from
the charger. The psys measurement from intel-undervolt is the one of interest.

Backporting this commit was not trivial due to i915's high rate of churn, but
the backport didn't require changing any code from the original commit; it only
required moving code around and not altering some #includes.

The second bug causes severe graphical corruption and flickering on laptops
which support an esoteric power-saving mechanism called Panel Self Refresh
(PSR). Enabled by default in 5.0, PSR causes graphical corruption to the point
of unusability on many Dell laptops made within the past few years, since they
typically support PSR. A bug was filed with Intel a while ago for this with more
information [2]. I suspect most the community hasn't been affected by this bug
because ThinkPads and many other laptops I checked didn't support PSR. As of
writing, the issues I observed with PSR are fixed in Intel's drm-tip branch, but
i915 suffers from so much churn that backporting the individual PSR fixes is
infeasible (and an Intel engineer attested to this, saying that the PSR fixes in
drm-tip wouldn't be backported [3]). Disabling PSR by default brings us back to
pre-5.0 behavior, and from my tests with functional PSR in the drm-tip kernel,
I didn't observe any reduction in power consumption with PSR enabled, so there
isn't much lost from turning it off. Also, Ubuntu now ships with PSR disabled by
default in its affected kernels, so there is distro support behind this change.

Thanks,
Sultan

[1] https://github.com/kitsunyan/intel-undervolt
[2] https://gitlab.freedesktop.org/drm/intel/issues/425
[3] https://gitlab.freedesktop.org/drm/intel/issues/425#note_416130

Chris Wilson (1):
  drm/i915/gt: Schedule request retirement when timeline idles

Sultan Alsawaf (1):
  drm/i915: Disable Panel Self Refresh (PSR) by default

 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  2 +
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |  8 ++
 drivers/gpu/drm/i915/gt/intel_lrc.c           |  8 ++
 drivers/gpu/drm/i915/gt/intel_timeline.c      |  1 +
 .../gpu/drm/i915/gt/intel_timeline_types.h    |  3 +
 drivers/gpu/drm/i915/i915_params.c            |  3 +-
 drivers/gpu/drm/i915/i915_params.h            |  2 +-
 drivers/gpu/drm/i915/i915_request.c           | 73 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_request.h           |  4 +
 9 files changed, 101 insertions(+), 3 deletions(-)

-- 
2.26.0

