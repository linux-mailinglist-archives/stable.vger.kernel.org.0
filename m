Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA02C45137B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348292AbhKOTvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343630AbhKOTVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B90635BF;
        Mon, 15 Nov 2021 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001796;
        bh=EXzKFNV9CHR+H4ryuysgbWy1pm070uAsHFD+RQ/5uig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCkUhsrAzSIytS7VVPRiGYquk+L0UcPbxDNHQ4vTFe9flEypy3AFreGw/vuYWQ/yp
         LWEAhJbgpLyjl33D0VVg6dc/Z/GF1yEGhF1tfwQbULkCOhEGt9Pf+WwqiLW0/IA9uP
         MmsGX8c4Py1VG/xU5rWSrxfB0KhwGrVucA/GN4HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/917] perf/x86/intel/uncore: Fix Intel SPR IIO event constraints
Date:   Mon, 15 Nov 2021 17:56:59 +0100
Message-Id: <20211115165439.731469131@linuxfoundation.org>
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

[ Upstream commit 67c5d44384f8dc57e1c1b3040423cfce99b578cd ]

SPR IIO events have the exact same event constraints as ICX, so add the
constraints.

Fixes: 3ba7095beaec ("perf/x86/intel/uncore: Add Sapphire Rapids server IIO support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1629991963-102621-6-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index ce85ee5f60f97..2d75d212c8cc4 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5661,6 +5661,7 @@ static struct intel_uncore_type spr_uncore_iio = {
 	.event_mask_ext		= SNR_IIO_PMON_RAW_EVENT_MASK_EXT,
 	.format_group		= &snr_uncore_iio_format_group,
 	.attr_update		= uncore_alias_groups,
+	.constraints		= icx_uncore_iio_constraints,
 };
 
 static struct attribute *spr_uncore_raw_formats_attr[] = {
-- 
2.33.0



