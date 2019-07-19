Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222E36DE60
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732177AbfGSEGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732162AbfGSEGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:06:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36CB0218BA;
        Fri, 19 Jul 2019 04:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509189;
        bh=RX7pjhfYJDttI79oviZd+at8gnCY4U7hn3EudpnuOE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1e1MKhSJ0Ld7uspSLS6olOS1SWb9HJh5TLMg7o4wHve19rOJpXxi90RlOZcDJMVqs
         4oMQoVcngvj8DvFKfmztD2NTQyUH55qsUU4ObpVCOH8ZeKAMDBYj1VJmi4eR8D4/RM
         Gr/ijfnkhb1O4K0//1oWAW4rNUy11AMoDBEnR+sQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     morten petersen <morten_bp@live.dk>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 117/141] mailbox: handle failed named mailbox channel request
Date:   Fri, 19 Jul 2019 00:02:22 -0400
Message-Id: <20190719040246.15945-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: morten petersen <morten_bp@live.dk>

[ Upstream commit 25777e5784a7b417967460d4fcf9660d05a0c320 ]

Previously, if mbox_request_channel_byname was used with a name
which did not exist in the "mbox-names" property of a mailbox
client, the mailbox corresponding to the last entry in the
"mbox-names" list would be incorrectly selected.
With this patch, -EINVAL is returned if the named mailbox is
not found.

Signed-off-by: Morten Borup Petersen <morten_bp@live.dk>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 38d9df3fb199..ad79f128fbc7 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -421,11 +421,13 @@ struct mbox_chan *mbox_request_channel_byname(struct mbox_client *cl,
 
 	of_property_for_each_string(np, "mbox-names", prop, mbox_name) {
 		if (!strncmp(name, mbox_name, strlen(name)))
-			break;
+			return mbox_request_channel(cl, index);
 		index++;
 	}
 
-	return mbox_request_channel(cl, index);
+	dev_err(cl->dev, "%s() could not locate channel named \"%s\"\n",
+		__func__, name);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(mbox_request_channel_byname);
 
-- 
2.20.1

