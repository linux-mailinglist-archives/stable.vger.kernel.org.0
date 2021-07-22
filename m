Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C983D29E2
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhGVQHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235027AbhGVQF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63F0561976;
        Thu, 22 Jul 2021 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972391;
        bh=9hGHan/oXjA+zoZHeKNt5/u8c8lhTFx2CI0DaIQZGMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMPuyb8d+z8NXmmhDnge5k6L0CHe9qjqJem+NLoM/3G4cXQlT5l5FxQSIdwejku73
         BPhNZNiv6R6uBHpkC/qckYuPkcxipMjNx0W6uDKGgF8LyTagKdfJ3tbFzcjE7zcaCk
         ivO5hxNBX8El/xmvdVor8MArnhuN1S5sVrIWM++4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, gushengxian <gushengxian@yulong.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 096/156] perf/x86/intel/uncore: Clean up error handling path of iio mapping
Date:   Thu, 22 Jul 2021 18:31:11 +0200
Message-Id: <20210722155631.487399162@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -3814,7 +3814,9 @@ err:
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



