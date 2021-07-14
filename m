Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8F13C8E70
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhGNTrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237870AbhGNTqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4082D613F0;
        Wed, 14 Jul 2021 19:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291775;
        bh=kcOiIndGyEDuWIne5+RyizCRbLn6dg+dE9xo30lzGmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6ChZbDZEqqj+FWJwJxrtFrGT3CedXEWcLNlwItMbWHxL2Vg55bcB/iHPxM9oHJmw
         cJ3tBG6rsxUzWij6jed+wjoL4FxlTEi67BMxolj6zIeIWftjLe6xxHf5hYAAhnT6/l
         P6XZKmP9MziKfkD4iqlVgbMlsNngOoSFcmfjiK+BmJNQGSbDXx6c4cqhFKT3wRKUqc
         a7HCILGfvadryxWo7bTZZbcxcbw+60yMYW0qN+YBq8R42niqeDo/7p2csC/oc1j2t7
         Hy8PRh0fxbC3v+ih7luY9pmCnSJlozM2ihFj3x1wa1nDAXHrJQrBcRJefEPtQ5slOk
         ePb5C61YyLHkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        gushengxian <gushengxian@yulong.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 098/102] perf/x86/intel/uncore: Clean up error handling path of iio mapping
Date:   Wed, 14 Jul 2021 15:40:31 -0400
Message-Id: <20210714194036.53141-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit d4ba0b06306a70c99a43f9d452886a86e2d3bd26 ]

The error handling path of iio mapping looks fragile. We already fixed
one issue caused by it, commit f797f05d917f ("perf/x86/intel/uncore:
Fix for iio mapping on Skylake Server"). Clean up the error handling
path and make the code robust.

Reported-by: gushengxian <gushengxian@yulong.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/40e66cf9-398b-20d7-ce4d-433be6e08921@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 9e1f64bc988b..f1c5d7cb7253 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3795,11 +3795,11 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 	/* One more for NULL. */
 	attrs = kcalloc((uncore_max_dies() + 1), sizeof(*attrs), GFP_KERNEL);
 	if (!attrs)
-		goto err;
+		goto clear_topology;
 
 	eas = kcalloc(uncore_max_dies(), sizeof(*eas), GFP_KERNEL);
 	if (!eas)
-		goto err;
+		goto clear_attrs;
 
 	for (die = 0; die < uncore_max_dies(); die++) {
 		sprintf(buf, "die%ld", die);
@@ -3820,7 +3820,9 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 	for (; die >= 0; die--)
 		kfree(eas[die].attr.attr.name);
 	kfree(eas);
+clear_attrs:
 	kfree(attrs);
+clear_topology:
 	kfree(type->topology);
 clear_attr_update:
 	type->attr_update = NULL;
-- 
2.30.2

