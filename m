Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47E9106EBF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbfKVLBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:01:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731143AbfKVLBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:01:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08D2E20706;
        Fri, 22 Nov 2019 11:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420472;
        bh=EnyyH4Gnn0E8+qOWwE4uOz6+S+a2zftDJp8SNn1mVxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG1+uI9ObOkAa67j/9auO8BXf3tc447o5HmL/37X951D5f8N3vSu19AFY1c9TrCL4
         mbtB3GvmhYiVxsFic0YjdV5aSpRFyEspL075y+slLS0wahNtutav+57Mz433rch+jc
         nNQyrhhxvfDi3iRCPn85koU9qLpz1XdLpNIABDo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/220] qtnfmac: drop error reports for out-of-bounds key indexes
Date:   Fri, 22 Nov 2019 11:28:01 +0100
Message-Id: <20191122100921.080490325@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 35da3fe63b8647ce3cc52fccdf186a60710815fb ]

On disconnect wireless core attempts to remove all the supported keys.
Following cfg80211_ops conventions, firmware returns -ENOENT code
for the out-of-bound key indexes. This is a normal behavior,
so no need to report errors for this case.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 05b93f301ca08..ff8a46c9595e1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -521,9 +521,16 @@ static int qtnf_del_key(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 
 	ret = qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
-	if (ret)
-		pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
-		       vif->mac->macid, vif->vifid, key_index, pairwise);
+	if (ret) {
+		if (ret == -ENOENT) {
+			pr_debug("VIF%u.%u: key index %d out of bounds\n",
+				 vif->mac->macid, vif->vifid, key_index);
+		} else {
+			pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
+			       vif->mac->macid, vif->vifid,
+			       key_index, pairwise);
+		}
+	}
 
 	return ret;
 }
-- 
2.20.1



