Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529E13288B8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhCARnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238707AbhCARiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 821D564F38;
        Mon,  1 Mar 2021 16:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617739;
        bh=v4/UjRAZBEZDC1o3dnjaJ3Yuwj9jEtLBt4a+3JRnJqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmiVbjn92Io+XCuH/OkWIxeWVMS9t/gYbGjxkI58aeuBJ6s4bfRxm/6b79ZAMY4wZ
         w/YvCKyoXuVGYtYJc/REbv2YhJ/9ptq6slmI8gM1A6XG/qTItXMzXP/w3Qh0rErSHB
         nu8yvD2UXabVz07npNeU5f2wkHUwQ5XpQ0BB4P68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/340] IB/umad: Return EIO in case of when device disassociated
Date:   Mon,  1 Mar 2021 17:11:46 +0100
Message-Id: <20210301161056.292530134@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index da229eab59032..dec5175803fe2 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -379,6 +379,11 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 
 	mutex_lock(&file->mutex);
 
+	if (file->agents_dead) {
+		mutex_unlock(&file->mutex);
+		return -EIO;
+	}
+
 	while (list_empty(&file->recv_list)) {
 		mutex_unlock(&file->mutex);
 
@@ -524,7 +529,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 
 	agent = __get_agent(file, packet->mad.hdr.id);
 	if (!agent) {
-		ret = -EINVAL;
+		ret = -EIO;
 		goto err_up;
 	}
 
-- 
2.27.0



