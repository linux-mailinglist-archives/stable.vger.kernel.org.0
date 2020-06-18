Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99901FE771
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgFRBMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbgFRBMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F04E20B1F;
        Thu, 18 Jun 2020 01:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442735;
        bh=SQj2NRbSEqIYGQpLgmiIi058rCiMpe/GiKQnx6UPSrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dx7Yum849qaqp6kRWl+5A4qxolenYXlHQ7UdkzoWKjuBqOV8gUPqzYUcujdgxHe+2
         SbQRBYnaazqQiKzLXSqIG+1Xmxi2XSeOy7DZr2e6+ANhAUWA5Feuf1lWd1JDgvlrcK
         COOMsUId+IzfX3ScDmvDtr+fIwbf2cLT/xhhlbiE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Daeho Jeong <daehojeong@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.7 190/388] f2fs: compress: fix zstd data corruption
Date:   Wed, 17 Jun 2020 21:04:47 -0400
Message-Id: <20200618010805.600873-190-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 1454c978efbb57b052670d50023f48c759d704ce ]

During zstd compression, ZSTD_endStream() may return non-zero value
because distination buffer is full, but there is still compressed data
remained in intermediate buffer, it means that zstd algorithm can not
save at last one block space, let's just writeback raw data instead of
compressed one, this can fix data corruption when decompressing
incomplete stored compression data.

Fixes: 50cfa66f0de0 ("f2fs: compress: support zstd compress algorithm")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index c05801758a35..a5b2e72174bb 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -369,6 +369,13 @@ static int zstd_compress_pages(struct compress_ctx *cc)
 		return -EIO;
 	}
 
+	/*
+	 * there is compressed data remained in intermediate buffer due to
+	 * no more space in cbuf.cdata
+	 */
+	if (ret)
+		return -EAGAIN;
+
 	cc->clen = outbuf.pos;
 	return 0;
 }
-- 
2.25.1

