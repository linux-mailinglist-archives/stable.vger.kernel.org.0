Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EBD13EF49
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395326AbgAPSOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404885AbgAPRfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:35:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F972246C0;
        Thu, 16 Jan 2020 17:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196099;
        bh=gNFwEQOsiuqgaNAr1jQlS1TSYe0ExSz1VKzlHHfJk4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCgeQrZ5Wkd3aOcW4TuvQLYGTp6gvX3OqJUIIveN+48vhgJEtbXQRwuKe2OgawEyI
         JxfFKT4H0FP2DTX9l2FMGa3dS/TXe7HValnTGlWaYWrP9Ec4geKHgsTM21WR02uVu4
         suP2vE/IUqQITDldvd4YXYfA0Zu2UQ1APS88NWac=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 011/251] exportfs: fix 'passing zero to ERR_PTR()' warning
Date:   Thu, 16 Jan 2020 12:30:45 -0500
Message-Id: <20200116173445.21385-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 909e22e05353a783c526829427e9a8de122fba9c ]

Fix a static code checker warning:
  fs/exportfs/expfs.c:171 reconnect_one() warn: passing zero to 'ERR_PTR'

The error path for lookup_one_len_unlocked failure
should set err to PTR_ERR.

Fixes: bbf7a8a3562f ("exportfs: move most of reconnect_path to helper function")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exportfs/expfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 3706939e5dd5..1730122b10e0 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -146,6 +146,7 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 	tmp = lookup_one_len_unlocked(nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
 		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
+		err = PTR_ERR(tmp);
 		goto out_err;
 	}
 	if (tmp != dentry) {
-- 
2.20.1

