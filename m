Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3505D45C4C1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354545AbhKXNvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351827AbhKXNt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22CB863355;
        Wed, 24 Nov 2021 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758993;
        bh=S1RHbH+sgXWCIKkgeaNozozTmPs19C4/3SpNVXY0/yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liiKHS7NfNxig7nJ6cpF0E4OKHt38TPU1maStsvNn65w2JzIFVXfrC2VLiJIe+/kr
         2tC+u4OkEz5fxIdpAafntRcL41vsFBZofi24VQollsQ58Y8vW+o+jCr/o9RCSs8ixh
         P7YneBbh4JEwNiAz30H5wXzdqNIfo4HjMlyqBZr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <likexu@tencent.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/279] perf/x86/vlbr: Add c->flags to vlbr event constraints
Date:   Wed, 24 Nov 2021 12:56:25 +0100
Message-Id: <20211124115722.161085316@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit 5863702561e625903ec678551cb056a4b19e0b8a ]

Just like what we do in the x86_get_event_constraints(), the
PERF_X86_EVENT_LBR_SELECT flag should also be propagated
to event->hw.flags so that the host lbr driver can save/restore
MSR_LBR_SELECT for the special vlbr event created by KVM or BPF.

Fixes: 097e4311cda9 ("perf/x86: Add constraint to create guest LBR event without hw counter")
Reported-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Wanpeng Li <wanpengli@tencent.com>
Link: https://lore.kernel.org/r/20211103091716.59906-1-likexu@tencent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index bc3f97f834011..c7f1cc433a6aa 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2999,8 +2999,10 @@ intel_vlbr_constraints(struct perf_event *event)
 {
 	struct event_constraint *c = &vlbr_constraint;
 
-	if (unlikely(constraint_match(c, event->hw.config)))
+	if (unlikely(constraint_match(c, event->hw.config))) {
+		event->hw.flags |= c->flags;
 		return c;
+	}
 
 	return NULL;
 }
-- 
2.33.0



