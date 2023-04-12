Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4D6DFC20
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 19:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjDLRB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 13:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjDLRBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 13:01:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C10A5F7;
        Wed, 12 Apr 2023 10:00:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id m18so11991180plx.5;
        Wed, 12 Apr 2023 10:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681318855; x=1683910855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOUB+QPUYu+JnmuWrA27H2YSYy0s0VbYHTMePFeWbQs=;
        b=Zd8jcPFYrRAnuE3xa2zuGzGmfFa1cNZ/9ucjgMq/rOlGf8iXR+Lh5ZXKDI4ZgoiSGA
         Ulplo4L0Zh4NYsFUvW0CmFe1OQfpLB1DGxsMkuMD25MwKLqmGpWA66dtmReszvpKbeeO
         Gj39ThLSDLFONXQwDdX9Ehr8W2vE+5RAGWS42fNokfqMZwpX6qpLKydEu5dQN/gFsxSl
         eFtpP20+uLzLzw7cfuRHUwWBeg0WXfwt+5R4iX/5FyGJpBiMejLeuJvC8fYVLexDnV2w
         LQNxJr+26xxV59Uc5c/9PgUV8fDP3CnrIus2S92NFPckggb+wBukNFq2je5k6SzjgFjI
         SOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318855; x=1683910855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dOUB+QPUYu+JnmuWrA27H2YSYy0s0VbYHTMePFeWbQs=;
        b=fpUIlBD+iORVFIrwJ2xWHRoZdOPsC2r69EO2zhtqqOAuf8w4ANS+s4dTyAaGJMUMvm
         7VHPazYLWuVx7JhAWGsCI7miuqrwVv3b5Kxg666DcfFjBobEDSSMz54kMHzZ/8eKY/wx
         1xBiQH71ttZArCpcAl/+w+VMuMp2gsZTKaS7J8nZ/q37hqc4/PpDd5UzexK2cpmG8YOK
         5Ghl7VvxOT4oHGdnfqFI8GvKv5Q3/sQO0lIC0ir2nqau6/UeM+Fx6tWjuM7azy+m85q8
         zX2YITNqvN+RpdWVR9KjGpqZf76LiGqczgTB9DWlonTD2Auyy9Kl/7CdozCfF5di83XD
         HblA==
X-Gm-Message-State: AAQBX9f3/rLvuAPQOpu5JcL4xeHQNjCC87SURZPQnaluzUdnQRyJrbkY
        24TlP/rNXQG5J7nH67kys4o=
X-Google-Smtp-Source: AKy350ZLLNlPoHdUDGm3k13i3kAASt397OAt7a6YgZknLYZRZdo++hAJOX+USd4HYFs4ze8a9LLUlw==
X-Received: by 2002:a17:902:f551:b0:1a6:6c58:d36e with SMTP id h17-20020a170902f55100b001a66c58d36emr4298484plf.66.1681318854805;
        Wed, 12 Apr 2023 10:00:54 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id x17-20020a1709027c1100b001a51402dea1sm9930229pll.20.2023.04.12.10.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 10:00:54 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 12 Apr 2023 07:00:52 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, jack@suse.cz, dennis@kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, houtao1@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] writeback, cgroup: fix null-ptr-deref write in
 bdi_split_work_to_wbs
Message-ID: <ZDbjxJcGysw6EEhg@slm.duckdns.org>
References: <20230410130826.1492525-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410130826.1492525-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 10, 2023 at 09:08:26PM +0800, Baokun Li wrote:
> KASAN report null-ptr-deref:
> ==================================================================
> BUG: KASAN: null-ptr-deref in bdi_split_work_to_wbs+0x5c5/0x7b0
> Write of size 8 at addr 0000000000000000 by task sync/943
> CPU: 5 PID: 943 Comm: sync Tainted: 6.3.0-rc5-next-20230406-dirty #461
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x7f/0xc0
>  print_report+0x2ba/0x340
>  kasan_report+0xc4/0x120
>  kasan_check_range+0x1b7/0x2e0
>  __kasan_check_write+0x24/0x40
>  bdi_split_work_to_wbs+0x5c5/0x7b0
>  sync_inodes_sb+0x195/0x630
>  sync_inodes_one_sb+0x3a/0x50
>  iterate_supers+0x106/0x1b0
>  ksys_sync+0x98/0x160
> [...]
> ==================================================================
> 
> The race that causes the above issue is as follows:
> 
>            cpu1                     cpu2
> -------------------------|-------------------------
> inode_switch_wbs
>  INIT_WORK(&isw->work, inode_switch_wbs_work_fn)
>  queue_rcu_work(isw_wq, &isw->work)
>  // queue_work async
>   inode_switch_wbs_work_fn
>    wb_put_many(old_wb, nr_switched)
>     percpu_ref_put_many
>      ref->data->release(ref)
>      cgwb_release
>       queue_work(cgwb_release_wq, &wb->release_work)
>       // queue_work async
>        &wb->release_work
>        cgwb_release_workfn
>                             ksys_sync
>                              iterate_supers
>                               sync_inodes_one_sb
>                                sync_inodes_sb
>                                 bdi_split_work_to_wbs
>                                  kmalloc(sizeof(*work), GFP_ATOMIC)
>                                  // alloc memory failed
>         percpu_ref_exit
>          ref->data = NULL
>          kfree(data)
>                                  wb_get(wb)
>                                   percpu_ref_get(&wb->refcnt)
>                                    percpu_ref_get_many(ref, 1)
>                                     atomic_long_add(nr, &ref->data->count)
>                                      atomic64_add(i, v)
>                                      // trigger null-ptr-deref
> 
> bdi_split_work_to_wbs() traverses &bdi->wb_list to split work into all wbs.
> If the allocation of new work fails, the on-stack fallback will be used and
> the reference count of the current wb is increased afterwards. If cgroup
> writeback membership switches occur before getting the reference count and
> the current wb is released as old_wd, then calling wb_get() or wb_put()
> will trigger the null pointer dereference above.
> 
> This issue was introduced in v4.3-rc7 (see fix tag1). Both sync_inodes_sb()
> and __writeback_inodes_sb_nr() calls to bdi_split_work_to_wbs() can trigger
> this issue. For scenarios called via sync_inodes_sb(), originally commit
> 7fc5854f8c6e ("writeback: synchronize sync(2) against cgroup writeback
> membership switches") reduced the possibility of the issue by adding
> wb_switch_rwsem, but in v5.14-rc1 (see fix tag2) removed the
> "inode_io_list_del_locked(inode, old_wb)" from inode_switch_wbs_work_fn()
> so that wb->state contains WB_has_dirty_io, thus old_wb is not skipped
> when traversing wbs in bdi_split_work_to_wbs(), and the issue becomes
> easily reproducible again.
> 
> To solve this problem, percpu_ref_exit() is called under RCU protection
> to avoid race between cgwb_release_workfn() and bdi_split_work_to_wbs().
> Moreover, replace wb_get() with wb_tryget() in bdi_split_work_to_wbs(),
> and skip the current wb if wb_tryget() fails because the wb has already
> been shutdown.
> 
> Fixes: b817525a4a80 ("writeback: bdi_writeback iteration must not skip dying ones")
> Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
