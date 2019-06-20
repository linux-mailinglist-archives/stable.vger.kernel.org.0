Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE164D410
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFTQoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfFTQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 12:44:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82F5F2084E;
        Thu, 20 Jun 2019 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561049071;
        bh=dSIK2osCejKvn0CHWtgtArMW32dVmlU3qQNWmCQAIMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GoAnvkjVFRYAx/ToIGfciX5m/sfvriLeoeP/gT14LqQM8t53IJUeVqVj6a79i6pxF
         cPr7ikw5S+F2bHLff5zDXa3pu74ph66MRSSRSwWCM3RfWziu5fnMdwe62hOw+tRLyr
         P3aWytCK8jWPty4mS/D3p7eU9KzFZgmmURL7D0WU=
Date:   Thu, 20 Jun 2019 18:44:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        alexander.lochmann@tu-dortmund.de, viro@zeniv.linux.org.uk
Subject: Re: f69e749a4935 ("Abort file_remove_privs() for non-reg. files")
Message-ID: <20190620164428.GA8610@kroah.com>
References: <20190620163048.GA189243@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620163048.GA189243@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 09:30:49AM -0700, Zubin Mithra wrote:
> Hello,
> 
> Syzkaller has triggered a kernel WARNING when fuzzing a 4.14 kernel with the following stacktrace.
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x114/0x1cf lib/dump_stack.c:53
>  panic+0x1bb/0x3a0 kernel/panic.c:181
>  __warn.cold.9+0x149/0x186 kernel/panic.c:542
>  report_bug+0x1f7/0x272 lib/bug.c:186
>  fixup_bug arch/x86/kernel/traps.c:177 [inline]
>  do_error_trap+0x1c1/0x430 arch/x86/kernel/traps.c:295
>  do_invalid_op+0x20/0x30 arch/x86/kernel/traps.c:314
>  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:944
>  __remove_privs fs/inode.c:1805 [inline]
>  file_remove_privs+0x291/0x4c0 fs/inode.c:1827
>  __generic_file_write_iter+0x166/0x5b0 mm/filemap.c:3096
>  blkdev_write_iter+0x1f5/0x3b0 fs/block_dev.c:1905
>  call_write_iter include/linux/fs.h:1782 [inline]
>  new_sync_write fs/read_write.c:471 [inline]
>  __vfs_write+0x53f/0x7d0 fs/read_write.c:484
>  vfs_write+0x18c/0x500 fs/read_write.c:546
>  SYSC_write fs/read_write.c:593 [inline]
>  SyS_write+0xf4/0x230 fs/read_write.c:585
>  do_syscall_32_irqs_on arch/x86/entry/common.c:340 [inline]
>  do_fast_syscall_32+0x3c1/0xbf1 arch/x86/entry/common.c:403
>  entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139
> 
> 
> Could the following patch be applied to 5.0.y, 4.19.y, 4.14.y? The commit is present in 5.1.y.
> * f69e749a4935 ("Abort file_remove_privs() for non-reg. files")

5.0 is long end-of-life, but 4.19.y and 4.14.y is good.  What about
older kernels?  it seems to be applicable there too, right?

thanks,

greg k-h
