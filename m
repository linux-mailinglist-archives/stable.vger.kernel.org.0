Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18977F141
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404009AbfHBJfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbfHBJfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:35:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC07721773;
        Fri,  2 Aug 2019 09:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738550;
        bh=OUGUO0e+lXuz6UbyOXgjAs7U4He5TLLHmXXW2HhV4Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSQxtKIvF6Ssjjn0xqYf6UKwjD7Fyrn8F8Hu+kz1pnqQM6h5pEYHDw3mz5lP42khH
         WJx2yUTCEt+VfWbqfvWNq1j9wx6+EuYWC/F5+XPqQDCvqu+5hpPrWj+COnXkdrHqyz
         jnNec+BHWSN7qVkiylZoTNcFNDhRy77FxmHZu/HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Morten Borup Petersen <morten_bp@live.dk>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 131/158] mailbox: handle failed named mailbox channel request
Date:   Fri,  2 Aug 2019 11:29:12 +0200
Message-Id: <20190802092230.058902630@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 9cf826df89b1..b4ad85251cf7 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -389,11 +389,13 @@ struct mbox_chan *mbox_request_channel_byname(struct mbox_client *cl,
 
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



