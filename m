Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98DF24F5EF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgHXIzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbgHXIzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49FBB204FD;
        Mon, 24 Aug 2020 08:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259321;
        bh=LZDRt3WvxLw2evyQog7DfExtExB1LFq2ZpLvebeUAeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is5Pjl6WiIVH/itBs8NpxOoGqeSeJUBpRtTF74JYLbdcyAlB/zaWr56f2Z+JFPRJ2
         5+WeI2U674mFr2QBxxF+8OtSEuqqJaEyDRn/evhEu059HUL3/SKpxyCetL4AzoOnry
         Rp2WxMPywhaQArGZ8o+fUmTIDBEfUyqrYkdvc+zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 15/71] jbd2: add the missing unlock_buffer() in the error path of jbd2_write_superblock()
Date:   Mon, 24 Aug 2020 10:31:06 +0200
Message-Id: <20200824082356.659566903@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit ef3f5830b859604eda8723c26d90ab23edc027a4 upstream.

jbd2_write_superblock() is under the buffer lock of journal superblock
before ending that superblock write, so add a missing unlock_buffer() in
in the error path before submitting buffer.

Fixes: 742b06b5628f ("jbd2: check superblock mapped prior to committing")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20200620061948.2049579-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/journal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1370,8 +1370,10 @@ static int jbd2_write_superblock(journal
 	int ret;
 
 	/* Buffer got discarded which means block device got invalidated */
-	if (!buffer_mapped(bh))
+	if (!buffer_mapped(bh)) {
+		unlock_buffer(bh);
 		return -EIO;
+	}
 
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))


