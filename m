Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70988272F25
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgIUQya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgIUQqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B942223E;
        Mon, 21 Sep 2020 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706768;
        bh=8CgClc7n9JrrvXiLpWN8REZOBT57fFtY5L9Gom4cG6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3iHKQ/tl2lWJ+EQ55uhp84Cdkxi+UzIYc72fvh4ySp0KIlD73unT4LFbh2VScyW0
         UjneeH0inc8kdC0ZEiK8qUz7VtYQeygTJV6sHCE6+phsDN3XiVZBsJNGq5AaNfTHwn
         SBEX3vqxYSu6I3WWnQdqgUxwE40gn7DfuZYgiX1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.8 085/118] drm/i915: Filter wake_flags passed to default_wake_function
Date:   Mon, 21 Sep 2020 18:28:17 +0200
Message-Id: <20200921162040.295019326@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 20612303a0b45de748d31331407e84300c38e497 upstream.

(NOTE: This is the minimal backportable fix, a full fix is being
developed at https://patchwork.freedesktop.org/patch/388048/)

The flags passed to the wait_entry.func are passed onwards to
try_to_wake_up(), which has a very particular interpretation for its
wake_flags. In particular, beyond the published WF_SYNC, it has a few
internal flags as well. Since we passed the fence->error down the chain
via the flags argument, these ended up in the default_wake_function
confusing the kernel/sched.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2110
Fixes: ef4688497512 ("drm/i915: Propagate fence errors")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200728152144.1100-1-chris@chris-wilson.co.uk
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Joonas: Rebased and reordered into drm-intel-gt-next branch]
[Joonas: Added a note and link about more complete fix]
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit f4b3c395540aa3d4f5a6275c5bdd83ab89034806)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_sw_fence.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -164,9 +164,13 @@ static void __i915_sw_fence_wake_up_all(
 
 		do {
 			list_for_each_entry_safe(pos, next, &x->head, entry) {
-				pos->func(pos,
-					  TASK_NORMAL, fence->error,
-					  &extra);
+				int wake_flags;
+
+				wake_flags = fence->error;
+				if (pos->func == autoremove_wake_function)
+					wake_flags = 0;
+
+				pos->func(pos, TASK_NORMAL, wake_flags, &extra);
 			}
 
 			if (list_empty(&extra))


