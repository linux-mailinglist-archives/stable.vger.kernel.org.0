Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6A83CD869
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242311AbhGSOWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242369AbhGSOU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E706113E;
        Mon, 19 Jul 2021 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706892;
        bh=nJ1grWDtmDKfyzxuAG3JLQEzaYyWCK/Z7JuC2PlMmrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqduJJrcuk+j6gA+y1iyKKrSdk3Ko9PicSUqmGSpahSPazS9qrqB+3MJ/vc2+jE/r
         lC4jEoHX+JNxt/ukuX/GjlTV59RFCgCcsiD1fhI/E3su6UQEp3AEw3A6rEMSnL5LcE
         b3rQEak7FoEbMQiu04gsnDfy+haxAxyLUKz/nIdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        syzbot+0a89a7b56db04c21a656@syzkaller.appspotmail.com
Subject: [PATCH 4.4 140/188] jfs: fix GPF in diFree
Date:   Mon, 19 Jul 2021 16:52:04 +0200
Message-Id: <20210719144941.074965191@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 9d574f985fe33efd6911f4d752de6f485a1ea732 upstream.

Avoid passing inode with
JFS_SBI(inode->i_sb)->ipimap == NULL to
diFree()[1]. GFP will appear:

	struct inode *ipimap = JFS_SBI(ip->i_sb)->ipimap;
	struct inomap *imap = JFS_IP(ipimap)->i_imap;

JFS_IP() will return invalid pointer when ipimap == NULL

Call Trace:
 diFree+0x13d/0x2dc0 fs/jfs/jfs_imap.c:853 [1]
 jfs_evict_inode+0x2c9/0x370 fs/jfs/inode.c:154
 evict+0x2ed/0x750 fs/inode.c:578
 iput_final fs/inode.c:1654 [inline]
 iput.part.0+0x3fe/0x820 fs/inode.c:1680
 iput+0x58/0x70 fs/inode.c:1670

Reported-and-tested-by: syzbot+0a89a7b56db04c21a656@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -160,7 +160,8 @@ void jfs_evict_inode(struct inode *inode
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			diFree(inode);
+			if (JFS_SBI(inode->i_sb)->ipimap)
+				diFree(inode);
 
 			/*
 			 * Free the inode from the quota allocation.


