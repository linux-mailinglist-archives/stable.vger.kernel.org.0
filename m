Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C043C8D3D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbhGNToQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235927AbhGNTnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A90613D7;
        Wed, 14 Jul 2021 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291629;
        bh=RiM7k+/NBviQcsk8+FG0hXNIHhOXpACT94wSjDwPxAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrFnPAXj7Q7FECgzuCA/bZv6zwaQOYWinlLVdXZprAfz7+O/s8p0W2XhiX3nGGAiW
         +Z58bdCXBDZQqEKFkp88kioIJiDlhviJgnm0jov1+jVsDx0xZc1X+vFQj60tP0hMZg
         mBJxhPhO0k3axzyU6s7pHK1u2/7yjitvbx5gpWOJcCZ+AXqeUTdzgKjidbCSROclnX
         3QUR2044anhMiErmu3/JIUj1yq3q9Js9za9QBO42k+e2p/O2jolpAwVIx5yYp1QgRH
         TjUfmuBrtpohR2rAcu0GHymCI5v6QSasEq5Lnhb7ejTtxrMSxjKui1Tf6XStDWCZVf
         qKfpfB3WjgRvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        gushengxian <gushengxian@yulong.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 104/108] perf/x86/intel/uncore: Clean up error handling path of iio mapping
Date:   Wed, 14 Jul 2021 15:37:56 -0400
Message-Id: <20210714193800.52097-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 3a75a2c601c2..1f7bb4898a9d 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3789,11 +3789,11 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
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
@@ -3814,7 +3814,9 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
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

