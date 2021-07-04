Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2B3BB086
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhGDXIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhGDXIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 674E4613F1;
        Sun,  4 Jul 2021 23:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439943;
        bh=zlRAvS0RDgjJ2LkGWY/QXBDscxE3qswqEy1ILegPTAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsPKZcjEhuNdjZRe5TmLWDG16qoX/l/HCEtJcXu9hJFQsyMWfeAddFbTmCnbm74jq
         wu9sE2KbprLFZyFyKOhw0t4eYbRzXhpZhtFD0lJJEgU6WcQ2iGAiwCcAUTul1vU8lr
         SHNk6OgEWXW6lSiD64DU76+EAmKUBaWQpjOlkt7ERwvw6OGiOaO0S8CCjS61TCpwkE
         bpplqEJx5uexf4Wy/Hv1viaerD1ezHLxz5d3gDOslXNc63QlXra+LXOPxrxUsthNmC
         n5/jafbCet4swPIs/dqG20+Qkuns5PIy6N0qIRZC4NxKvq/aiEhZo7/g0t43bFruZ0
         dK7XClppotSWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 61/85] media: siano: fix device register error path
Date:   Sun,  4 Jul 2021 19:03:56 -0400
Message-Id: <20210704230420.1488358-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index cd5bafe9a3ac..7e4100263381 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1212,6 +1212,10 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
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

