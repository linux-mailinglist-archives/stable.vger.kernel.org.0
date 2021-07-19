Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9157B3CDAAD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244745AbhGSOhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244864AbhGSOfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D9276023D;
        Mon, 19 Jul 2021 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707785;
        bh=KSDvRfzR54iZ9zef91Rxx7AkHUixUncTfwBbntOwQ68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvLXvMEy+7qx5Ya0ibEGzU1JOH35js/h4V+hOWiCNN8c7Ba8Cb/NT0G2X7Qkufwlu
         enroLV5yC1vLLVWGUtypE7lmIP1QQbWO5ZA1cfPuF032cIZpA14UdH1VACS3uCHcHF
         S899Rg9oJnl6ISyQeIkJE/IhfgRsRSiXZ/AiHq2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 055/315] media: siano: fix device register error path
Date:   Mon, 19 Jul 2021 16:49:04 +0200
Message-Id: <20210719144944.670521126@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 15e895c9f2e0..cbe5f08ae9ad 100644
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



