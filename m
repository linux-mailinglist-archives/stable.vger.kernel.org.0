Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9264B45BEAD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbhKXMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345387AbhKXMrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:47:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D7661268;
        Wed, 24 Nov 2021 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756865;
        bh=URa0K+KCJM1LCCQSFou5R6A5wDbXfaMI6as2zgKG9Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFNA+znPETq6MGIDFA5P/cti8jVUW9NAlcA304Egnw5A/9adUa2xiGUbMUNnk5D1c
         UURYyWzqpvqlYI1MmJQp9VjoZnVBl3BA/FBwOsz36c+z3tpo/iBQYJVf00BpnR3tIq
         AhNWu8U0gLMr/XTuAwUni1zUDKVk0nbIWxOsGFkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 233/251] perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server
Date:   Wed, 24 Nov 2021 12:57:55 +0100
Message-Id: <20211124115718.398239941@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Antonov <alexander.antonov@linux.intel.com>

[ Upstream commit 3866ae319c846a612109c008f43cba80b8c15e86 ]

According to the latest uncore document, COMP_BUF_OCCUPANCY (0xd5) event
can be collected on 2-3 counters. Update uncore IIO event constraints for
Skylake Server.

Fixes: cd34cd97b7b4 ("perf/x86/intel/uncore: Add Skylake server uncore support")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20211115090334.3789-3-alexander.antonov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 9cce6d9fec1f4..b039d416fef34 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3453,6 +3453,7 @@ static struct event_constraint skx_uncore_iio_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0xc0, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0xc5, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0xd4, 0xc),
+	UNCORE_EVENT_CONSTRAINT(0xd5, 0xc),
 	EVENT_CONSTRAINT_END
 };
 
-- 
2.33.0



