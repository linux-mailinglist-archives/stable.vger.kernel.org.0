Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0954FBF53
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 16:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiDKOic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 10:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347345AbiDKOib (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 10:38:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55312BF4
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A1C6147E
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CB0C385A3;
        Mon, 11 Apr 2022 14:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649687775;
        bh=zwHJc8n2BZEsXOcfcwrS7mbergCueD0Mug0QYNnaU5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F15JqDHzcBtrKYfMdqz+m/tlgYTn6345NHLPps7OVh1aM528YRD9v/nbvggcx6DqK
         0ZxZs1obb9EoikW/3TLRMTbZGs4fE1Ejbb0oz/U5VI1T5+2ChqK6VIVrEBS+fhTjil
         hfPFZyfFFu8Xix12EqAPuyCB4D+ebYPGWwQMtQGs=
Date:   Mon, 11 Apr 2022 16:36:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15 0/3] cgroup: backport selftests for CVE-2021-4197
Message-ID: <YlQ83YwagyklVJYs@kroah.com>
References: <20220407071901.32350-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407071901.32350-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 10:18:58AM +0300, Ovidiu Panait wrote:
> CVE-2021-4197 patchset consists of:
> [1] 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
> [2] 0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
> [3] e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
> [4] b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
> [5] 613e040e4dc2 ("selftests: cgroup: Test open-time credential usage for migration checks")
> [6] bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")
> 
> Commits [1], [2] and [3] are already present in 5.15-stable, this patchset
> includes backports for the selftests. All patches are clean cherry-picks.
> 
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
> Tejun Heo (3):
>   selftests: cgroup: Make cg_create() use 0755 for permission instead of
>     0644
>   selftests: cgroup: Test open-time credential usage for migration
>     checks
>   selftests: cgroup: Test open-time cgroup namespace usage for migration
>     checks
> 
>  tools/testing/selftests/cgroup/cgroup_util.c |   2 +-
>  tools/testing/selftests/cgroup/test_core.c   | 165 +++++++++++++++++++
>  2 files changed, 166 insertions(+), 1 deletion(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks!

greg k-h
