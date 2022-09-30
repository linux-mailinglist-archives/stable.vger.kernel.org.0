Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179A95F0336
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 05:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiI3DU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 23:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiI3DUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 23:20:40 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DACC491CF;
        Thu, 29 Sep 2022 20:20:14 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28U3JnjD002434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 23:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664507992; bh=kxeFPK+RvFEZgfBfdjxbsuOujsQLGwmMHUkdJndE2eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=gAoRElfCGB19SpXfp0y1D/9L8yrf5H732c6waH37ZuLrTob6sXgs56LpOIqkbojrr
         btw7HPg1WDT1xdjkC8PVh2Bf8ih8M85MI8FpXn9pJGKPoXA7ohDiROMovv9LN90vDk
         /90H/rGMe9H/r+O+sJIQsWFnP0FYzFKKhM4PKzcCLMXKYkVRbe/Tlsc/KQgRZt7XFg
         gRNky0NoU3Z/AtF+LBrQRzPucmd0YavXiZuZCg/LDEyzsY14VMN1PSBp8m2IKMA1p4
         mQnV9v+4jLe6aEVyA8q+iUr9y9zaqEyX20bq4KTX09XKWzy6vXi1dGjOBsKYQeaZMi
         CNrvTQi4LWTtg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 93FB215C34C3; Thu, 29 Sep 2022 23:19:47 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-ext4@vger.kernel.org, libaokun1@huawei.com
Cc:     "Theodore Ts'o" <tytso@mit.edu>, lczerner@redhat.com,
        chengzhihao1@huawei.com, enwlinux@gmail.com,
        linux-kernel@vger.kernel.org, ritesh.list@gmail.com,
        stable@vger.kernel.org, adilger.kernel@dilger.ca,
        yebin10@huawei.com, jack@suse.cz, yi.zhang@huawei.com,
        yukuai3@huawei.com
Subject: Re: [PATCH v2] ext4: fix use-after-free in ext4_ext_shift_extents
Date:   Thu, 29 Sep 2022 23:19:37 -0400
Message-Id: <166450797717.256913.12979997291945870141.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220922120434.1294789-1-libaokun1@huawei.com>
References: <20220922120434.1294789-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Sep 2022 20:04:34 +0800, Baokun Li wrote:
> If the starting position of our insert range happens to be in the hole
> between the two ext4_extent_idx, because the lblk of the ext4_extent in
> the previous ext4_extent_idx is always less than the start, which leads
> to the "extent" variable access across the boundary, the following UAF is
> triggered:
> ==================================================================
> BUG: KASAN: use-after-free in ext4_ext_shift_extents+0x257/0x790
> Read of size 4 at addr ffff88819807a008 by task fallocate/8010
> CPU: 3 PID: 8010 Comm: fallocate Tainted: G            E     5.10.0+ #492
> Call Trace:
>  dump_stack+0x7d/0xa3
>  print_address_description.constprop.0+0x1e/0x220
>  kasan_report.cold+0x67/0x7f
>  ext4_ext_shift_extents+0x257/0x790
>  ext4_insert_range+0x5b6/0x700
>  ext4_fallocate+0x39e/0x3d0
>  vfs_fallocate+0x26f/0x470
>  ksys_fallocate+0x3a/0x70
>  __x64_sys_fallocate+0x4f/0x60
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ==================================================================
> 
> [...]

Applied, thanks!

[1/1] ext4: fix use-after-free in ext4_ext_shift_extents
      (no commit info)

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
