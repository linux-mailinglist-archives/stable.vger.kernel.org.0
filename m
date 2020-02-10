Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0576D15751E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgBJMiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbgBJMip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:45 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B6920733;
        Mon, 10 Feb 2020 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338325;
        bh=mzdjs+2HjVphOcK4CSN3hLYnd9zBpyrzM4m11ddEtJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz1Uu74Q7x/Jo6EwuXvjeFaNWT1usFO8omldeFofphXNvqaoTSzFycmulj5EoQloy
         j7YqZvoaK1w14lpUXpIiVMfkXPlWPR+0AE9WawBzkWkKhnSjupv1y5fS63u9oz1lC+
         zvwUG+8B88z1tZwSuYHNkIJ86XYN2hfPVzb9zl6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 260/309] ubifs: Fix memory leak from c->sup_node
Date:   Mon, 10 Feb 2020 04:33:36 -0800
Message-Id: <20200210122431.609894741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

commit ff90bdfb206e49c8b418811efbdd0c77380fa8c2 upstream.

The c->sup_node is allocated in function ubifs_read_sb_node but
is not freed. This will cause memory leak as below:

unreferenced object 0xbc9ce000 (size 4096):
  comm "mount", pid 500, jiffies 4294952946 (age 315.820s)
  hex dump (first 32 bytes):
    31 18 10 06 06 7b f1 11 02 00 00 00 00 00 00 00  1....{..........
    00 10 00 00 06 00 00 00 00 00 00 00 08 00 00 00  ................
  backtrace:
    [<d1c503cd>] ubifs_read_superblock+0x48/0xebc
    [<a20e14bd>] ubifs_mount+0x974/0x1420
    [<8589ecc3>] legacy_get_tree+0x2c/0x50
    [<5f1fb889>] vfs_get_tree+0x28/0xfc
    [<bbfc7939>] do_mount+0x4f8/0x748
    [<4151f538>] ksys_mount+0x78/0xa0
    [<d59910a9>] ret_fast_syscall+0x0/0x54
    [<1cc40005>] 0x7ea02790

Free it in ubifs_umount and in the error path of mount_ubifs.

Fixes: fd6150051bec ("ubifs: Store read superblock node")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1599,6 +1599,7 @@ out_free:
 	vfree(c->ileb_buf);
 	vfree(c->sbuf);
 	kfree(c->bottom_up_buf);
+	kfree(c->sup_node);
 	ubifs_debugging_exit(c);
 	return err;
 }
@@ -1641,6 +1642,7 @@ static void ubifs_umount(struct ubifs_in
 	vfree(c->ileb_buf);
 	vfree(c->sbuf);
 	kfree(c->bottom_up_buf);
+	kfree(c->sup_node);
 	ubifs_debugging_exit(c);
 }
 


