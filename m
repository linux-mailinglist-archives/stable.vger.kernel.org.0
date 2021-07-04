Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209A53BB2C8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhGDXQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhGDXOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07ED3619AD;
        Sun,  4 Jul 2021 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440265;
        bh=uVfsS63Qi3htFTA0i7wUs5QP7thxs7kRT0WREXLPXCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhM1bKMOo/qvkiinJwztq0+MRIyVugeC6Jhjez3h7iCwcCU133RIrVtJrPRstt1D7
         2MnElsU1CXAf2TCfyaBOQnHS6XmjiYKnZjoWnqX7b7XEN+WU5k4Z8O4JFJ1RhRIGy3
         ZGqs5ZWyuHMIsCSJcIGuS8EJcPOeI4hq9lps23OklUbNZ/30JFRBkQ16MTjbDX7BHM
         QGVZwMthJPqH8Y4hfL4AbL6nKalDb0EWajZQBboJaHeTBzY14cakx9lrOQLY0YhkNp
         KHl7YEylMUIvwg8tkv6Vqb3J7GbZmQXcwRD6F+Yytdgb+P/0IcMU57iKVaIvwKMPdm
         LXX35Pp+VrlLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/31] media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
Date:   Sun,  4 Jul 2021 19:10:29 -0400
Message-Id: <20210704231043.1491209-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index c91a7bd3ecfc..ac8282d059fc 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -104,6 +104,7 @@ int v4l2_fh_release(struct file *filp)
 		v4l2_fh_del(fh);
 		v4l2_fh_exit(fh);
 		kfree(fh);
+		filp->private_data = NULL;
 	}
 	return 0;
 }
-- 
2.30.2

