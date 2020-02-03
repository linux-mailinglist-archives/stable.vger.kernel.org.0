Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF5150488
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 11:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBCKsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 05:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgBCKsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 05:48:01 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF3B20661;
        Mon,  3 Feb 2020 10:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580726879;
        bh=p+KVuxPSlhGE7b4/aoscDI5Hl5aESLYvHXS0z6rEn5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfqkqbp1NKkJsvGSA0ReyGq5vDlV0NffnOcd84Q4ZjcdETFE9Fr19ccD8zwsFM1jZ
         RolrSw7iqErjttn2RxhrQ55Y13TFnOaRvPNT5PTyBNKfXyGj12yn8g+LJJoFpx4HoU
         SWHC/zlfyGVaCQfcPjpM4OecS7h8K2Bk2PdiKTqw=
Date:   Mon, 3 Feb 2020 10:47:57 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: Re: [PATCH v4.19.y] ext4: validate the debug_want_extra_isize mount
 option at parse time
Message-ID: <20200203104757.GA3130828@kroah.com>
References: <20200201050601.148009-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201050601.148009-1-zsm@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 09:06:01PM -0800, Zubin Mithra wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> commit 9803387c55f7d2ce69aa64340c5fdc6b3027dbc8 upstream.
> 
> Instead of setting s_want_extra_size and then making sure that it is a
> valid value afterwards, validate the field before we set it.  This
> avoids races and other problems when remounting the file system.
> 
> Link: https://lore.kernel.org/r/20191215063020.GA11512@mit.edu
> Cc: stable@kernel.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reported-and-tested-by: syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> Notes:
> * Syzkaller triggered a UAF on 4.19 kernels with the following
> stacktrace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xc8/0x129 lib/dump_stack.c:113
>  print_address_description+0x67/0x22a mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report mm/kasan/report.c:412 [inline]
>  kasan_report+0x251/0x28f mm/kasan/report.c:396
>  ext4_xattr_set_entry+0x45e/0x2222 fs/ext4/xattr.c:1604
>  ext4_xattr_ibody_set+0x7d/0x226 fs/ext4/xattr.c:2240
>  ext4_xattr_set_handle+0x553/0xa92 fs/ext4/xattr.c:2396
>  ext4_xattr_set+0x16a/0x200 fs/ext4/xattr.c:2508
>  __vfs_setxattr+0xfc/0x13d fs/xattr.c:149
>  __vfs_setxattr_noperm+0xf5/0x19c fs/xattr.c:180
>  vfs_setxattr+0x9c/0xca fs/xattr.c:223
>  setxattr+0x20e/0x275 fs/xattr.c:450
>  path_setxattr+0xca/0x144 fs/xattr.c:469
>  __do_sys_lsetxattr fs/xattr.c:491 [inline]
>  __se_sys_lsetxattr fs/xattr.c:487 [inline]
>  __x64_sys_lsetxattr+0xd7/0xe1 fs/xattr.c:487
>  do_syscall_64+0xfe/0x137 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> * This commit is present in linux-5.4.y. A backport for 4.14.y has been
> sent separately.

Many thanks for this and the 4.14.y backport, now both applied.

greg k-h
