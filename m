Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC623CD901
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbhGSO0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244151AbhGSOYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CBD36113E;
        Mon, 19 Jul 2021 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707121;
        bh=dHX1inVFLxX/mAZfDaFUbZKuIuq3XDpHsC/pHKJDIA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ik5mKspZNrAEsUNQ3SoDEqhP+afohlln7HEQmCitrYDbkYY2d0PgtIMouequ7VHD/
         Nt/Wzy16fI6HCJ/ZK8YO8ksKS+33ltRENSfhbz3MkWgh1G0l0uoGXd7YrwDa3LeHAs
         aOSTq3LTcen3/reftt/Cn5W+JANdblZmhZBfosMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 038/245] media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
Date:   Mon, 19 Jul 2021 16:49:40 +0200
Message-Id: <20210719144941.623497768@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



