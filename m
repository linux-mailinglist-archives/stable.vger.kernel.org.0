Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5670761671
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfGGTiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57822 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727640AbfGGTiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:14 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzC-0006j1-HH; Sun, 07 Jul 2019 20:38:10 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005eT-PT; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Andrey Ryabinin" <aryabinin@virtuozzo.com>,
        "Michal Hocko" <mhocko@suse.com>, "Joe Perches" <joe@perches.com>,
        "Roman Penyaev" <rpenyaev@suse.de>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.673598026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 101/129] mm/vmalloc: fix size check for
 remap_vmalloc_range_partial()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Penyaev <rpenyaev@suse.de>

commit 401592d2e095947344e10ec0623adbcd58934dd4 upstream.

When VM_NO_GUARD is not set area->size includes adjacent guard page,
thus for correct size checking get_vm_area_size() should be used, but
not area->size.

This fixes possible kernel oops when userspace tries to mmap an area on
1 page bigger than was allocated by vmalloc_user() call: the size check
inside remap_vmalloc_range_partial() accounts non-existing guard page
also, so check successfully passes but vmalloc_to_page() returns NULL
(guard page does not physically exist).

The following code pattern example should trigger an oops:

  static int oops_mmap(struct file *file, struct vm_area_struct *vma)
  {
        void *mem;

        mem = vmalloc_user(4096);
        BUG_ON(!mem);
        /* Do not care about mem leak */

        return remap_vmalloc_range(vma, mem, 0);
  }

And userspace simply mmaps size + PAGE_SIZE:

  mmap(NULL, 8192, PROT_WRITE|PROT_READ, MAP_PRIVATE, fd, 0);

Possible candidates for oops which do not have any explicit size
checks:

   *** drivers/media/usb/stkwebcam/stk-webcam.c:
   v4l_stk_mmap[789]   ret = remap_vmalloc_range(vma, sbuf->buffer, 0);

Or the following one:

   *** drivers/video/fbdev/core/fbmem.c
   static int
   fb_mmap(struct file *file, struct vm_area_struct * vma)
        ...
        res = fb->fb_mmap(info, vma);

Where fb_mmap callback calls remap_vmalloc_range() directly without any
explicit checks:

   *** drivers/video/fbdev/vfb.c
   static int vfb_mmap(struct fb_info *info,
             struct vm_area_struct *vma)
   {
       return remap_vmalloc_range(vma, (void *)info->fix.smem_start, vma->vm_pgoff);
   }

Link: http://lkml.kernel.org/r/20190103145954.16942-2-rpenyaev@suse.de
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joe Perches <joe@perches.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2141,7 +2141,7 @@ int remap_vmalloc_range_partial(struct v
 	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
-	if (kaddr + size > area->addr + area->size)
+	if (kaddr + size > area->addr + get_vm_area_size(area))
 		return -EINVAL;
 
 	do {

