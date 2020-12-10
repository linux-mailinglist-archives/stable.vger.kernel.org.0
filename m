Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373442D6095
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391173AbgLJOio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391165AbgLJOij (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Dutt <sudeep.dutt@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        CQ Tang <cq.tang@intel.com>,
        Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 37/75] drm/i915/gt: Retain default context state across shrinking
Date:   Thu, 10 Dec 2020 15:27:02 +0100
Message-Id: <20201210142607.890936514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>

commit 78b2eb8a1f10f366681acad8d21c974c1f66791a upstream.

As we use a shmemfs file to hold the context state, when not in use it
may be swapped out, such as across suspend. Since we wrote into the
shmemfs without marking the pages as dirty, the contents may be dropped
instead of being written back to swap. On re-using the shmemfs file,
such as creating a new context after resume, the contents of that file
were likely garbage and so the new context could then hang the GPU.

Simply mark the page as being written when copying into the shmemfs
file, and it the new contents will be retained across swapout.

Fixes: be1cb55a07bf ("drm/i915/gt: Keep a no-frills swappable copy of the default context state")
Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Signed-off-by: CQ Tang <cq.tang@intel.com>
Signed-off-by: Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.8+
Link: https://patchwork.freedesktop.org/patch/msgid/20201127120718.454037-161-matthew.auld@intel.com
(cherry picked from commit a9d71f76ccfd309f3bd5f7c9b60e91a4decae792)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/shmem_utils.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/shmem_utils.c
+++ b/drivers/gpu/drm/i915/gt/shmem_utils.c
@@ -143,10 +143,13 @@ static int __shmem_rw(struct file *file,
 			return PTR_ERR(page);
 
 		vaddr = kmap(page);
-		if (write)
+		if (write) {
 			memcpy(vaddr + offset_in_page(off), ptr, this);
-		else
+			set_page_dirty(page);
+		} else {
 			memcpy(ptr, vaddr + offset_in_page(off), this);
+		}
+		mark_page_accessed(page);
 		kunmap(page);
 		put_page(page);
 


