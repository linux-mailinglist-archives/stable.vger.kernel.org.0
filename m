Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4FE23436
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbfETMYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388878AbfETMYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBBF20645;
        Mon, 20 May 2019 12:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355076;
        bh=Y8pn0klUBCj5HAGh+Ju8aJxxSJY616eLJ6p9gRpf8b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojQ8q48SYqyDsOKPWeRbq2ROy3fh8Stf/0Pwc83Al2ZOjQsmjn0BO0s7ctXA8PIFc
         eFJi3SDGgQbsEjg6+lD1sPi/5uRqKXKNusUlwow2AHyCA8um1WQUlymQ9L+uxmh4Ym
         oQ3XlVEhvD712vzZXqpQ1wz4o+ZPuQhc6bCtsvNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 086/105] ext4: fix data corruption caused by overlapping unaligned and aligned IO
Date:   Mon, 20 May 2019 14:14:32 +0200
Message-Id: <20190520115253.212480888@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
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
@@ -264,6 +264,13 @@ ext4_file_write_iter(struct kiocb *iocb,
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


