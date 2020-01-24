Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7619D1480BA
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390095AbgAXLNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390093AbgAXLNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C670620663;
        Fri, 24 Jan 2020 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864434;
        bh=jd3CQLaNRQvA8L575dOIe2ioxcnv4Fuzj7MTweEBl84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKXXhJrueKJXXPo+jHvGEUB0m5T6cqXGSett1Pa85bitEPbxDHNQTe5VsNqHxBIOB
         wktOvNmG3ncCSWWwtFGiMAQTDwV7wMVPq9fGCzrQJn9rl4fVXV1BkwccXsnGPVdYNs
         C/MgrIex95IeefuZEUl6fb7rEbLMXKFb9uBLILjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 251/639] rbd: clear ->xferred on error from rbd_obj_issue_copyup()
Date:   Fri, 24 Jan 2020 10:27:01 +0100
Message-Id: <20200124093118.177906479@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 356889c49d84f11f446ec235bd52ca1a7d581aa0 ]

Otherwise the assert in rbd_obj_end_request() is triggered.

Fixes: 3da691bf4366 ("rbd: new request handling code")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 585378bc988cd..b942f4c8cea8c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2506,6 +2506,7 @@ again:
 		ret = rbd_obj_issue_copyup(obj_req, obj_req->xferred);
 		if (ret) {
 			obj_req->result = ret;
+			obj_req->xferred = 0;
 			return true;
 		}
 		return false;
-- 
2.20.1



