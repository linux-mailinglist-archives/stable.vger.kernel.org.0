Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148A6205E98
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbgFWUYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390387AbgFWUYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:24:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C5C120723;
        Tue, 23 Jun 2020 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943852;
        bh=iUKR0v63r3GnOklc2BVLSssZFTEDeku8CMikUfnjM7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMsJMBkrq+BeRkjhsAT8FyQGByf+hokxUCFMl9r/WRebgAjC7E9yujrkw4Xfr3/eU
         TWK1oavbAUsxsflhwLHLr7PR2+z4lKQAYl/DTbKmTfiJl33I7HeY1WHjeFPj/4fh+Z
         Byh0bjfEOEgP8c2EQ8IoqA2QVcDeqR4CjDHQgXh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/314] f2fs: handle readonly filesystem in f2fs_ioc_shutdown()
Date:   Tue, 23 Jun 2020 21:54:32 +0200
Message-Id: <20200623195342.530618002@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 8626441f05dc45a2f4693ee6863d02456ce39e60 ]

If mountpoint is readonly, we should allow shutdowning filesystem
successfully, this fixes issue found by generic/599 testcase of
xfstest.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c3a9da79ac997..5d94abe467a4f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2056,8 +2056,15 @@ static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
 
 	if (in != F2FS_GOING_DOWN_FULLSYNC) {
 		ret = mnt_want_write_file(filp);
-		if (ret)
+		if (ret) {
+			if (ret == -EROFS) {
+				ret = 0;
+				f2fs_stop_checkpoint(sbi, false);
+				set_sbi_flag(sbi, SBI_IS_SHUTDOWN);
+				trace_f2fs_shutdown(sbi, in, ret);
+			}
 			return ret;
+		}
 	}
 
 	switch (in) {
-- 
2.25.1



