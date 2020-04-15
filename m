Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3071A9D1A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408951AbgDOLnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408939AbgDOLnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DAC420768;
        Wed, 15 Apr 2020 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950980;
        bh=53CAxUZWcyIkT9WZ1+VgTZGW//eve9xs10YjEaHuZ6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1R4ym3c6OQj7aqcXq8JsQ01tPJLxvXbwuV+fvrF/te2qogPSY7+iEILH/lCvG0CGg
         7nnNZSzKDhmUiwZz99Mvi0HaW/pXz+uwy24XGhiLKP7wxVG3AzULila1zJt/a8mygb
         up3FmAbZXPJNBJQLs8Ugb6CjFTqbjdebA4KQ0FRo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 028/106] NFSv4.2: error out when relink swapfile
Date:   Wed, 15 Apr 2020 07:41:08 -0400
Message-Id: <20200415114226.13103-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

[ Upstream commit f5fdf1243fb750598b46305dd03c553949cfa14f ]

This fixes xfstests generic/356 failure on NFSv4.2.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 3f892035c1413..b217400050288 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -251,6 +251,9 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 	if (remap_flags & ~REMAP_FILE_ADVISORY)
 		return -EINVAL;
 
+	if (IS_SWAPFILE(dst_inode) || IS_SWAPFILE(src_inode))
+		return -ETXTBSY;
+
 	/* check alignment w.r.t. clone_blksize */
 	ret = -EINVAL;
 	if (bs) {
-- 
2.20.1

