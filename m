Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2379C50E396
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbiDYOvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 10:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242408AbiDYOvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 10:51:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE73DCF;
        Mon, 25 Apr 2022 07:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CBB8B8180B;
        Mon, 25 Apr 2022 14:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F6C385A7;
        Mon, 25 Apr 2022 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650898083;
        bh=ww5pXTnymTyko+JhDt/z+sYzyuvKFpPMDqKA6sywXRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oI3h28Wc5sKb8BlpRXgCiExH+YOd9S2re+XAD+p7/QMsMZRNn+xCfQ/hk8uQOVsag
         OY8/yPDJYe9ie7+n4BBybRg0Ro+JKXuNmSZefFKDzhKYSBqeGaBZw1agmrcKGk11cs
         xrLGy4K8XkDS988aeCd+l0ZaFJwzRgDTP3VyNucU=
Date:   Mon, 25 Apr 2022 16:48:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shile Zhang <shile.zhang@linux.alibaba.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/cirrus: fix a NULL vs IS_ERR() checks
Message-ID: <Yma0oHqbznOilrCS@kroah.com>
References: <20220425141043.214024-1-shile.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425141043.214024-1-shile.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 10:10:43PM +0800, Shile Zhang wrote:
> The function drm_gem_shmem_vmap can returns error pointers as well,
> which could cause following kernel crash:
> 
> BUG: unable to handle page fault for address: fffffffffffffffc
> PGD 1426a12067 P4D 1426a12067 PUD 1426a14067 PMD 0
> Oops: 0000 [#1] SMP NOPTI
> CPU: 12 PID: 3598532 Comm: stress-ng Kdump: loaded Not tainted 5.10.50.x86_64 #1
> ...
> RIP: 0010:memcpy_toio+0x23/0x50
> Code: 00 00 00 00 0f 1f 00 0f 1f 44 00 00 48 85 d2 74 28 40 f6 c7 01 75 2b 48 83 fa 01 76 06 40 f6 c7 02 75 17 48 89 d1 48 c1 e9 02 <f3> a5 f6 c2 02 74 02 66 a5 f6 c2 01 74 01 a4 c3 66 a5 48 83 ea 02
> RSP: 0018:ffffafbf8a203c68 EFLAGS: 00010216
> RAX: 0000000000000000 RBX: fffffffffffffffc RCX: 0000000000000200
> RDX: 0000000000000800 RSI: fffffffffffffffc RDI: ffffafbf82000000
> RBP: ffffafbf82000000 R08: 0000000000000002 R09: 0000000000000000
> R10: 00000000000002b5 R11: 0000000000000000 R12: 0000000000000800
> R13: ffff8a6801099300 R14: 0000000000000001 R15: 0000000000000300
> FS:  00007f4a6bc5f740(0000) GS:ffff8a8641900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 00000016d3874001 CR4: 00000000003606e0
> Call Trace:
>  drm_fb_memcpy_dstclip+0x5e/0x80 [drm_kms_helper]
>  cirrus_fb_blit_rect.isra.0+0xb7/0xe0 [cirrus]
>  cirrus_pipe_update+0x9f/0xa8 [cirrus]
>  drm_atomic_helper_commit_planes+0xb8/0x220 [drm_kms_helper]
>  drm_atomic_helper_commit_tail+0x42/0x80 [drm_kms_helper]
>  commit_tail+0xce/0x130 [drm_kms_helper]
>  drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
>  drm_client_modeset_commit_atomic+0x1c4/0x200 [drm]
>  drm_client_modeset_commit_locked+0x53/0x80 [drm]
>  drm_client_modeset_commit+0x24/0x40 [drm]
>  drm_fbdev_client_restore+0x48/0x85 [drm_kms_helper]
>  drm_client_dev_restore+0x64/0xb0 [drm]
>  drm_release+0xf2/0x110 [drm]
>  __fput+0x96/0x240
>  task_work_run+0x5c/0x90
>  exit_to_user_mode_loop+0xce/0xd0
>  exit_to_user_mode_prepare+0x6a/0x70
>  syscall_exit_to_user_mode+0x12/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f4a6bd82c2b
> 
> Fixes: ab3e023b1b4c9 ("drm/cirrus: rewrite and modernize driver.")
> 
> Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>

No blank line between those please.

And you need to really really really document why this can not use a
commit that is currently upstream.  And what commit upstream did solve
this and how.  Otherwise we can not take this change, sorry.

greg k-h
