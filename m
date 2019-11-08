Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5EF49B9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389272AbfKHLlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:41:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389227AbfKHLlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE7DC222CF;
        Fri,  8 Nov 2019 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213272;
        bh=TGsOxMyPWE5J2waCsiFoRzIAdziPYQCI2nChIIFrhiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrtBQM2c34qggKGChPE09KAPlyE69PwESatb6I/mxLQsKNEb0v2VgiftSC54qzkdY
         3LHP4bQ/px8IECgaHJkZRC2xQwZ5XSUUWWXpUZdNxj5gHZUkaDgETuOiwqH5Wfv3on
         FxkK8QoE92SIMGlg8sI+9YjqC7ttnsMA/7bdw1Yc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 134/205] f2fs: fix memory leak of write_io in fill_super()
Date:   Fri,  8 Nov 2019 06:36:41 -0500
Message-Id: <20191108113752.12502-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 0b2103e886e6de9802e1170e57c573443286a483 ]

It needs to release memory allocated for sbi->write_io in error path,
otherwise, it will cause memory leak.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6851afc3bf805..588c575bd72b0 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2923,7 +2923,7 @@ try_onemore:
 				     GFP_KERNEL);
 		if (!sbi->write_io[i]) {
 			err = -ENOMEM;
-			goto free_options;
+			goto free_bio_info;
 		}
 
 		for (j = HOT; j < n; j++) {
-- 
2.20.1

