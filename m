Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEAB2064F6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388922AbgFWUOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388911AbgFWUOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:14:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAB52073E;
        Tue, 23 Jun 2020 20:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943263;
        bh=/0jXKY3TJ2pVhw3ClEqAeO1O7QusWNrVVyNMLtWUTJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydqIet8HtrqF5I6ZM2OTMkxSqg2+IQxrsiy6/NKNUztKxV6uGAGERXaXaO3t9OhUJ
         CcKfsFiGoSqbpb+guBj0+oyz2ZWuQ+fmpTkGUolrCSJZR2g2h7ZANooaPFKb8JBEjn
         UPR43IWLCasM0IcQTghTDwZetJeJErbP1U4BvfEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 323/477] ext4: dont block for O_DIRECT if IOCB_NOWAIT is set
Date:   Tue, 23 Jun 2020 21:55:20 +0200
Message-Id: <20200623195422.801381152@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 6e014c621e7271649f0d51e54dbe1db4c10486c8 ]

Running with some debug patches to detect illegal blocking triggered the
extend/unaligned condition in ext4. If ext4 needs to extend the file (and
hence go to buffered IO), or if the app is doing unaligned IO, then ext4
asks the iomap code to wait for IO completion. If the caller asked for
no-wait semantics by setting IOCB_NOWAIT, then ext4 should return -EAGAIN
instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

Link: https://lore.kernel.org/r/76152096-2bbb-7682-8fce-4cb498bcd909@kernel.dk
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b8e69f9e38587..2a01e31a032c4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -502,6 +502,12 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret <= 0)
 		return ret;
 
+	/* if we're going to block and IOCB_NOWAIT is set, return -EAGAIN */
+	if ((iocb->ki_flags & IOCB_NOWAIT) && (unaligned_io || extend)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	offset = iocb->ki_pos;
 	count = ret;
 
-- 
2.25.1



