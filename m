Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9202ABAFB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgKINQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgKINQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5DE220663;
        Mon,  9 Nov 2020 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927812;
        bh=mZIslv/rCJwVBv/Ok4vmx5oj9FnjSWf9bLdVcEA5lVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj0uGVdOqUOUh99J2JVmfoTOHzdEAdNUcqV7RCW0xuu/MI48LjQDLeWa+T+uxeX/c
         beLcQu7dXFQhgt065cIH6QNxtJw8BGOX+LNEDe4XGfpC3QT3DdXAe/xt1HS1OkXPv3
         r/KvA9i6WFbs5hEOAmXKH2eZG2qjdEvc2chG6KTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 004/133] drm/i915/gem: Prevent using pgprot_writecombine() if PAT is not supported
Date:   Mon,  9 Nov 2020 13:54:26 +0100
Message-Id: <20201109125030.932169228@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ba2ebf605d5f32a9be0f7b05d3174bbc501b83fe upstream.

Let's not try and use PAT attributes for I915_MAP_WC if the CPU doesn't
support PAT.

Fixes: 6056e50033d9 ("drm/i915/gem: Support discontiguous lmem object maps")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200915091417.4086-2-chris@chris-wilson.co.uk
(cherry picked from commit 121ba69ffddc60df11da56f6d5b29bdb45c8eb80)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -254,6 +254,10 @@ static void *i915_gem_object_map(struct
 	if (!i915_gem_object_has_struct_page(obj) && type != I915_MAP_WC)
 		return NULL;
 
+	if (GEM_WARN_ON(type == I915_MAP_WC &&
+			!static_cpu_has(X86_FEATURE_PAT)))
+		return NULL;
+
 	/* A single page can always be kmapped */
 	if (n_pte == 1 && type == I915_MAP_WB) {
 		struct page *page = sg_page(sgt->sgl);


