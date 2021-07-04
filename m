Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7339E3BB335
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhGDXRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234303AbhGDXPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C436145D;
        Sun,  4 Jul 2021 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440329;
        bh=dHX1inVFLxX/mAZfDaFUbZKuIuq3XDpHsC/pHKJDIA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPxkQv4kBNCyYJeRGoV4pIYoAQfgxgOKAYAfv6NbsmEbn9yuCOCV0Suy5U8wQ2k7B
         M4XLxTFyWVsmhQuf1YwvWU3K+sLjGAbTqTEATwuUJ19sxQIv5zHlm4dxTYUXuFJxlG
         6L8ztPyCjQNuKuzOoWX1zxgZ91vpBR7oY2XvcXDB68/VV/7TDMr0CrcJDMW9cXXfjz
         AbYUGqucOEjDGswCidIhRrQIElR3ouEo6AsvRCmkR6O1lBju3oagWxBNNmBVNCMsgB
         p1HMf12mzUoeLuitYlZo5zjcqwCpZxmyq9qFyOq4WfvtO/2cc8dSh1/7HKYXvBqt3q
         QTTvcaJcMSleA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/20] media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
Date:   Sun,  4 Jul 2021 19:11:45 -0400
Message-Id: <20210704231155.1491795-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231155.1491795-1-sashal@kernel.org>
References: <20210704231155.1491795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 7dd0c9e547b6924e18712b6b51aa3cba1896ee2c ]

A use after free bug caused by the dangling pointer
filp->privitate_data in v4l2_fh_release.
See https://lore.kernel.org/patchwork/patch/1419058/.

My patch sets the dangling pointer to NULL to provide
robust.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index 0c5e69070586..d44b289205b4 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -109,6 +109,7 @@ int v4l2_fh_release(struct file *filp)
 		v4l2_fh_del(fh);
 		v4l2_fh_exit(fh);
 		kfree(fh);
+		filp->private_data = NULL;
 	}
 	return 0;
 }
-- 
2.30.2

