Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398136DD83
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfGSEXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387982AbfGSEKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:10:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E24218B6;
        Fri, 19 Jul 2019 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509419;
        bh=EC+R/IWz9lMvvkhtV6ReCvhVyoTRgMYn0JYsA9ZNY4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBeFWLzEEXd5KUW3uS4xN+/TP4e5mSFZeiH1kPSicW3FiDejdQffgfS61kQSPoaMz
         XdFF2wysD7ZASZlCtBL4Cxw+EuapdsvpU9euXMadQPwilgy512ayuG/YFypDOebEqV
         JY0LYyKx8nDxeHho4CCqiGGLpAN6ZxKS07mNI2CA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     morten petersen <morten_bp@live.dk>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 082/101] mailbox: handle failed named mailbox channel request
Date:   Fri, 19 Jul 2019 00:07:13 -0400
Message-Id: <20190719040732.17285-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
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
index 674b35f402f5..055c90b8253c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -391,11 +391,13 @@ struct mbox_chan *mbox_request_channel_byname(struct mbox_client *cl,
 
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

