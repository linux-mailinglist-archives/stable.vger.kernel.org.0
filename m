Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DD1324D99
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhBYKG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhBYKBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:01:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31B664EF5;
        Thu, 25 Feb 2021 09:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246975;
        bh=srkatT/Yg2o8OLBz5KTiNuiDHyWK/S92iCI2IuwqaHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TET8vrqyKeNNWK+lfkmQQgn+3X5VsWClUb3q0q3s7ChCvKqhAgRui5AZrwv4/khMb
         XnTlzr+1klNidW79ZgRxJFcp+Fm4ZfusKzAu9uBD9Xov8q4C4FuTeIfN9+3HLtQ2mh
         uJwlIjCoNm28iCyqu3x/bZ1dHU6ixS3A5lVpT/As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+c584225dabdea2f71969@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 05/17] ntfs: check for valid standard information attribute
Date:   Thu, 25 Feb 2021 10:53:50 +0100
Message-Id: <20210225092515.270200484@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
References: <20210225092515.001992375@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit 4dfe6bd94959222e18d512bdf15f6bf9edb9c27c upstream.

Mounting a corrupted filesystem with NTFS resulted in a kernel crash.

We should check for valid STANDARD_INFORMATION attribute offset and length
before trying to access it

Link: https://lkml.kernel.org/r/20210217155930.1506815-1-rkovhaev@gmail.com
Link: https://syzkaller.appspot.com/bug?extid=c584225dabdea2f71969
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reported-by: syzbot+c584225dabdea2f71969@syzkaller.appspotmail.com
Tested-by: syzbot+c584225dabdea2f71969@syzkaller.appspotmail.com
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -628,6 +628,12 @@ static int ntfs_read_locked_inode(struct
 	}
 	a = ctx->attr;
 	/* Get the standard information attribute value. */
+	if ((u8 *)a + le16_to_cpu(a->data.resident.value_offset)
+			+ le32_to_cpu(a->data.resident.value_length) >
+			(u8 *)ctx->mrec + vol->mft_record_size) {
+		ntfs_error(vi->i_sb, "Corrupt standard information attribute in inode.");
+		goto unm_err_out;
+	}
 	si = (STANDARD_INFORMATION*)((u8*)a +
 			le16_to_cpu(a->data.resident.value_offset));
 


