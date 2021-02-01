Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F20F30A0CA
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 05:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhBAEOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 23:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhBAEO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 23:14:29 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8A7C061573;
        Sun, 31 Jan 2021 20:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=81bL12rgmL/gfPUkYmcpbR2T6tNxPJztxmrbZMXc6cM=; b=QZ597OnvTApNSYkoL520kMSIbL
        aQYimlOT0yZGd9XFSIMhE6xCywp/7nlbSPe09UOMrhlYq0Qn8bM4V2zGoHB7LnQqzIlJJ6Lmryi1q
        fS62iMU1ycA6lT46hG21cL+m13me0p6cxZCOHTm8SkiOssNvqcdqQ72+5iKD8QeupWC/I8UtEMQp+
        hJSV0zW0cmKNvSOTyAwk+7MHjL2kTekKRGLI39j5J7Hj6An6g4LZ8hhmb5vHNtkAi18/BcmwbQRUy
        Bb4Kxhv1SoLyovjc0GIOUy+lHN1xGTPSuSzLwb17ZTF83fkF9i7Dsrr5nnuMVR2qYIvUvLxkDMzRT
        eo0pLfLQ==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l6Qal-0000CI-FI; Mon, 01 Feb 2021 04:13:35 +0000
Subject: Re: [PATCH v2] exfat: fix shift-out-of-bounds in exfat_fill_super()
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        linux-fsdevel@vger.kernel.org
Cc:     sj1557.seo@samsung.com, stable@vger.kernel.org
References: <CGME20210201025358epcas1p46c6943424d296e8ba46b361d637d0068@epcas1p4.samsung.com>
 <20210201024620.2178-1-namjae.jeon@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <554abcaf-e92c-4f39-5c31-c07db9332f4d@infradead.org>
Date:   Sun, 31 Jan 2021 20:13:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210201024620.2178-1-namjae.jeon@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/21 6:46 PM, Namjae Jeon wrote:
> syzbot reported a warning which could cause shift-out-of-bounds issue.
> 
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x183/0x22e lib/dump_stack.c:120
>  ubsan_epilogue lib/ubsan.c:148 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
>  exfat_read_boot_sector fs/exfat/super.c:471 [inline]
>  __exfat_fill_super fs/exfat/super.c:556 [inline]
>  exfat_fill_super+0x2acb/0x2d00 fs/exfat/super.c:624
>  get_tree_bdev+0x406/0x630 fs/super.c:1291
>  vfs_get_tree+0x86/0x270 fs/super.c:1496
>  do_new_mount fs/namespace.c:2881 [inline]
>  path_mount+0x1937/0x2c50 fs/namespace.c:3211
>  do_mount fs/namespace.c:3224 [inline]
>  __do_sys_mount fs/namespace.c:3432 [inline]
>  __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3409
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> exfat specification describe sect_per_clus_bits field of boot sector
> could be at most 25 - sect_size_bits and at least 0. And sect_size_bits
> can also affect this calculation, It also needs validation.
> This patch add validation for sect_per_clus_bits and sect_size_bits
> field of boot sector.
> 
> Fixes: 719c1e182916 ("exfat: add super block operations")
> Cc: stable@vger.kernel.org # v5.9+
> Reported-by: syzbot+da4fe66aaadd3c2e2d1c@syzkaller.appspotmail.com
> Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>

Tested-by: Randy Dunlap <rdunlap@infradead.org> # for v2


> ---
> v2:
>  - change at most sect_per_clus_bits from 16 to 25 - sect_size_bits.
> 
>  fs/exfat/exfat_raw.h |  4 ++++
>  fs/exfat/super.c     | 31 ++++++++++++++++++++++++++-----
>  2 files changed, 30 insertions(+), 5 deletions(-)

thanks.
-- 
~Randy

