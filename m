Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2E2A8FCC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389343AbfIDSFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389335AbfIDSFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:05:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC022341B;
        Wed,  4 Sep 2019 18:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620353;
        bh=dFom+vnutnq3Ba+A9r8rQfUz5K+76ud16x0BKCELUrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRAheQIxrrOHkOJaTV7BsAXZqaQxwdN24cBgIP0zsbCHBxhA5E3gPHeytzHP2AziB
         ffdvrYC4Xd2WdINDHGsSJeq/XL19QE0wawfXoizI0jOqtmSEjaIpEPiiKrmR3CPnS5
         LuBURjrv9ZtPXBkEyOCLB/cgAkWB88wKLfnW/RyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/93] drm/i915: fix broadwell EU computation
Date:   Wed,  4 Sep 2019 19:53:28 +0200
Message-Id: <20190904175305.641446001@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 63ac3328f0d1d37f286e397b14d9596ed09d7ca5 ]

subslice_mask is an array indexed by slice, not subslice.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: 8cc7669355136f ("drm/i915: store all subslice masks")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108712
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181112123931.2815-1-lionel.g.landwerlin@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_device_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_device_info.c b/drivers/gpu/drm/i915/intel_device_info.c
index 0ef0c6448d53a..01fa98299bae6 100644
--- a/drivers/gpu/drm/i915/intel_device_info.c
+++ b/drivers/gpu/drm/i915/intel_device_info.c
@@ -474,7 +474,7 @@ static void broadwell_sseu_info_init(struct drm_i915_private *dev_priv)
 			u8 eu_disabled_mask;
 			u32 n_disabled;
 
-			if (!(sseu->subslice_mask[ss] & BIT(ss)))
+			if (!(sseu->subslice_mask[s] & BIT(ss)))
 				/* skip disabled subslice */
 				continue;
 
-- 
2.20.1



