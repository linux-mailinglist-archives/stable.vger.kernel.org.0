Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259FB3BB35F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhGDXR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234118AbhGDXOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D051619B6;
        Sun,  4 Jul 2021 23:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440274;
        bh=2ZS5xMDvoLTBiKPfZSzaSTavFCLw6kOZAUcXUZT8P0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckCeBW5Yc7LtnairmeF6JYTijIMGePCDy0+GUsWQupw5w4aJgK2+ecSdx5ytS9ly0
         c3Gj/E5pYI/HW6nlgsynHL02VtLEBuuUP/qbkvjBTFB3ShrijkWAN2WZ9n7qTNV2GK
         eNMHkpyopSrKLsfUA/dWT0YVMKEwNyPRc/3xQjOJO2Mgm+gVE4buVhzT9F04uNIZAw
         liH2VogXieycYYMcqZx2GLyoB8vLQPwzS+qtbi+IRYGTSfWYC3xJ4U0TXQNr/WxVNY
         z4n0g54qXxvA+n5HxBmbe5RoNYYzgaauHNpED4TPXjv6QLPPq3FUAnUDtYHDEop335
         J/JDcfxjKVF7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/31] media: siano: fix device register error path
Date:   Sun,  4 Jul 2021 19:10:36 -0400
Message-Id: <20210704231043.1491209-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index afca47b97c2a..637ace7a2b5c 100644
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

