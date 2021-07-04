Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869113BB12E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhGDXK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhGDXKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB3D613FB;
        Sun,  4 Jul 2021 23:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440034;
        bh=LYo60E9hzNfnIeU6O7W5VONI9WogMKheLf5JCQtvhwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnWBoOGyV9S34JqkTpK0vUTkfrckgaMz9hFpmsNoaDkO6M535u9D21UNJFWxAFXXf
         gfR66+FP9Pnme16FfA/LHkFxQjuSH+IrOJVvWfBDuqe2jbyiCtxMGheYcY4CEDrVP3
         nNlwSdyUSCMcq1Hz1yfQ20jVPIuAFfEK4L7WLwfcYbsdAFGDct1B5wsi/FTIFw68Gg
         pQ54+NjQlBLdGORc7UBu3IE3pLBMDivEmo82qkPP60kjWVHC94LpWwgCLuvUggrCKG
         /iUfeTkL1Xpr55KBRlHIKq+2i6+L+OeFseMrfSyStbdPfXnzZgLraVvzP+++XhgNqf
         Zuu0srW+6wOjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 42/80] media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
Date:   Sun,  4 Jul 2021 19:05:38 -0400
Message-Id: <20210704230616.1489200-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index 684574f58e82..90eec79ee995 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -96,6 +96,7 @@ int v4l2_fh_release(struct file *filp)
 		v4l2_fh_del(fh);
 		v4l2_fh_exit(fh);
 		kfree(fh);
+		filp->private_data = NULL;
 	}
 	return 0;
 }
-- 
2.30.2

