Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DB06321C8
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiKUMUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKUMUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:20:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0F42C136
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE3DDB80EFC
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F7AC433C1;
        Mon, 21 Nov 2022 12:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669033227;
        bh=k+Yg3xWd9pgabHG5Pq5vVWYlmLMWlT6lh8nKkV9HLQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zEpb8sHDoT6d4V5TkynZEZihkeN7ihAleyP9KpgLS0SLmuRZhGwInpaliKTs1ZJDY
         Duytp6jz/3AI3pvZxUcFuGiVmoC1Q6mu1xDUkhNPAQiHjrglfxrLXAfVl60tGaU6Gt
         3Y9mqfhykSUiHdGiTyKZW85QqhbykRv7OwSHpyoQ=
Date:   Mon, 21 Nov 2022 13:19:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4.14] nilfs2: fix use-after-free bug of ns_writer on
 remount
Message-ID: <Y3tszyyAAClwJPOO@kroah.com>
References: <20221120155131.23814-1-konishi.ryusuke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221120155131.23814-1-konishi.ryusuke@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 12:51:31AM +0900, Ryusuke Konishi wrote:
> commit 8cccf05fe857a18ee26e20d11a8455a73ffd4efd upstream.
> 
> If a nilfs2 filesystem is downgraded to read-only due to metadata
> corruption on disk and is remounted read/write, or if emergency read-only
> remount is performed, detaching a log writer and synchronizing the
> filesystem can be done at the same time.
> 
> In these cases, use-after-free of the log writer (hereinafter
> nilfs->ns_writer) can happen as shown in the scenario below:
> 
>  Task1                               Task2
>  --------------------------------    ------------------------------
>  nilfs_construct_segment
>    nilfs_segctor_sync
>      init_wait
>      init_waitqueue_entry
>      add_wait_queue
>      schedule
>                                      nilfs_remount (R/W remount case)
> 				       nilfs_attach_log_writer
>                                          nilfs_detach_log_writer
>                                            nilfs_segctor_destroy
>                                              kfree
>      finish_wait
>        _raw_spin_lock_irqsave
>          __raw_spin_lock_irqsave
>            do_raw_spin_lock
>              debug_spin_lock_before  <-- use-after-free
> 
> While Task1 is sleeping, nilfs->ns_writer is freed by Task2.  After Task1
> waked up, Task1 accesses nilfs->ns_writer which is already freed.  This
> scenario diagram is based on the Shigeru Yoshida's post [1].
> 
> This patch fixes the issue by not detaching nilfs->ns_writer on remount so
> that this UAF race doesn't happen.  Along with this change, this patch
> also inserts a few necessary read-only checks with superblock instance
> where only the ns_writer pointer was used to check if the filesystem is
> read-only.
> 
> Link: https://syzkaller.appspot.com/bug?id=79a4c002e960419ca173d55e863bd09e8112df8b
> Link: https://lkml.kernel.org/r/20221103141759.1836312-1-syoshida@redhat.com [1]
> Link: https://lkml.kernel.org/r/20221104142959.28296-1-konishi.ryusuke@gmail.com
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Reported-by: syzbot+f816fa82f8783f7a02bb@syzkaller.appspotmail.com
> Reported-by: Shigeru Yoshida <syoshida@redhat.com>
> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> Please apply this patch to stable-4.14 instead of the patch that could
> not be applied to it last time.
> 
> A rejected hunk has been manually resolved without noticeable change,
> and testing against that stable tree was fine.
> 

Now queued up, thanks.

greg k-h
