Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A8BA70AF
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfICQkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbfICQZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42CA323697;
        Tue,  3 Sep 2019 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527900;
        bh=jYhDg5UDXZYUyQ39bpjATWDx2ysRzftfB+YW2M0TD88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yb9xZlEs8RPxRt/1MXmIzMaXEb+8ih0WjfB9AbOmN36KmfVzYP5NDnWSk/z84vnub
         t/QsigSi0usA23OXjdCDsoE7HrNZfeU8ZnFdlKwlJNNKV4a4gjqn5a5VcxYI76xxHd
         9bfXFbc+KTIZFLoYGm2yZhYbIrAGJsmSTvUUyqnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Graunke <kenneth@whitecape.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 12/23] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.
Date:   Tue,  3 Sep 2019 12:24:13 -0400
Message-Id: <20190903162424.6877-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Graunke <kenneth@whitecape.org>

[ Upstream commit 248f883db61283b4f5a1c92a5e27277377b09f16 ]

The Demand Prefetch workaround (binding table prefetching) only applies
to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
applied to all Gen11 steppings, according to a programming note in the
SARCHKMD documentation.

Using the Intel Gallium driver, I have seen intermittent failures in
the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
applying this workaround, the tests reliably pass.

v2: Remove the overlap with a pre-production w/a

BSpec: 9663
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190625090655.19220-1-chris@chris-wilson.co.uk
(cherry picked from commit f9a393875d3af13cc3267477746608dadb7f17c1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 841b8e515f4d6..2fb70fab2d1c6 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1167,8 +1167,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		if (IS_ICL_REVID(i915, ICL_REVID_A0, ICL_REVID_B0))
 			wa_write_or(wal,
 				    GEN7_SARCHKMD,
-				    GEN7_DISABLE_DEMAND_PREFETCH |
-				    GEN7_DISABLE_SAMPLER_PREFETCH);
+				    GEN7_DISABLE_DEMAND_PREFETCH);
+
+		/* Wa_1606682166:icl */
+		wa_write_or(wal,
+			    GEN7_SARCHKMD,
+			    GEN7_DISABLE_SAMPLER_PREFETCH);
 	}
 
 	if (IS_GEN_RANGE(i915, 9, 11)) {
-- 
2.20.1

