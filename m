Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF03284FA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhCAQq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234900AbhCAQin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:38:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9AF664F84;
        Mon,  1 Mar 2021 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616080;
        bh=OZF7VyPZXF1k+HyKccLEAUYuA12AE4l7p/jHgBmKTpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WR9V/MqIzM7zb9re3xMrunWimDpBKsG3RN4VIgXQfS4BIHPrGU90pZD8YBmUI4hiJ
         jBdGmw/q5yL1YwmWe4lYvtezVYr/BWf61G8Mz39JfDUsGDLPMsLG2pfHfbplcwd1Mf
         /7L5nfWfTLyW5CWnwmCkOVum8XpOMng++oKMi7vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+c584225dabdea2f71969@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 003/176] ntfs: check for valid standard information attribute
Date:   Mon,  1 Mar 2021 17:11:16 +0100
Message-Id: <20210301161021.115518272@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
@@ -661,6 +661,12 @@ static int ntfs_read_locked_inode(struct
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
 


