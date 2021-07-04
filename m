Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18823BB303
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhGDXQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhGDXOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7341961990;
        Sun,  4 Jul 2021 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440222;
        bh=BlGq8KKuCkSpLMk5NR9JZxmkyEyOdfvm0EvyJwhVNFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTBvqlL7ksDRLeRyeNayeyoGlkm9ul36+ZJJ8WsugC2WvlKyYKfTGk5AZZyTGqMRV
         nDPSK/Rd7fdb5Lt4ocmn+r1BU3d2irtYJvCjT1WGCNd/kOgy+Tvyx6g7ol+eBOu3mD
         +nnpxD0f0ZkqXxkdRI+mRqyFdRp3oK1dQKy7Fm/3hoKEVkwqub8b6ZW1A6qPvRzY5n
         2RM37KRYvzZhEbKu73wrvKmAhMmny3aAPjTzBqit1unKaTmj0ZgY6rd9wtk4HKDTM9
         adTCg0uNzxcLuQTjkLShR8q5MwUXdlSnYdx2RVTCLWv00JLOmfDN/BwLM8CEOi1eQN
         v/c3jhWsm6dmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/50] media: siano: fix device register error path
Date:   Sun,  4 Jul 2021 19:09:22 -0400
Message-Id: <20210704230938.1490742-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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
index ae17407e477a..7cc654bc52d3 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1176,6 +1176,10 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
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

