Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52166428FD9
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhJKOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237947AbhJKN7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFBCD61040;
        Mon, 11 Oct 2021 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960592;
        bh=07zuXDl2yZKFGkwixI//zv85eW7rTXGOHY9Ec52sMGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UO9v7yCXszZZrYODaV9JutRrnoebflE8pxSElptlwt6B0cYOAXziNt01CEGnNz84J
         TG/pp/0FzsMf6T8LxNfVVbLHMAutb5YRK12E68jP49Yn+2LvTqMxntLDsKzLrqTGLG
         rPhnhevExCM6C9z4Uc6OHHONLWAd9f5Vp8AWciTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.14 018/151] drm/i915: Fix runtime pm handling in i915_gem_shrink
Date:   Mon, 11 Oct 2021 15:44:50 +0200
Message-Id: <20211011134518.441865089@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

commit 0c94777386495d6e0a9735d48ffd2abb8d680d7f upstream.

We forgot to call intel_runtime_pm_put on error, fix it!

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: cf41a8f1dc1e ("drm/i915: Finally remove obj->mm.lock.")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v5.13+
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210830121006.2978297-9-maarten.lankhorst@linux.intel.com
(cherry picked from commit 239f3c2ee18376587026efecaea5250fa5926d20)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
@@ -118,7 +118,7 @@ i915_gem_shrink(struct i915_gem_ww_ctx *
 	intel_wakeref_t wakeref = 0;
 	unsigned long count = 0;
 	unsigned long scanned = 0;
-	int err;
+	int err = 0;
 
 	/* CHV + VTD workaround use stop_machine(); need to trylock vm->mutex */
 	bool trylock_vm = !ww && intel_vm_no_concurrent_access_wa(i915);
@@ -242,12 +242,15 @@ skip:
 		list_splice_tail(&still_in_list, phase->list);
 		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
 		if (err)
-			return err;
+			break;
 	}
 
 	if (shrink & I915_SHRINK_BOUND)
 		intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 
+	if (err)
+		return err;
+
 	if (nr_scanned)
 		*nr_scanned += scanned;
 	return count;


