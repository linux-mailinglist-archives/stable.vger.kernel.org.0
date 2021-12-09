Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02746EA28
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 15:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbhLIOmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 09:42:18 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41102 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S238747AbhLIOmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 09:42:18 -0500
X-UUID: 558ea62eb0ae44198d753f500b18983e-20211209
X-UUID: 558ea62eb0ae44198d753f500b18983e-20211209
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 747855209; Thu, 09 Dec 2021 22:38:41 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 9 Dec 2021 22:38:39 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 9 Dec 2021 22:38:39 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <luca.stefani.ge1@gmail.com>
CC:     <akpm@linux-foundation.org>, <anton@tuxera.com>,
        <clang-built-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-ntfs-dev@lists.sourceforge.net>,
        <michalechner92@googlemail.com>, <stable@vger.kernel.org>,
        <mark-pk.tsai@mediatek.com>, <yj.chiang@mediatek.com>
Subject: [PATCH v2] ntfs: Fix ntfs_test_inode and ntfs_init_locked_inode function type
Date:   Thu, 9 Dec 2021 22:38:39 +0800
Message-ID: <20211209143839.31021-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200718112513.533800-1-luca.stefani.ge1@gmail.com>
References: <20200718112513.533800-1-luca.stefani.ge1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Clang's Control Flow Integrity (CFI) is a security mechanism that can
> help prevent JOP chains, deployed extensively in downstream kernels
> used in Android.
> 
> It's deployment is hindered by mismatches in function signatures.  For
> this case, we make callbacks match their intended function signature,
> and cast parameters within them rather than casting the callback when
> passed as a parameter.
> 
> When running `mount -t ntfs ...` we observe the following trace:
> 
> Call trace:
> __cfi_check_fail+0x1c/0x24
> name_to_dev_t+0x0/0x404
> iget5_locked+0x594/0x5e8
> ntfs_fill_super+0xbfc/0x43ec
> mount_bdev+0x30c/0x3cc
> ntfs_mount+0x18/0x24
> mount_fs+0x1b0/0x380
> vfs_kern_mount+0x90/0x398
> do_mount+0x5d8/0x1a10
> SyS_mount+0x108/0x144
> el0_svc_naked+0x34/0x38
> 
> Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
> Tested-by: freak07 <michalechner92@googlemail.com>
> Acked-by: Anton Altaparmakov <anton@tuxera.com>
> ---
>  fs/ntfs/dir.c   |  2 +-
>  fs/ntfs/inode.c | 27 ++++++++++++++-------------
>  fs/ntfs/inode.h |  4 +---
>  fs/ntfs/mft.c   |  4 ++--
>  4 files changed, 18 insertions(+), 19 deletions(-)
> 

Hi,

I think stable tree should pick this change.

Below is the mainline commit.

(1146f7e2dc15 ntfs: fix ntfs_test_inode and ntfs_init_locked_inode function type)

5.4 stable have the same issue when CFI is enabled.
