Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC6CA98A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbfJCQoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404781AbfJCQoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:44:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99BDE2054F;
        Thu,  3 Oct 2019 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121044;
        bh=LYIbF59LRkqGRsnLtIcvlgJlu1D6vqFSlyn1nFHtP2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLZ1pGcBmhoF9yLNsC45NxxENr3vXP+xCeui17DEWIAIGJ4g+/H0xFF4srspBuz5N
         R1UMg7Ij4rA3WMhUTRLdH4H4oF0qdTVVKbaGZwNlGMGf4QtZzxFs/UwOZRg8f2+Q+N
         w34e0/vx0wYbkGkeS/z5S5lmQHVyv0ztvPSRYfss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 106/344] media: mtk-mdp: fix reference count on old device tree
Date:   Thu,  3 Oct 2019 17:51:11 +0200
Message-Id: <20191003154550.692726688@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

[ Upstream commit 864919ea0380e62adb2503b89825fe358acb8216 ]

of_get_next_child() increments the reference count of the returning
device_node. Decrement it in the check if we are using the old or the
new DTB.

Fixes: ba1f1f70c2c0 ("[media] media: mtk-mdp: Fix mdp device tree")
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Acked-by: Houlong Wei <houlong.wei@mediatek.com>
[hverkuil-cisco@xs4all.nl: use node instead of parent as temp variable]
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index fc9faec85edb6..5d44f2e92dd50 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -110,7 +110,9 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 	mutex_init(&mdp->vpulock);
 
 	/* Old dts had the components as child nodes */
-	if (of_get_next_child(dev->of_node, NULL)) {
+	node = of_get_next_child(dev->of_node, NULL);
+	if (node) {
+		of_node_put(node);
 		parent = dev->of_node;
 		dev_warn(dev, "device tree is out of date\n");
 	} else {
-- 
2.20.1



