Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C74E3BB2DC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhGDXQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhGDXNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AD966135D;
        Sun,  4 Jul 2021 23:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440153;
        bh=BlGq8KKuCkSpLMk5NR9JZxmkyEyOdfvm0EvyJwhVNFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=om+KF5bxtH8aMNcpU9Yfo+nt5GCW+KwIAe4fqNK/1ASlIcYTz9UJM0FY8+r7xNWI+
         hlO3ypxUpdbOAJ4OoCaxQI+GuYVunQXirwZaLRhmIg52eL1bJzLMlyc5io18xPgxTu
         T+TMrITWru6OxqapnLfH6x9tDP4aiIHT3oJ4HAp2LeQWy0oacWTgDNpMMB/PzYqyL2
         jAbCSoLuVTH7SMiVczRIzLEEq3iLy7HAKLJt1KvCEFs66TIkrb9Pn7PCe+Fqt7o4+s
         8bWSSIBlaNrfT7fAoFR4ksBN17zivbm5IdWjcBU4H2hbrrP4UTqaghAQF4VOhRw4if
         TV4olc12G9euQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 52/70] media: siano: fix device register error path
Date:   Sun,  4 Jul 2021 19:07:45 -0400
Message-Id: <20210704230804.1490078-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
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

