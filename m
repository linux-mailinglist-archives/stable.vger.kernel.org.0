Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3052F4FA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfE3EnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbfE3DML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 736FD244A0;
        Thu, 30 May 2019 03:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185931;
        bh=oGMgnOnKZhEXrJDQyhTO2LVkP6kwGWwuTovV+BkBQls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcAgeHxR7p04B/SwIyccv79ZcBCp7+CRWO8AqhpM4ik0qxuROFGPCLABarXC43BDo
         cQsgkQTs0csDucffkFXOXus6CbY1buZM36l+iofwvCgGuZdNJqZc3GAKoDwN9P/BuI
         TfvNmYy9TSdt+ovOo1rMbwwGgI84C6jYlVQjr4kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 326/405] thunderbolt: Fix to check return value of ida_simple_get
Date:   Wed, 29 May 2019 20:05:24 -0700
Message-Id: <20190530030557.239961713@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9aabb68568b473bf2f0b179d053b403961e42e4d ]

In enumerate_services, ida_simple_get on failure can return an error and
leaks memory. The patch ensures that the dev_set_name is set on non
failure cases, and releases memory during failure.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index e27dd8beb94be..e0642dcb8b9bd 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -740,6 +740,7 @@ static void enumerate_services(struct tb_xdomain *xd)
 	struct tb_service *svc;
 	struct tb_property *p;
 	struct device *dev;
+	int id;
 
 	/*
 	 * First remove all services that are not available anymore in
@@ -768,7 +769,12 @@ static void enumerate_services(struct tb_xdomain *xd)
 			break;
 		}
 
-		svc->id = ida_simple_get(&xd->service_ids, 0, 0, GFP_KERNEL);
+		id = ida_simple_get(&xd->service_ids, 0, 0, GFP_KERNEL);
+		if (id < 0) {
+			kfree(svc);
+			break;
+		}
+		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
 		svc->dev.parent = &xd->dev;
-- 
2.20.1



