Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426C3447AA9
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 08:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhKHHEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 02:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237200AbhKHHEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 02:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0354610A2;
        Mon,  8 Nov 2021 07:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636354897;
        bh=TXTo7ORbyrMVAEWmF+pWkUbVslRxhj2LjrghYVgibig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rqi4ohzE5aRveml9hm5ef/V5p7azm4jf0+u3oWGuRaOdlVj5wPyZ3jYFjr/LEXuSZ
         LD1XNlpy4Io+vuu727QADYCo0TUYAmm5SKEwf1vv8sPBj+qNCBr3FP7hgblezmjSS7
         uTqMxLAa2hm/ZNqe2C0y6DvFuTBoZwXVXACvr8js=
Date:   Mon, 8 Nov 2021 08:01:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, axboe@kernel.dk,
        hch@lst.de, ming.lei@redhat.com, osandov@fb.com
Subject: Re: 3d75ca0adef4 ("block: introduce multi-page bvec helpers")
Message-ID: <YYjLT4wUIbK5T1ez@kroah.com>
References: <YYVZBuDaWBKT3vOS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYVZBuDaWBKT3vOS@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 05, 2021 at 09:17:10AM -0700, Zubin Mithra wrote:
> Hello,
> 
> A Syzkaller PoC causes a GPF with the following stacktrace in linux-4.14.y and linux-4.19.y.
> 
> BUG: KASAN: null-ptr-deref in get_page+0xf/0x65
> Read of size 8 at addr 0000000000000008 by task poc2/3395
> 
> CPU: 0 PID: 3395 Comm: poc2 Not tainted 4.19.214-00936-g38ec06730e44 #59
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  dump_stack+0xe7/0x131
>  kasan_report+0x22a/0x272
>  get_page+0xf/0x65
>  submit_page_section+0xf4/0x202
>  do_blockdev_direct_IO+0xb90/0xfb9
>  ? dio_set_defer_completion+0x57/0x57
>  ? lock_is_held_type+0x78/0x86
>  ? jbd2_journal_stop+0x6fa/0x742
>  ? ext4_get_block_trans+0x188/0x188
>  ? lock_downgrade+0x29a/0x29a
>  ? __blockdev_direct_IO+0x52/0x93
>  ? do_journal_get_write_access+0x7b/0x7b
>  ext4_direct_IO+0x4eb/0x7ad
>  ? ext4_get_block_trans+0x188/0x188
>  generic_file_direct_write+0x132/0x1d8
>  __generic_file_write_iter+0xa6/0x1c0
>  ? generic_write_checks+0x173/0x19d
>  ext4_file_write_iter+0x450/0x549
>  ? ext4_unwritten_wait+0x153/0x153
>  ? iter_file_splice_write+0x11a/0x4d7
>  ? lock_acquire+0x1a7/0x1e7
>  ? iter_file_splice_write+0x11a/0x4d7
>  ? lock_acquire+0x1b7/0x1e7
>  ? match_held_lock+0x2e/0x102
>  ? __lock_is_held+0x2a/0x87
>  do_iter_readv_writev+0x145/0x1b1
>  ? file_start_write.isra.0+0x34/0x34
>  ? avc_policy_seqno+0x1d/0x25
>  ? selinux_file_permission+0xce/0x115
>  do_iter_write+0xa6/0xe6
>  iter_file_splice_write+0x337/0x4d7
>  ? __do_compat_sys_vmsplice+0x16c/0x16c
>  ? match_held_lock+0x2e/0x102
>  ? lock_is_held_type+0x78/0x86
>  __do_sys_splice+0x6cc/0x8f6
>  ? ipipe_prep.part.0+0x99/0x99
>  ? mark_held_locks+0x2d/0x84
>  ? do_syscall_64+0x14/0x90
>  do_syscall_64+0x74/0x90
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x43f579
> 
> Could the following patch be applied to linux-4.19.y and linux-4.14.y?
> linux-5.4.y has this commit.
> 	3d75ca0adef4 ("block: introduce multi-page bvec helpers")
> 
> Tests run:
> * Syzkaller reproducer
> * Chrome OS tryjobs

Now queued up, thanks.

greg k-h
