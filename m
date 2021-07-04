Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7955A3BB342
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhGDXRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234339AbhGDXPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D77F6195A;
        Sun,  4 Jul 2021 23:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440336;
        bh=zrYboXMK70Pl5qXC/p9zvCsNi9myE2zUuzYTu+8hHLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqOm3KFd6VkjECuMEeiFti9+A6UqrIpyrLKe7RTuw9X68Eno5rinvPVnFXjZRB+3C
         rqo8J/gnwJ5GtLGbSTY/mhXvCT5nK3jRHE1nTTUN83n3kFKJPNA4UDKpK0aRgNAFTp
         CernY6WwFRgLaYGCxmJ0FjVFx+bCDVRsgh5OqOMvkzHzU83gd9K9q8oMwKSJ9M8Rwo
         8HCBA24PuMOHFXyywZC3z+zRYGURhtoqMeSVc6DjzzDxwHcW8/FH+h3lobeHiGsDkc
         wkBXys3u0AISmIopjmk6T4G7yyXVhVVSDxWL0gHW6oRFkQDPZLc0FGyc9Df2J8OsxQ
         A7/GfRjmtWB+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/20] media: siano: fix device register error path
Date:   Sun,  4 Jul 2021 19:11:51 -0400
Message-Id: <20210704231155.1491795-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231155.1491795-1-sashal@kernel.org>
References: <20210704231155.1491795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 5368b1ee2939961a16e74972b69088433fc52195 ]

As reported by smatch:
	drivers/media/common/siano/smsdvb-main.c:1231 smsdvb_hotplug() warn: '&client->entry' not removed from list

If an error occur at the end of the registration logic, it won't
drop the device from the list.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/siano/smsdvb-main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 9d5eb8b6aede..3a5b5f94398a 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1187,6 +1187,10 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	return 0;
 
 media_graph_error:
+	mutex_lock(&g_smsdvb_clientslock);
+	list_del(&client->entry);
+	mutex_unlock(&g_smsdvb_clientslock);
+
 	smsdvb_debugfs_release(client);
 
 client_error:
-- 
2.30.2

