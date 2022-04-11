Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD314FBF68
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347378AbiDKOof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 10:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiDKOof (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 10:44:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5BA30E
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FAEDB81642
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC042C385A4;
        Mon, 11 Apr 2022 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649688138;
        bh=X33M4aSP+1AYTJp820uVouTUaNHVVSXtmfkPWqUs2Os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gv1yrEuKOSAjPAlEv+Uh0HiG3RP1Oox7IJTkwESEdKlvXyS6f8LiBqtCgQ6/BzinE
         4MyprNM8yTVV6dV6Z6e0WzHEEGJhOf8b8JNMf3RPr73xQhFjEEVBus22bR6TRpj8V1
         nsq7pUnC9w6vAROuA+Kgpo5iMmQIX0xRlyiQqPGw=
Date:   Mon, 11 Apr 2022 16:42:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, tj@kernel.org, mkoutny@suse.com
Subject: Re: [PATCH 5.10 0/5] cgroup: backports for CVE-2021-4197
Message-ID: <YlQ+REbLLewnuCBO@kroah.com>
References: <20220407072135.32441-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220407072135.32441-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 10:21:30AM +0300, Ovidiu Panait wrote:
> CVE-2021-4197 patchset consists of:
> [1] 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
> [2] 0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
> [3] e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
> [4] b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
> [5] 613e040e4dc2 ("selftests: cgroup: Test open-time credential usage for migration checks")
> [6] bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")
> 
> Commits [2] and [3] are already preent in 5.10-stable, this patchset includes
> backports for the other commits.
> 
> Backport summary
> ----------------
> 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
> 	* Refactoring commit da70862efe006 ("cgroup: cgroup.{procs,threads}
> 	  factor out common parts") is not present in kernel versions < 5.12,
> 	  so the original changes to __cgroup_procs_write() had to be applied
> 	  in both cgroup_threads_write() and cgroup_procs_write() functions.
> 
> c2e46f6b3e35 ("selftests/cgroup: Fix build on older distros")
> 	* This extra commit was added to fix the following selftest build
> 	  failure, applies cleanly:
> 	  ...
> 	  cgroup_util.c: In function ‘clone_into_cgroup’:
> 	  group_util.c:343:4: error: ‘struct clone_args’ has no member named ‘cgroup’
> 	  343 |   .cgroup = cgroup_fd,
> 	  |    ^~~~~~
> 
> All other selftest changes are clean cherry-picks.
> 
> Testing
> -------
> The newly introduced selftests (test_cgcore_lesser_euid_open() and
> test_cgcore_lesser_ns_open()) pass with this series applied:
> 
> root@intel-x86-64:~# ./test_core
> ok 1 test_cgcore_internal_process_constraint
> ok 2 test_cgcore_top_down_constraint_enable
> ok 3 test_cgcore_top_down_constraint_disable
> ok 4 test_cgcore_no_internal_process_constraint_os
> ok 5 test_cgcore_parent_becomes_threaded
> ok 6 test_cgcore_invalid_domain
> ok 7 test_cgcore_populated
> ok 8 test_cgcore_proc_migration
> ok 9 test_cgcore_thread_migration
> ok 10 test_cgcore_destroy
> ok 11 test_cgcore_lesser_euid_open
> ok 12 test_cgcore_lesser_ns_open
> 
> 
> Sachin Sant (1):
>   selftests/cgroup: Fix build on older distros
> 
> Tejun Heo (4):
>   cgroup: Use open-time credentials for process migraton perm checks
>   selftests: cgroup: Make cg_create() use 0755 for permission instead of
>     0644
>   selftests: cgroup: Test open-time credential usage for migration
>     checks
>   selftests: cgroup: Test open-time cgroup namespace usage for migration
>     checks
> 
>  kernel/cgroup/cgroup-v1.c                    |   7 +-
>  kernel/cgroup/cgroup.c                       |  17 +-
>  tools/testing/selftests/cgroup/cgroup_util.c |   6 +-
>  tools/testing/selftests/cgroup/test_core.c   | 165 +++++++++++++++++++
>  4 files changed, 188 insertions(+), 7 deletions(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks.

greg k-h
