Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086E423786
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388471AbfETMuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732569AbfETMUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:20:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2AE2214AE;
        Mon, 20 May 2019 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354847;
        bh=QOAseeH2yv1IQXokjrSetFhF2bK4kHRU9OJPRZHBuFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uF8kx5BdhNRLEy8v8Qo5bdy9B3td8z1MIlytRqz9buS2f0hGeQskf4Fr4fraH/Q0o
         aH3WvwFpn3sfsgEmMyGa5K33KT4eEDL44AZsIGfIck0P/p1rE7ALKNI+3a9ZxuKSfh
         1iZS9t0q7HOVle1Uni0g0ZeFMH/zo5ehscCPbikg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 58/63] ext4: fix data corruption caused by overlapping unaligned and aligned IO
Date:   Mon, 20 May 2019 14:14:37 +0200
Message-Id: <20190520115237.335124529@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

commit 57a0da28ced8707cb9f79f071a016b9d005caf5a upstream.

Unaligned AIO must be serialized because the zeroing of partial blocks
of unaligned AIO can result in data corruption in case it's overlapping
another in flight IO.

Currently we wait for all unwritten extents before we submit unaligned
AIO which protects data in case of unaligned AIO is following overlapping
IO. However if a unaligned AIO is followed by overlapping aligned AIO we
can still end up corrupting data.

To fix this, we must make sure that the unaligned AIO is the only IO in
flight by waiting for unwritten extents conversion not just before the
IO submission, but right after it as well.

This problem can be reproduced by xfstest generic/538

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -262,6 +262,13 @@ ext4_file_write_iter(struct kiocb *iocb,
 	}
 
 	ret = __generic_file_write_iter(iocb, from);
+	/*
+	 * Unaligned direct AIO must be the only IO in flight. Otherwise
+	 * overlapping aligned IO after unaligned might result in data
+	 * corruption.
+	 */
+	if (ret == -EIOCBQUEUED && unaligned_aio)
+		ext4_unwritten_wait(inode);
 	inode_unlock(inode);
 
 	if (ret > 0)


