Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42AF38C93A
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 16:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhEUOaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 10:30:30 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50762 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231279AbhEUOa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 10:30:29 -0400
Received: from callcc.thunk.org (c-73-8-226-230.hsd1.il.comcast.net [73.8.226.230])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 14LET2XQ006110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 10:29:04 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 797F3420119; Fri, 21 May 2021 10:29:01 -0400 (EDT)
Date:   Fri, 21 May 2021 10:29:01 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] ext4: fix memory leak in ext4_fill_super
Message-ID: <YKfDrcEfu7Gp0dGi@mit.edu>
References: <20210428221928.38960-1-amakhalov@vmware.com>
 <YKc6fidMj95TZp2w@mit.edu>
 <459B4724-842E-4B47-B2E7-D29805431E69@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <459B4724-842E-4B47-B2E7-D29805431E69@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 12:43:46AM -0700, Alexey Makhalov wrote:
> Hi Ted,
> 
> Good point! This paragraph can be just dropped as the next one
> describes the issue with superblock re-read. Will send v2 shortly.

Thanks; for what it's worth, I'm going to be editing the commit
description anyway; it's really helpful during the patch review to
understand how you found the problem, and how to reproduce it.
However, the commit description when it lands upstream will include a
link to this mail thread on lore.kernel.org, and so including a long
stack trace isn't really necessary.

I'm going to cut it down to something like this:

------------------------------
ext4: fix memory leak in ext4_fill_super

Buffer head references must be released before calling kill_bdev();
otherwise the buffer head (and its page referenced by b_data) will not
be freed by kill_bdev, and subsequently that bh will be leaked.

If blocksizes differ, sb_set_blocksize() will kill current buffers and
page cache by using kill_bdev(). And then super block will be reread
again but using correct blocksize this time. sb_set_blocksize() didn't
fully free superblock page and buffer head, and being busy, they were
not freed and instead leaked.

This can easily be reproduced by calling an infinite loop of:

  systemctl start <ext4_on_lvm>.mount, and
  systemctl stop <ext4_on_lvm>.mount

... since systemd creates a cgroup for each slice which it mounts, and
the bh leak get amplified by a dying memory cgroup that also never
gets freed, and memory consumption is much more easily noticed.

Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/459B4724-842E-4B47-B2E7-D29805431E69@vmware.com
Fixes: ce40733ce93d ("ext4: Check for return value from sb_set_blocksize")
Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
------------------------------

The commit description above is 18 lines (exclusive of trailers and
headers) versus 71 lines, and is much more to the point for someone
who might be doing code archeology via "git log".

When submitting this as a patch, you can either use a separate cover
letter (git format-patch --cover-letter) or including the explanation
after the --- in the diff, so that it disappears before the commit is
added via "git am".  But it's not that hard for me to rework a commit
description, so I'll take care of it for this patch; no need to send a
V3.

Cheers,

					- Ted
