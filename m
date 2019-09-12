Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2710FB1671
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 00:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfILWuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 18:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfILWuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 18:50:51 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99850206CD;
        Thu, 12 Sep 2019 22:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568328649;
        bh=owY8tPeH3sQTQ1Of9qzuZcG6Wih+amHz+jK7tLWasOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8wu/A+5V8cKq3un2s3rZj0jka7IbZijhnVYw3T6vO1MqXQT/DT2joHrd/L8gGBby
         xojrTGXctns42qnURxBOc2fQN2i24Si8GDhDFl3MX0uBtR70O4Y42mb7TN8pDE5IGC
         OqW7SaJdbaekzEY8lo32m0pv3IyFhjqq8WQPNH5o=
Date:   Thu, 12 Sep 2019 18:50:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.2 13/23] drm/i915/userptr: Acquire the page
 lock around set_page_dirty()
Message-ID: <20190912225043.GE1546@sasha-vm>
References: <20190903162424.6877-1-sashal@kernel.org>
 <20190903162424.6877-13-sashal@kernel.org>
 <36993214-6ce7-260f-68c7-6fbb0630143f@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <36993214-6ce7-260f-68c7-6fbb0630143f@mageia.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 11:51:33PM +0300, Thomas Backlund wrote:
>Den 03-09-2019 kl. 19:24, skrev Sasha Levin:
>>From: Chris Wilson <chris@chris-wilson.co.uk>
>>
>>[ Upstream commit aa56a292ce623734ddd30f52d73f527d1f3529b5 ]
>>
>>set_page_dirty says:
>>
>>	For pages with a mapping this should be done under the page lock
>>	for the benefit of asynchronous memory errors who prefer a
>>	consistent dirty state. This rule can be broken in some special
>>	cases, but should be better not to.
>>
>>Under those rules, it is only safe for us to use the plain set_page_dirty
>>calls for shmemfs/anonymous memory. Userptr may be used with real
>>mappings and so needs to use the locked version (set_page_dirty_lock).
>>
>>Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
>>Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
>>References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
>>Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>Cc: stable@vger.kernel.org
>>Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk
>>(cherry picked from commit cb6d7c7dc7ff8cace666ddec66334117a6068ce2)
>>Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  drivers/gpu/drm/i915/i915_gem_userptr.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>>diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
>>index 8079ea3af1039..b1fc15c7f5997 100644
>>--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
>>+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
>>@@ -678,7 +678,15 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>>  	for_each_sgt_page(page, sgt_iter, pages) {
>>  		if (obj->mm.dirty)
>>-			set_page_dirty(page);
>>+			/*
>>+			 * As this may not be anonymous memory (e.g. shmem)
>>+			 * but exist on a real mapping, we have to lock
>>+			 * the page in order to dirty it -- holding
>>+			 * the page reference is not sufficient to
>>+			 * prevent the inode from being truncated.
>>+			 * Play safe and take the lock.
>>+			 */
>>+			set_page_dirty_lock(page);
>>  		mark_page_accessed(page);
>>  		put_page(page);
>>
>
>
>Please drop this one from all 5.2 and 4.19 stable queues
>
>It has now been reverted in Linus tree:
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=505a8ec7e11ae5236c4a154a1e24ef49a8349600

Now dropped, thank you.

--
Thanks,
Sasha
