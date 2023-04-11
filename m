Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BC56DD081
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDKDxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDKDxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E91BE8;
        Mon, 10 Apr 2023 20:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4602262103;
        Tue, 11 Apr 2023 03:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF66C433D2;
        Tue, 11 Apr 2023 03:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681185198;
        bh=VneM/8GV+SlOghqkLJDB+EPmgjM+OaU8GzefY4bkqOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mfhMjkonqMODs2Cp+/3AS8hxWUpg3g9lpO0zaU1R2z0r0E4J2Q9HeRV+Ce6w5f6Qp
         x0u1AWmPa6WLo317fBrQ9GPBAU06LswGMSaMnNmpPI0C/iJUSvrQjDMdMRucQgkqWt
         /zibjUB6F+1YsXQUkjmgBGT6ZbEQhhHE84Qo9L+I=
Date:   Mon, 10 Apr 2023 20:53:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <brauner@kernel.org>, <jack@suse.cz>, <tj@kernel.org>,
        <dennis@kernel.org>, <adilger.kernel@dilger.ca>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>, <houtao1@huawei.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] writeback, cgroup: fix null-ptr-deref write in
 bdi_split_work_to_wbs
Message-Id: <20230410205317.dcb186166b9603eeb876dfda@linux-foundation.org>
In-Reply-To: <20230410130826.1492525-1-libaokun1@huawei.com>
References: <20230410130826.1492525-1-libaokun1@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Apr 2023 21:08:26 +0800 Baokun Li <libaokun1@huawei.com> wrote:

> 
> ...
>
> To solve this problem, percpu_ref_exit() is called under RCU protection
> to avoid race between cgwb_release_workfn() and bdi_split_work_to_wbs().
> Moreover, replace wb_get() with wb_tryget() in bdi_split_work_to_wbs(),
> and skip the current wb if wb_tryget() fails because the wb has already
> been shutdown.
> 
> Fixes: b817525a4a80 ("writeback: bdi_writeback iteration must not skip dying ones")
> Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")

Two Fixes: is awkward.  The Fixes: serves a guide to which kernel
versions should be patched, but those two commits are six years apart.

So... how far back should this fix be backported?

>  fs/fs-writeback.c | 17 ++++++++++-------
>  mm/backing-dev.c  | 12 ++++++++++--

Jens, which tree do you think should carry this?


