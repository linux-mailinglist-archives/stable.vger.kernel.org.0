Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C412F151
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgABW7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:59:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgABWN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8EF522525;
        Thu,  2 Jan 2020 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003237;
        bh=YhmOiMled1/G2x2INpuYgJq0C1R/wZfIFZZcOdQCIao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG3Qt/y1UdCIMkgDAjLxaCXpCZqXNmM7gTY1Mo1Co5J3BfvXRRMkDXZZ2POTCrpXs
         E/FfAA3VhvNa6ru9Zx/CvlUikadUHRc7kAmrras7DoJj1/03T+9RuOywLmW9LK4ujo
         bxELBjGrQMt58vLHw/3KMmRsKcuPS9AUt0hJjXa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jan Stancek <jstancek@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/191] iomap: fix return value of iomap_dio_bio_actor on 32bit systems
Date:   Thu,  2 Jan 2020 23:05:41 +0100
Message-Id: <20200102215836.298398377@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit e9f930ac88a8936ccc2d021110c98810cf5aa810 ]

Naresh reported LTP diotest4 failing for 32bit x86 and arm -next
kernels on ext4. Same problem exists in 5.4-rc7 on xfs.

The failure comes down to:
  openat(AT_FDCWD, "testdata-4.5918", O_RDWR|O_DIRECT) = 4
  mmap2(NULL, 4096, PROT_READ, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f7b000
  read(4, 0xb7f7b000, 4096)              = 0 // expects -EFAULT

Problem is conversion at iomap_dio_bio_actor() return. Ternary
operator has a return type and an attempt is made to convert each
of operands to the type of the other. In this case "ret" (int)
is converted to type of "copied" (unsigned long). Both have size
of 4 bytes:
    size_t copied = 0;
    int ret = -14;
    long long actor_ret = copied ? copied : ret;

    On x86_64: actor_ret == -14;
    On x86   : actor_ret == 4294967282

Replace ternary operator with 2 return statements to avoid this
unwanted conversion.

Fixes: 4721a6010990 ("iomap: dio data corruption and spurious errors when pipes fill")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index fd46ec83cb04..7b5f76efef02 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -318,7 +318,9 @@ zero_tail:
 		if (pad)
 			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
 	}
-	return copied ? copied : ret;
+	if (copied)
+		return copied;
+	return ret;
 }
 
 static loff_t
-- 
2.20.1



