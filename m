Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64084466D8
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 17:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhKEQUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 12:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhKEQUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 12:20:01 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145C3C061714
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 09:17:22 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id n23so8762829pgh.8
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 09:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=0LfTcsk/KjAZqftK5gWaiSVCTtjCJhhvMy6+I/8RvAU=;
        b=jw5YOtdHKGyvaV/orUsJdTSET1VGHpGFaTts1J0kp9u33IUhW2S8hKVCAPvxoIiQST
         hCynSgjYz19TeMLVY2vEBso5x+JpZd22Tj93WtJvopEfMiz+SW4PR0G0IYZKP82GJ/Z+
         dBz+NHOcxZD8TacLjKxn2pJ20UcoSvlWnxV2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0LfTcsk/KjAZqftK5gWaiSVCTtjCJhhvMy6+I/8RvAU=;
        b=QScUZNKJImKBL6ETjOE+Kf/+9P9rkgCgmLHS1Bauod/880NEvC8d/QWNPvBNN+Q0zW
         RDSAiIVDckkRsfHIgmXVR5x2k5B0QKznpDbUOLTiqRjz88E8KPK9WQtZx6qnPEdISHSv
         sx5SSGvseM69yAbJdCWvUt4uDp0WVAkYfIpVaC+cZ6uctSRR0GhnBsnZyBjIZdVBZjI8
         DX648bZKj916iIKBN/4VdgpPXhUmlizlmV5H5i3770Y5XZOcxRKxHtSLosvdYTyLoifi
         cFF0SFjFDk4QQMH+QSgCj8Ir8xeHoZTLzjM5ta4pG8zDEA4w9UhjfajekaZudAAAWOXA
         gXQA==
X-Gm-Message-State: AOAM533hWrRO7rFq97ZG+qjpPJnu8T1zG3t3o6JVk5iz3GXo6vrYoTOL
        XJLaysH1e4RR3GfOZsPbHZpMgMgJTjAtZw==
X-Google-Smtp-Source: ABdhPJzu2HtvR27roRsE8xnghnR5fb/3mL0PUhNeLQfVa7PYJoRG3kNnHO+4bS9Ds6dGoILhDTDsVA==
X-Received: by 2002:a63:be01:: with SMTP id l1mr45422697pgf.445.1636129041206;
        Fri, 05 Nov 2021 09:17:21 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:86ab:2ff9:3c8:903d])
        by smtp.googlemail.com with ESMTPSA id nh21sm6654492pjb.30.2021.11.05.09.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 09:17:20 -0700 (PDT)
Date:   Fri, 5 Nov 2021 09:17:10 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org, axboe@kernel.dk,
        hch@lst.de, ming.lei@redhat.com, osandov@fb.com
Subject: 3d75ca0adef4 ("block: introduce multi-page bvec helpers")
Message-ID: <YYVZBuDaWBKT3vOS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

A Syzkaller PoC causes a GPF with the following stacktrace in linux-4.14.y and linux-4.19.y.

BUG: KASAN: null-ptr-deref in get_page+0xf/0x65
Read of size 8 at addr 0000000000000008 by task poc2/3395

CPU: 0 PID: 3395 Comm: poc2 Not tainted 4.19.214-00936-g38ec06730e44 #59
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 dump_stack+0xe7/0x131
 kasan_report+0x22a/0x272
 get_page+0xf/0x65
 submit_page_section+0xf4/0x202
 do_blockdev_direct_IO+0xb90/0xfb9
 ? dio_set_defer_completion+0x57/0x57
 ? lock_is_held_type+0x78/0x86
 ? jbd2_journal_stop+0x6fa/0x742
 ? ext4_get_block_trans+0x188/0x188
 ? lock_downgrade+0x29a/0x29a
 ? __blockdev_direct_IO+0x52/0x93
 ? do_journal_get_write_access+0x7b/0x7b
 ext4_direct_IO+0x4eb/0x7ad
 ? ext4_get_block_trans+0x188/0x188
 generic_file_direct_write+0x132/0x1d8
 __generic_file_write_iter+0xa6/0x1c0
 ? generic_write_checks+0x173/0x19d
 ext4_file_write_iter+0x450/0x549
 ? ext4_unwritten_wait+0x153/0x153
 ? iter_file_splice_write+0x11a/0x4d7
 ? lock_acquire+0x1a7/0x1e7
 ? iter_file_splice_write+0x11a/0x4d7
 ? lock_acquire+0x1b7/0x1e7
 ? match_held_lock+0x2e/0x102
 ? __lock_is_held+0x2a/0x87
 do_iter_readv_writev+0x145/0x1b1
 ? file_start_write.isra.0+0x34/0x34
 ? avc_policy_seqno+0x1d/0x25
 ? selinux_file_permission+0xce/0x115
 do_iter_write+0xa6/0xe6
 iter_file_splice_write+0x337/0x4d7
 ? __do_compat_sys_vmsplice+0x16c/0x16c
 ? match_held_lock+0x2e/0x102
 ? lock_is_held_type+0x78/0x86
 __do_sys_splice+0x6cc/0x8f6
 ? ipipe_prep.part.0+0x99/0x99
 ? mark_held_locks+0x2d/0x84
 ? do_syscall_64+0x14/0x90
 do_syscall_64+0x74/0x90
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43f579

Could the following patch be applied to linux-4.19.y and linux-4.14.y?
linux-5.4.y has this commit.
	3d75ca0adef4 ("block: introduce multi-page bvec helpers")

Tests run:
* Syzkaller reproducer
* Chrome OS tryjobs


Thanks,
- Zubin

