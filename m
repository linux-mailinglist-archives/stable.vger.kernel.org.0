Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E733BB137
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhGDXLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232327AbhGDXKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B26C56144E;
        Sun,  4 Jul 2021 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440054;
        bh=BlGq8KKuCkSpLMk5NR9JZxmkyEyOdfvm0EvyJwhVNFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYn1va7rHp+S2oNt4C47mYOLV+zVYExmkT6/3lpjGOTimYgy5zPKOhBDDC2sL4CNN
         ZpWGeGE5U5c462k/3fgfK0GT9e0ta0cAVd3kTWEkh+FGP0ArtI9zNWA7pEHQOE/zOv
         Z5WbFA6lAeHu8wqTJkInDq+YFo3H+yvCHTqAOI7Qoh8DPr7J+qVWDJq3JuViWjIUT6
         iEA/6yU+zalgAcO5Hm0gUNjurhR9Y4dJfosoTdce/QD98sYp6UtH6Q8BW8Q/g/InqJ
         a56gyU3ajFVPMiKyGrMbGar/pw0TEC2TFHYjy4ry7QAu8h22MGb3MikOS02JQcEwRQ
         jnxI1wzZaWAqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 58/80] media: siano: fix device register error path
Date:   Sun,  4 Jul 2021 19:05:54 -0400
Message-Id: <20210704230616.1489200-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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

