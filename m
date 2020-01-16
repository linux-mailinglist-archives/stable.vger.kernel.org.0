Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBFB13F65F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393118AbgAPTDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388399AbgAPRCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F2A2087E;
        Thu, 16 Jan 2020 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194151;
        bh=R7KkKUaYv6rkoyqNNorHo/kp3uI7wYQla8dT74bJabc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovFVWcpFfpkftBPgqDyPdZu8s4+lbxR716c9yQtIFf30J1O0DSl39XbKbKj+awEF1
         yigYnV47si26zmQ9Ct0G6Z0awhB7zbZat11qHjfUh0S5dAUIMH+K2q7rRgDOOSWsaM
         /4S1H990YmpRvVc/+kNgiLFtzCmqRu3uyXxT8ok4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sasha Levin <sashal@kernel.org>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 235/671] rbd: clear ->xferred on error from rbd_obj_issue_copyup()
Date:   Thu, 16 Jan 2020 11:52:24 -0500
Message-Id: <20200116165940.10720-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 585378bc988c..b942f4c8cea8 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2506,6 +2506,7 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
 		ret = rbd_obj_issue_copyup(obj_req, obj_req->xferred);
 		if (ret) {
 			obj_req->result = ret;
+			obj_req->xferred = 0;
 			return true;
 		}
 		return false;
-- 
2.20.1

