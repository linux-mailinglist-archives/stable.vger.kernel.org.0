Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0AA5233C
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 08:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfFYGBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 02:01:52 -0400
Received: from smtp107.ord1c.emailsrvr.com ([108.166.43.107]:45130 "EHLO
        smtp107.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbfFYGBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 02:01:52 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 02:01:52 EDT
X-Auth-ID: kenneth@whitecape.org
Received: by smtp6.relay.ord1c.emailsrvr.com (Authenticated sender: kenneth-AT-whitecape.org) with ESMTPSA id 05DA9A0147;
        Tue, 25 Jun 2019 01:55:27 -0400 (EDT)
X-Sender-Id: kenneth@whitecape.org
Received: from kirito.trees (50-39-175-242.bvtn.or.frontiernet.net [50.39.175.242])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Tue, 25 Jun 2019 01:55:28 -0400
From:   Kenneth Graunke <kenneth@whitecape.org>
To:     intel-gfx@lists.freedesktop.org
Cc:     Kenneth Graunke <kenneth@whitecape.org>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.
Date:   Mon, 24 Jun 2019 22:55:21 -0700
Message-Id: <20190625055521.5730-1-kenneth@whitecape.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Demand Prefetch workaround (binding table prefetching) only applies
to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
applied to all Gen11 steppings, according to a programming note in the
SARCHKMD documentation.

Using the Intel Gallium driver, I have seen intermittent failures in
the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
applying this workaround, the tests reliably pass.

BSpec: 9663
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 5 +++++
 1 file changed, 5 insertions(+)

Hi there!

We tried to work around this in the Mesa driver, and managed to do so
in i965, anv, iris, but missed doing so in blorp.  Oops!  I'm planning
on fixing that, but setting the SARCHKMD bit to shut off the broken
prefetching globally seems like a good idea.  That way, we make sure it
works for i965, anv, iris, libva, and all the other userspace drivers.

FWIW, I don't have commit access, so I would appreciate it if someone
could commit this for me assuming it clears review and testing.

 --Ken

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index c70445adfb02..a3cb35d058a6 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1254,6 +1254,11 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 				    GEN7_SARCHKMD,
 				    GEN7_DISABLE_DEMAND_PREFETCH |
 				    GEN7_DISABLE_SAMPLER_PREFETCH);
+
+		/* Wa_1606682166:icl */
+		wa_write_or(wal,
+			    GEN7_SARCHKMD,
+			    GEN7_DISABLE_SAMPLER_PREFETCH);
 	}
 
 	if (IS_GEN_RANGE(i915, 9, 11)) {
-- 
2.22.0

