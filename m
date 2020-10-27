Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A5B29C154
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818881AbgJ0RYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900782AbgJ0OyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F48222281;
        Tue, 27 Oct 2020 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810445;
        bh=AevS3VJiIWV6RWC+KJ2jiUeCQrep6DzQMeOmMC+G+wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amnSl5chxmm5bGkqVx6a63YxC/zY05WJF4aC/lZCQ+pEmbkK7uwcJbAO6kqf/FLnG
         WcnE8g+V7l9J38oUS04cYnj4qD5FPPl5yu3RApsrCh8fAqg/NKnDm6PoJQo5t5YcDO
         F2a3tzHo25nq4sZ+Qt8WPC5sMU5e9eMLimIv/qzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 140/633] media: platform: fcp: Fix a reference count leak.
Date:   Tue, 27 Oct 2020 14:48:03 +0100
Message-Id: <20201027135529.252887752@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 63e36a381d92a9cded97e90d481ee22566557dd1 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Fixes: 6eaafbdb668b ("[media] v4l: rcar-fcp: Keep the coding style consistent")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-fcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 5c6b00737fe75..05c712e00a2a7 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -103,8 +103,10 @@ int rcar_fcp_enable(struct rcar_fcp_device *fcp)
 		return 0;
 
 	ret = pm_runtime_get_sync(fcp->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(fcp->dev);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.25.1



