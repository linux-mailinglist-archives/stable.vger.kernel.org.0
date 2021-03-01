Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BEC328452
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhCAQdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhCAQ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958DC64E41;
        Mon,  1 Mar 2021 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615787;
        bh=TF8qqukfkHPIRxa28vJ9WFox2u4Wc5rKGZS2EwTxVQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMOuGPUw01D5izMTb5SBPrwC7DVUHgiSM59vtpikqwXL4UXYEfMTskyRK3OccQqJ0
         vV0ONHl5gec4ymq3aPJzTVaZvX05evbzNTZQcO/QY9uBI3/NLqGRGypmmalU93i4CO
         GYfljkE0baj45vWn7sqfKfsbQJR0TII9XbISTh7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 059/134] IB/umad: Return EIO in case of when device disassociated
Date:   Mon,  1 Mar 2021 17:12:40 +0100
Message-Id: <20210301161016.465404120@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 4fc5461823c9cad547a9bdfbf17d13f0da0d6bb5 ]

MAD message received by the user has EINVAL error in all flows
including when the device is disassociated. That makes it impossible
for the applications to treat such flow differently.

Change it to return EIO, so the applications will be able to perform
disassociation recovery.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20210125121339.837518-2-leon@kernel.org
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/user_mad.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index cf93a96b63249..bc6458d760330 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -343,6 +343,11 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 
 	mutex_lock(&file->mutex);
 
+	if (file->agents_dead) {
+		mutex_unlock(&file->mutex);
+		return -EIO;
+	}
+
 	while (list_empty(&file->recv_list)) {
 		mutex_unlock(&file->mutex);
 
@@ -485,7 +490,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 
 	agent = __get_agent(file, packet->mad.hdr.id);
 	if (!agent) {
-		ret = -EINVAL;
+		ret = -EIO;
 		goto err_up;
 	}
 
-- 
2.27.0



