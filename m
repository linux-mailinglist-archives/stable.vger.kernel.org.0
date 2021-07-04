Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CC93BB278
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhGDXPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhGDXOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 149006198D;
        Sun,  4 Jul 2021 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440209;
        bh=LYo60E9hzNfnIeU6O7W5VONI9WogMKheLf5JCQtvhwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dzw0pvwHLokhgmlkcoA+rxxEpcK13PsjRQtegs65z+8PQuEvSCkY8s7b8YtfVKqc6
         GlasbKlNkMKTTZJGqeHREAtvkC/SnNiJqOMDV+czmvkX51IfLcjCctY84El8i9ng1s
         iX+811bPEGjeXU3GIu2f+68zHO/rLbcvzNXTrFQYr9PmPBOo7s4DB3VjTcd2QddOaJ
         IY1pGb21NAuDMLGHbDMKqW5/yffqYZhkl5BlQoCs8swOVlXfcN5brlHI/3vSHz5SF/
         lkmKPP6IcC3Aic2rErNQ6Zw8ksMbGZ2s7vUaIOqwjwefFL20QkN/wD1+8C9KYl/rzG
         oHcV9DKy4jXCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/50] media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
Date:   Sun,  4 Jul 2021 19:09:12 -0400
Message-Id: <20210704230938.1490742-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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

