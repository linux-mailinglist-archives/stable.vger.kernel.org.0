Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2702D1E2BF6
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404017AbgEZTKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404013AbgEZTKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E0C208A7;
        Tue, 26 May 2020 19:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520237;
        bh=N9q+hXqobtsfiqZFTrDBSfSXunzw646JgJNaF6n8Mv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kgad6Elgsnp+w8oAXmwgl/Kbg78Y2VYCVd7c6sWLcDpze4A4lIhdm4tnfVzTNYELB
         kpU6uLW2wX6/SQ7w0C2VVyJ5ARXyJ9m5Ud2u2AVIpTxmWPvurVhDn6x7d4q/LrQaDD
         tUh9muPYrJ0k55hqXglgni+rsN/fDF2tKdFGfjRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 075/111] drm/i915: Propagate error from completed fences
Date:   Tue, 26 May 2020 20:53:33 +0200
Message-Id: <20200526183939.984384196@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit bc850943486887e3859597a266767f95db90aa72 upstream.

We need to preserve fatal errors from fences that are being terminated
as we hook them up.

Fixes: ef4688497512 ("drm/i915: Propagate fence errors")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200506162136.3325-1-chris@chris-wilson.co.uk
(cherry picked from commit 24fe5f2ab2478053d50a3bc629ada895903a5cbc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_request.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -894,8 +894,10 @@ i915_request_await_request(struct i915_r
 	GEM_BUG_ON(to == from);
 	GEM_BUG_ON(to->timeline == from->timeline);
 
-	if (i915_request_completed(from))
+	if (i915_request_completed(from)) {
+		i915_sw_fence_set_error_once(&to->submit, from->fence.error);
 		return 0;
+	}
 
 	if (to->engine->schedule) {
 		ret = i915_sched_node_add_dependency(&to->sched, &from->sched);


