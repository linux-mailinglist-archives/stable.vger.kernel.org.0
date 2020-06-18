Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371C51FE667
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgFRBOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbgFRBOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C682221EB;
        Thu, 18 Jun 2020 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442887;
        bh=3cZhsds1xAGMTrCeTPwU+J8P0xv9FZcUGrImlkxCbp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Pw2TaYMepsbLO05ZlObXJ0jUIlT2u6PIXpoNXmhtaE+h0rVQ4T16dwtABoid8HxT
         Jyn1BqF8cSS+GqwwBgHINpwgrojB09MEJiagkLFWGKyZ+ERIj3WLbt6NmIXRWchxzh
         LfiojwoiF4FF7bW+8s3B3k6qn8FWjQuWELb7aqhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 310/388] mailbox: imx: Fix return in imx_mu_scu_xlate()
Date:   Wed, 17 Jun 2020 21:06:47 -0400
Message-Id: <20200618010805.600873-310-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1b3a347b7d56aa637157da1b7df225071af1421f ]

This called from mbox_request_channel().  The caller is  expecting error
pointers and not NULL so this "return NULL;" will lead to an Oops.

Fixes: 0a67003b1985 ("mailbox: imx: add SCU MU support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 7906624a731c..9d6f0217077b 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -374,7 +374,7 @@ static struct mbox_chan *imx_mu_scu_xlate(struct mbox_controller *mbox,
 		break;
 	default:
 		dev_err(mbox->dev, "Invalid chan type: %d\n", type);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (chan >= mbox->num_chans) {
-- 
2.25.1

