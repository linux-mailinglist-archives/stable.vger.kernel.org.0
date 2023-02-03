Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BD8689178
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 09:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjBCICB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 03:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbjBCIBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 03:01:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E2195D14;
        Fri,  3 Feb 2023 00:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8485B827B1;
        Fri,  3 Feb 2023 08:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350F3C433EF;
        Fri,  3 Feb 2023 08:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675411221;
        bh=doIPG1PHyzm6d1DSa5nWk+jTUGsI/pTAYkKovWY+noQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zMgPy/kfGYHzVvcTtpmjprlI/6J7/W5Zdi1LGRDmANAAo6W5/kf3E/zNj08qu+zh5
         5+1Fh1IpIQVab84AayR0NE7O6t3qO9BoQG421ZFfFELOUQcrbs2+ascSimzOKxVwKu
         XqNBTqdKMcXkipXOJX58QSENB0zLIZGK/TxxnxPM=
Date:   Fri, 3 Feb 2023 09:00:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.co
Subject: Re: [PATCH stable 4.14 0/1] Fix ext4 xfstests failure
Message-ID: <Y9y/ElCYnDLTrLv6@kroah.com>
References: <20230131043815.14989-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131043815.14989-1-risbhat@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 31, 2023 at 04:38:14AM +0000, Rishabh Bhatnagar wrote:
> While running xfstests on 4.14.304 version we see a warning being
> generated in one of ext4 tests with the following stack trace.
> 
> WARNING: CPU: 4 PID: 15332 at mm/util.c:414
> kvmalloc_node+0x67/0x70
> ext4_expand_extra_isize_ea+0x2b4/0x870 [ext4]
> __ext4_expand_extra_isize+0xcb/0x120 [ext4]
> ext4_mark_inode_dirty+0x1a5/0x1d0 [ext4]
> ext4_ext_truncate+0x1f/0x90 [ext4]
> ext4_truncate+0x363/0x400 [ext4]
> ext4_setattr+0x392/0xa00 [ext4]
> notify_change+0x300/0x420
> ? ext4_xattr_security_set+0x20/0x20 [ext4]
> do_truncate+0x75/0xc0
> ? ext4_release_file+0xa0/0xa0 [ext4]
> path_openat+0x737/0x16f0
> do_filp_open+0x9b/0x110
> ? __check_object_size+0xb4/0x190
> ? do_sys_open+0x1bd/0x250
> do_sys_open+0x1bd/0x250
> do_syscall_64+0x67/0x110
> entry_SYSCALL_64_after_hwframe+0x59/0xbe
> 
> It seems rebase to 4.14.304 brings a bunch of ext4 changes.
> Commit ext4: allocate extended attribute value in vmalloc area
> (73c44f61dab180b5f2dee9f15397aba36a75a882) tries to allocate buffer
> using kvmalloc with improper flags that generates this warning.
> To fix backport an upstream commit mm: kvmalloc does not
> fallback to vmalloc for incompatible gfp flags
> (170f26afa0481c72af93aa61b7398b5663451651). This removes the WARN_ON and
> fallsback to kmalloc if correct flags are not passed.
> 
> 
> Michal Hocko (1):
>   mm: kvmalloc does not fallback to vmalloc for incompatible gfp flags
> 
>  mm/util.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> -- 
> 2.38.1
> 

Now queued up, thanks.

greg k-h
