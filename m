Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C279930C022
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhBBNuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232982AbhBBNr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE41864F9B;
        Tue,  2 Feb 2021 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273325;
        bh=1wX7qwo1dJqDUD841LziCf3Dw4cpG93Vp6uL2G3iM+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNEYONwC7eUOM0fuCcAe5eVgUXWDB+gMx0+NKGhQCAZGPj33U4LiGHuqgIInlwXS/
         GJaEhwILwjDVEgZoXBPx/7ZoYT2Jd6Lo/9ljIUJfiIqwNXTxuqRwmxTstwa6BThZmd
         6kAMTH90m2E0olE7ZJt0BmDLD9CoTQtnfGJ2NPw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 064/142] drm/i915/selftest: Fix potential memory leak
Date:   Tue,  2 Feb 2021 14:37:07 +0100
Message-Id: <20210202133000.362156066@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 3d480fe1befa0ef434f5c25199e7d45c26870555 upstream.

Object out is not released on path that no VMA instance found. The root
cause is jumping to an unexpected label on the error path.

Fixes: a47e788c2310 ("drm/i915/selftests: Exercise CS TLB invalidation")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20210122015640.16002-1-bianpan2016@163.com
(cherry picked from commit 2b015017d5cb01477a79ca184ac25c247d664568)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -1880,7 +1880,7 @@ static int igt_cs_tlb(void *arg)
 	vma = i915_vma_instance(out, vm, NULL);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
-		goto out_put_batch;
+		goto out_put_out;
 	}
 
 	err = i915_vma_pin(vma, 0, 0,


