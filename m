Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F473BB31D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhGDXRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhGDXO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B9EC61951;
        Sun,  4 Jul 2021 23:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440300;
        bh=uVfsS63Qi3htFTA0i7wUs5QP7thxs7kRT0WREXLPXCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyTxc70glJC3A8vcMYCbN24rzSxc7UxR2Z53/N0u6I8L/hip5kmyTclmhzY40bCYn
         /3Kkrw0HLe07lVpWIx1lDab1ITdQxzLydNNUXMiBXoT9lGazBPl3pf142jzLm+KzBR
         d9Cncw5+4i1iI7B4yuu3LibXBn9nMOoM6IRwDj+DwTO3z+SqypRFuMN1NYZen5eIKN
         CTrZX+WMUVVuKQyMDqLOLPyhnKdQoHZVZ5ZYFW1n2vyt7jrx4V/nos1lXKbahC2oMQ
         ic3cPkU/4SfDpJHJ3AUG+5hvzCLmHcE+W34zTe5hdHi+nLoJmqZhAwj/Z7Nn0owqgl
         IBjWoO1Ka051A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/25] media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
Date:   Sun,  4 Jul 2021 19:11:11 -0400
Message-Id: <20210704231123.1491517-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231123.1491517-1-sashal@kernel.org>
References: <20210704231123.1491517-1-sashal@kernel.org>
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

