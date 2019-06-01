Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1F31F21
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfFANSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbfFANSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9197F272C0;
        Sat,  1 Jun 2019 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395130;
        bh=DQFifoSnA4WTPRNM7L36Gt4t6w84wHh5lhn7kpd4ZEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQ6zSbBINGpkEnnBZlgscZyr1+ScUJL0FtnEPD4bjrafmnVVWLrnNzfzlDyQ1CKLI
         NSfhGfO2QIgCLwWyjJRdh0HjTdWbgVkvA0DrGbrsEpqA3GjcvFY+WWLEYaaOeWQPh1
         rOpaOUz3f65myPG+clQLtKm9ef5HhXoJ/CN1mxGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.1 053/186] f2fs: fix to avoid deadloop in foreground GC
Date:   Sat,  1 Jun 2019 09:14:29 -0400
Message-Id: <20190601131653.24205-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 793ab1c8a792f8bccd7ae4c5be02bd275410b3af ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203211

- Overview
When mounting the attached crafted image and making a new file, I got this error and the error messages keep repeating.

The image is intentionally fuzzed from a normal f2fs image for testing and I run with option CONFIG_F2FS_CHECK_FS on.

- Reproduces
mkdir test
mount -t f2fs tmp.img test
cd test
touch t

- Messages
[   58.820451] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.821485] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.822530] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.823571] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.824616] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.825640] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.826663] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.827698] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.828719] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.829759] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.830783] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.831828] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.832869] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.833888] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.834945] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.835996] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.837028] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.838051] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.839072] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.840100] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.841147] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.842186] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.843214] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.844267] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.845282] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.846305] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
[   58.847341] F2FS-fs (sdb): Inconsistent segment (1) type [1, 0] in SSA and SIT
... (repeating)

During GC, if segment type stored in SSA and SIT is inconsistent, we just
skip migrating current segment directly, since we need to know the exact
type to decide the migration function we use.

So in foreground GC, we will easily run into a infinite loop as we may
select the same victim segment which has inconsistent type due to greedy
policy. In order to end up this, we choose to shutdown filesystem. For
backgrond GC, we need to do that as well, so that we can avoid latter
potential infinite looped foreground GC.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ab764bd106de1..a66a8752e5f65 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1175,6 +1175,7 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 				"type [%d, %d] in SSA and SIT",
 				segno, type, GET_SUM_TYPE((&sum->footer)));
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			f2fs_stop_checkpoint(sbi, false);
 			goto skip;
 		}
 
-- 
2.20.1

