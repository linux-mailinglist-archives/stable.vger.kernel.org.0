Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C05261E9C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgIHTxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbgIHPrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:47:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03DE62481C;
        Tue,  8 Sep 2020 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579840;
        bh=jeOqopXGq3hTnELHVtS9hzppRrX8dLleC94kYzYg99I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQIg8r7E3Q300piUtM2MMxxhbL8H6M6jlXSCdwxsugO2TjFV8k4/DcBO+vcYMhED3
         XGUKJ6ufywhtRJv4nHiEDnZeM0vYICUxbndXUR/iUDHFd83e1j1yrbqmYzcCnSf7WZ
         akdgKoQUCJ1pFfsOy1e1BrNNWDWmf0p5dDeFWfr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/129] nvme: fix controller instance leak
Date:   Tue,  8 Sep 2020 17:24:56 +0200
Message-Id: <20200908152232.456316712@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 192f6c29bb28bfd0a17e6ad331d09f1ec84143d0 ]

If the driver has to unbind from the controller for an early failure
before the subsystem has been set up, there won't be a subsystem holding
the controller's instance, so the controller needs to free its own
instance in this case.

Fixes: 733e4b69d508d ("nvme: Assign subsys instance from first ctrl")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ff5681da8780d..3cb017fa3a790 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4012,7 +4012,7 @@ static void nvme_free_ctrl(struct device *dev)
 		container_of(dev, struct nvme_ctrl, ctrl_device);
 	struct nvme_subsystem *subsys = ctrl->subsys;
 
-	if (subsys && ctrl->instance != subsys->instance)
+	if (!subsys || ctrl->instance != subsys->instance)
 		ida_simple_remove(&nvme_instance_ida, ctrl->instance);
 
 	kfree(ctrl->effects);
-- 
2.25.1



