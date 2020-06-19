Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E02A200CBA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbgFSOtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389156AbgFSOs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:48:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC386217A0;
        Fri, 19 Jun 2020 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578139;
        bh=H5xDzHKG9GRHH4R47pWgDEYLAYfTowtEAnmIXJQZqIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JByso0eGxXsO4iVU/qmNpMFBZhLXtpU6vZAyowKT6WN7QI2vZve3obxijZ1ni/Mam
         SRWvkF9ymjwmnOcHMlvqRVQeqpi52keV8sVHUaG97avg550AKQGYqi1riatJirbp5S
         1bV3wSWJJaC+aHI/PyT5urjl43jrGmDTEY55sNKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6f1624f937d9d6911e2d@syzkaller.appspotmail.com,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 068/190] fat: dont allow to mount if the FAT length == 0
Date:   Fri, 19 Jun 2020 16:31:53 +0200
Message-Id: <20200619141636.978715334@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit b1b65750b8db67834482f758fc385bfa7560d228 upstream.

If FAT length == 0, the image doesn't have any data. And it can be the
cause of overlapping the root dir and FAT entries.

Also Windows treats it as invalid format.

Reported-by: syzbot+6f1624f937d9d6911e2d@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Link: http://lkml.kernel.org/r/87r1wz8mrd.fsf@mail.parknet.co.jp
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fat/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1512,6 +1512,12 @@ static int fat_read_bpb(struct super_blo
 		goto out;
 	}
 
+	if (bpb->fat_fat_length == 0 && bpb->fat32_length == 0) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "bogus number of FAT sectors");
+		goto out;
+	}
+
 	error = 0;
 
 out:


