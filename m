Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6F2E42D1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406714AbgL1N4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406684AbgL1N4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E56206D4;
        Mon, 28 Dec 2020 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163771;
        bh=BAhzf8w1eCieG172JviMiUu2sSTegVojLKomA8d0QnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Btx+1bypF9FbODheKrXOUlKOaZ3mNBa7Sl0VpTHo60ncuuI0218DbmFx8JQFOZHmg
         +FaZMWmkirsmFhCQZwD9qPDKlNU2B2uEJ36VXYYa65+N+xkXVhDMfTsWdIviqOAb3W
         27IrW53+atVSRmZPBzKwib7Z/jGi7pLRzBdSNsZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CQ Tang <cq.tang@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 400/453] drm/i915: Fix mismatch between misplaced vma check and vma insert
Date:   Mon, 28 Dec 2020 13:50:36 +0100
Message-Id: <20201228124956.456066412@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0e53656ad8abc99e0a80c3de611e593ebbf55829 upstream.

When inserting a VMA, we restrict the placement to the low 4G unless the
caller opts into using the full range. This was done to allow usersapce
the opportunity to transition slowly from a 32b address space, and to
avoid breaking inherent 32b assumptions of some commands.

However, for insert we limited ourselves to 4G-4K, but on verification
we allowed the full 4G. This causes some attempts to bind a new buffer
to sporadically fail with -ENOSPC, but at other times be bound
successfully.

commit 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1
page") suggests that there is a genuine problem with stateless addressing
that cannot utilize the last page in 4G and so we purposefully excluded
it. This means that the quick pin pass may cause us to utilize a buggy
placement.

Reported-by: CQ Tang <cq.tang@intel.com>
Testcase: igt/gem_exec_params/larger-than-life-batch
Fixes: 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1 page")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: CQ Tang <cq.tang@intel.com>
Reviewed-by: CQ Tang <cq.tang@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v4.5+
Link: https://patchwork.freedesktop.org/patch/msgid/20201216092951.7124-1-chris@chris-wilson.co.uk
(cherry picked from commit 5f22cc0b134ab702d7f64b714e26018f7288ffee)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -367,7 +367,7 @@ eb_vma_misplaced(const struct drm_i915_g
 		return true;
 
 	if (!(flags & EXEC_OBJECT_SUPPORTS_48B_ADDRESS) &&
-	    (vma->node.start + vma->node.size - 1) >> 32)
+	    (vma->node.start + vma->node.size + 4095) >> 32)
 		return true;
 
 	if (flags & __EXEC_OBJECT_NEEDS_MAP &&


