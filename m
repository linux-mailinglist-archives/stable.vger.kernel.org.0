Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFBF15451F
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 14:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBFNlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 08:41:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:59886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgBFNlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 08:41:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 28E3AB27A;
        Thu,  6 Feb 2020 13:41:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A73DCDA952; Thu,  6 Feb 2020 14:41:30 +0100 (CET)
Date:   Thu, 6 Feb 2020 14:41:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: print message when tree-log replay starts
Message-ID: <20200206134130.GV2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>, stable@vger.kernel.org
References: <20200205161216.24260-1-dsterba@suse.com>
 <69682127-4580-8795-5d8f-fc18d6d840fd@oracle.com>
 <f9291224-ec67-f54b-3b09-5938c81e1568@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9291224-ec67-f54b-3b09-5938c81e1568@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 11:48:28AM +0800, Anand Jain wrote:
> On 2/6/20 11:45 AM, Anand Jain wrote:
> > On 2/6/20 12:12 AM, David Sterba wrote:
> >> There's no logged information about tree-log replay although this is
> >> something that points to previous unclean unmount. Other filesystems
> >> report that as well.
> >>
> >> Suggested-by: Chris Murphy <lists@colorremedies.com>
> >> CC: stable@vger.kernel.org # 4.4+
> >> Signed-off-by: David Sterba <dsterba@suse.com>
> >> ---
> >>   fs/btrfs/disk-io.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 28622de9e642..295d5ebc9d5e 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -3146,6 +3146,7 @@ int __cold open_ctree(struct super_block *sb,
> >>       /* do not make disk changes in broken FS or nologreplay is given */
> >>       if (btrfs_super_log_root(disk_super) != 0 &&
> >>           !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
> 
> 
> >> +        btrfs_info("start tree-log replay");
> 
> btrfs_info() needs struct btrfs_fs_info as first arg.

Doh, that's what I get when I take months old patches and only briefly
review them before sending.
