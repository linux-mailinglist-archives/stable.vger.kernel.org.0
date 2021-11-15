Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9494520D4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349406AbhKPA4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343616AbhKOTV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3478B635BD;
        Mon, 15 Nov 2021 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001791;
        bh=DaCfvzE/PurnpKDm1f1w/40iGwtbVS7AV2SLlbTJBVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLAMOHxDsju5k0FAQk33LFIV6yJfXHQEME8JlGBTofCeoSn+NzjcpHmYEUXz7Apk9
         k0KODV3AaMqO9r3h8swhz6GzN2ubzig0j3+ea0EYGm1nSGak5+qhvWklZQ0BUu4bUa
         GuVJFoDZXBmEtAB1qU7VgP4XMhPMYI+2/7MYICQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/917] perf/x86/intel/uncore: Fix Intel SPR CHA event constraints
Date:   Mon, 15 Nov 2021 17:56:58 +0100
Message-Id: <20211115165439.690427774@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 9d756e408e080d40e7916484b00c802026e6d1ad ]

SPR CHA events have the exact same event constraints as SKX, so add the
constraints.

Fixes: 949b11381f81 ("perf/x86/intel/uncore: Add Sapphire Rapids server CHA support")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1629991963-102621-5-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index d941854e4efaa..ce85ee5f60f97 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5649,6 +5649,7 @@ static struct intel_uncore_type spr_uncore_chabox = {
 	.event_mask		= SPR_CHA_PMON_EVENT_MASK,
 	.event_mask_ext		= SPR_RAW_EVENT_MASK_EXT,
 	.num_shared_regs	= 1,
+	.constraints		= skx_uncore_chabox_constraints,
 	.ops			= &spr_uncore_chabox_ops,
 	.format_group		= &spr_uncore_chabox_format_group,
 	.attr_update		= uncore_alias_groups,
-- 
2.33.0



