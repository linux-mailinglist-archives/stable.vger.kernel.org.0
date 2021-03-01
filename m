Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8050F3286FF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbhCARSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237304AbhCARLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:11:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E54664EDE;
        Mon,  1 Mar 2021 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616982;
        bh=Xq5hv6j2ZYDoZ0J2KXhUahGbS9/qEVyJnd0G4B4ZfY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwBYGbXoRjYq4QZcmLqT80ecDHZWSp89aZGzAVkALFKTa/6xJ8OK2WaFXEOd932ek
         6T6cRErCMluJnqZ0FCMKpnTPRnou+6KTWg17siknGVcb9WY2sJLkvC535zjYzkOE27
         SqbgzMwwHK3s4fIywvwSLUVOsg/j4dJhQIMUsXvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/247] IB/umad: Return EIO in case of when device disassociated
Date:   Mon,  1 Mar 2021 17:12:31 +0100
Message-Id: <20210301161038.087873524@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index a18f3f8ad77fe..db2ac5218c371 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -366,6 +366,11 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 
 	mutex_lock(&file->mutex);
 
+	if (file->agents_dead) {
+		mutex_unlock(&file->mutex);
+		return -EIO;
+	}
+
 	while (list_empty(&file->recv_list)) {
 		mutex_unlock(&file->mutex);
 
@@ -508,7 +513,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 
 	agent = __get_agent(file, packet->mad.hdr.id);
 	if (!agent) {
-		ret = -EINVAL;
+		ret = -EIO;
 		goto err_up;
 	}
 
-- 
2.27.0



