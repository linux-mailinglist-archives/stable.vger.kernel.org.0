Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A90B3D1044
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhGUNLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 09:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232706AbhGUNLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 09:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11CD261019;
        Wed, 21 Jul 2021 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626875542;
        bh=k0r7qrsg0M7ihDhUVH7iZityllEC/LbAUdWjhg/9KDw=;
        h=Subject:To:From:Date:From;
        b=iTzm8ZUvkK1O0W5hqf3p49WhYbZ3SDxxSB7Sc5PXq2BXIW7k+quOIWMexKqr+2WMJ
         P8daMFdPpM6EJH06lZXe6UnsdAbQtPlF9naLq74UIVVEVKOP5iV8zNZIE02F7HhoWX
         xg4jirjFBgLU/h9b/EOEz5MVoaNZuKTPlFLQ7EjQ=
Subject: patch "nds32: fix up stack guard gap" added to char-misc-linus
To:     gregkh@linuxfoundation.org, cyruscyliu@gmail.com,
        deanbo422@gmail.com, green.hu@gmail.com, hughd@google.com,
        mhocko@suse.com, nickhu@andestech.com, stable@vger.kernel.org,
        yixiaonn@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 15:52:19 +0200
Message-ID: <1626875539378@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nds32: fix up stack guard gap

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c453db6cd96418c79702eaf38259002755ab23ff Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 29 Jun 2021 12:40:24 +0200
Subject: nds32: fix up stack guard gap

Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
up all architectures to deal with the stack guard gap.  But when nds32
was added to the tree, it forgot to do the same thing.

Resolve this by properly fixing up the nsd32's version of
arch_get_unmapped_area()

Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qiang Liu <cyruscyliu@gmail.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: iLifetruth <yixiaonn@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Link: https://lore.kernel.org/r/20210629104024.2293615-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nds32/mm/mmap.c b/arch/nds32/mm/mmap.c
index c206b31ce07a..1bdf5e7d1b43 100644
--- a/arch/nds32/mm/mmap.c
+++ b/arch/nds32/mm/mmap.c
@@ -59,7 +59,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 
 		vma = find_vma(mm, addr);
 		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vma->vm_start))
+		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
 
-- 
2.32.0


