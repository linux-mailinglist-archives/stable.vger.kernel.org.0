Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A35236E3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbfETMRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731033AbfETMRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F1A20863;
        Mon, 20 May 2019 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354663;
        bh=06HwVM8mU9mLIabTQ9BoZcRofJbXFiysdQVqdvYyGC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpupQ+BQcLsR/LXrgsOSBmDciQmFVlXr9uE4PFIw3iJWcV16czPpkRHzUjqPImgvG
         UI691M/+Pn1z2kP1afbWyTiM8qMv2kuGcT/M2r2rqr6iEaeouAGCr4GRI42HxS8/4x
         eIKtA5stMu7j8U7GIwUMfZSjI6Qa2urvFGcQTY8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 42/44] ext4: fix data corruption caused by overlapping unaligned and aligned IO
Date:   Mon, 20 May 2019 14:14:31 +0200
Message-Id: <20190520115235.856197660@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
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
@@ -163,6 +163,13 @@ ext4_file_write_iter(struct kiocb *iocb,
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


