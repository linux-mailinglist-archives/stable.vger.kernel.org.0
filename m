Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FAA328AE2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbhCASYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234853AbhCASTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E77C651DB;
        Mon,  1 Mar 2021 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619080;
        bh=rPfHRjOcQk/PkP+1MTkYnkjU8mutHqM49XFxqgdd3sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWoPxoEeTf0Kxorw/PLopm/m7TKogW+4HjFSzjLZyy/DGyyyLmeHPWBOkQNd4Fn+b
         6yFW79YAKh7Fk7WwiTpNoiEjN3pvYDIUAPNh6rMIbT7tnTXwAaPzJinlWgWybrAWSE
         iR/BjfN2aLVfAMGjopCgm9Xk2fkk2p1JXCiFlAB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/663] IB/umad: Return EIO in case of when device disassociated
Date:   Mon,  1 Mar 2021 17:09:31 +0100
Message-Id: <20210301161157.826341410@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index b0d0b522cc764..351631c4db9b3 100644
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



