Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A73B420FBF
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbhJDNhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237928AbhJDNfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEB9461B29;
        Mon,  4 Oct 2021 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353376;
        bh=5LHH11smJAUzyz2EB6zsfmZixhfw850NiAN27bFTEaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIo8w+EHw84oAoC+6u+R1ejQ7majorTwAFiYngSS8nSzIc37sUCZcKEGt0mO5+tKN
         zz/P8skgj5gtjEzZGPLRvhFntY5xVueJ6TJ4lhwh7j+Jr82EtN4QvuqFhyWwSEFZak
         pp6ZPWlTP5gIOLqT8ugWmfVn6Y5HFu4Oh4Nkm884=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 105/172] drm/i915: Remove warning from the rps worker
Date:   Mon,  4 Oct 2021 14:52:35 +0200
Message-Id: <20211004125048.371786173@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>

[ Upstream commit 4b8bcaf8a6d6ab5db51e30865def5cb694eb2966 ]

In commit 4e5c8a99e1cb ("drm/i915: Drop i915_request.lock requirement
for intel_rps_boost()"), we decoupled the rps worker from the pm so
that we could avoid the synchronization penalty which makes the
assertion liable to run too early. Which makes warning invalid hence
removed.

Fixes: 4e5c8a99e1cb ("drm/i915: Drop i915_request.lock requirement for intel_rps_boost()")

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210914090412.1393498-1-tejaskumarx.surendrakumar.upadhyay@intel.com
(cherry picked from commit a837a0686308d95ad9c48d32b4dfe86a17dc98c2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 06e9a8ed4e03..db9c212a240e 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -861,8 +861,6 @@ void intel_rps_park(struct intel_rps *rps)
 {
 	int adj;
 
-	GEM_BUG_ON(atomic_read(&rps->num_waiters));
-
 	if (!intel_rps_clear_active(rps))
 		return;
 
-- 
2.33.0



