Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B858C111CFC
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfLCWtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfLCWtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B6320684;
        Tue,  3 Dec 2019 22:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413358;
        bh=/vmX04MLemZY4vMaELPHl3ztTQcIKNH/er6LGe97v1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/wfRhC+oXPl8xyLYhL7H8qvjhBfXerYyeS1DoHj6ynlsEMe2jtXDPiii41TDZ5r1
         E3l/4BJL5d71tyk8RLoKpmwjrOnwt9vaPPyIx6/ao3I1fizWWxZ8yTDaq8YlM1fi2Z
         vIXyg71gh3akS0Df+vn0VK+5cckK3H5cUDxVkcE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/321] nvme: fix kernel paging oops
Date:   Tue,  3 Dec 2019 23:32:44 +0100
Message-Id: <20191203223432.256097169@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 092ff0520070fad8407b196f3bb6156ce77a6f98 ]

free the controller discard_page correctly.

Fixes: cb5b7262b011 ("nvme: provide fallback for discard alloc failure")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 250ccf3108e98..c4ff4f079448e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3569,7 +3569,7 @@ static void nvme_free_ctrl(struct device *dev)
 	ida_simple_remove(&nvme_instance_ida, ctrl->instance);
 	kfree(ctrl->effects);
 	nvme_mpath_uninit(ctrl);
-	kfree(ctrl->discard_page);
+	__free_page(ctrl->discard_page);
 
 	if (subsys) {
 		mutex_lock(&subsys->lock);
-- 
2.20.1



