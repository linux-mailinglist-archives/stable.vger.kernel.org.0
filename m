Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC45D1647A
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfEGNXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 09:23:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:37304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726321AbfEGNXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 09:23:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 756B6AEBF;
        Tue,  7 May 2019 13:23:30 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 097871E3C5A; Tue,  7 May 2019 15:23:30 +0200 (CEST)
Date:   Tue, 7 May 2019 15:23:30 +0200
From:   Jan Kara <jack@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 50/95] fsnotify: generalize handling of
 extra event flags
Message-ID: <20190507132330.GB4635@quack2.suse.cz>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-50-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507053826.31622-50-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-05-19 01:37:39, Sasha Levin wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> [ Upstream commit 007d1e8395eaa59b0e7ad9eb2b53a40859446a88 ]
> 
> FS_EVENT_ON_CHILD gets a special treatment in fsnotify() because it is
> not a flag specifying an event type, but rather an extra flags that may
> be reported along with another event and control the handling of the
> event by the backend.
> 
> FS_ISDIR is also an "extra flag" and not an "event type" and therefore
> desrves the same treatment. With inotify/dnotify backends it was never
> possible to set FS_ISDIR in mark masks, so it did not matter.
> With fanotify backend, mark adding code jumps through hoops to avoid
> setting the FS_ISDIR in the commulative object mask.
> 
> Separate the constant ALL_FSNOTIFY_EVENTS to ALL_FSNOTIFY_FLAGS and
> ALL_FSNOTIFY_EVENTS, so the latter can be used to test for specific
> event types.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>

Sasha, why did you select this patch? It is just a cleanup with no user
visible effect and was done mostly to simplify implementing following
features...

								Honza

> ---
>  fs/notify/fsnotify.c             | 7 +++----
>  include/linux/fsnotify_backend.h | 9 +++++++--
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> index 506da82ff3f1..dc080c642dd0 100644
> --- a/fs/notify/fsnotify.c
> +++ b/fs/notify/fsnotify.c
> @@ -192,7 +192,7 @@ static int send_to_group(struct inode *to_tell,
>  			 struct fsnotify_iter_info *iter_info)
>  {
>  	struct fsnotify_group *group = NULL;
> -	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
> +	__u32 test_mask = (mask & ALL_FSNOTIFY_EVENTS);
>  	__u32 marks_mask = 0;
>  	__u32 marks_ignored_mask = 0;
>  
> @@ -256,8 +256,7 @@ int fsnotify(struct inode *to_tell, __u32 mask, const void *data, int data_is,
>  	struct fsnotify_iter_info iter_info;
>  	struct mount *mnt;
>  	int ret = 0;
> -	/* global tests shouldn't care about events on child only the specific event */
> -	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
> +	__u32 test_mask = (mask & ALL_FSNOTIFY_EVENTS);
>  
>  	if (data_is == FSNOTIFY_EVENT_PATH)
>  		mnt = real_mount(((const struct path *)data)->mnt);
> @@ -380,7 +379,7 @@ static __init int fsnotify_init(void)
>  {
>  	int ret;
>  
> -	BUG_ON(hweight32(ALL_FSNOTIFY_EVENTS) != 23);
> +	BUG_ON(hweight32(ALL_FSNOTIFY_BITS) != 23);
>  
>  	ret = init_srcu_struct(&fsnotify_mark_srcu);
>  	if (ret)
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> index ce74278a454a..81052313adeb 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -67,15 +67,20 @@
>  
>  #define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM)
>  
> +/* Events that can be reported to backends */
>  #define ALL_FSNOTIFY_EVENTS (FS_ACCESS | FS_MODIFY | FS_ATTRIB | \
>  			     FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN | \
>  			     FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE | \
>  			     FS_DELETE | FS_DELETE_SELF | FS_MOVE_SELF | \
>  			     FS_UNMOUNT | FS_Q_OVERFLOW | FS_IN_IGNORED | \
> -			     FS_OPEN_PERM | FS_ACCESS_PERM | FS_EXCL_UNLINK | \
> -			     FS_ISDIR | FS_IN_ONESHOT | FS_DN_RENAME | \
> +			     FS_OPEN_PERM | FS_ACCESS_PERM | FS_DN_RENAME)
> +
> +/* Extra flags that may be reported with event or control handling of events */
> +#define ALL_FSNOTIFY_FLAGS  (FS_EXCL_UNLINK | FS_ISDIR | FS_IN_ONESHOT | \
>  			     FS_DN_MULTISHOT | FS_EVENT_ON_CHILD)
>  
> +#define ALL_FSNOTIFY_BITS   (ALL_FSNOTIFY_EVENTS | ALL_FSNOTIFY_FLAGS)
> +
>  struct fsnotify_group;
>  struct fsnotify_event;
>  struct fsnotify_mark;
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
