Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7BF12C578
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbfL2RgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbfL2RgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:36:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDA0207FF;
        Sun, 29 Dec 2019 17:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640972;
        bh=K2C6IWr4EBzuin7+AWj1Jnxey2syn/dls7BFI53OCrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2pj4hJDG+rZvGMeMDNDIuDcwYc7TsWF09e89TyUzL36zCrWc7E9Ob0lyhWtV4b9b
         VOAKENJeGvZRgwxFOYd2DdXBu0Eo2u/aIDCf7jCai7FhL9wYFmGJLh4qSNmQMQdQWQ
         vsux0WG2GOA+b0ArSoa6t3kNbxvoRQ0zWtVUhKD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/219] brcmfmac: remove monitor interface when detaching
Date:   Sun, 29 Dec 2019 18:19:38 +0100
Message-Id: <20191229162535.478953369@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 4f61563da075bc8faefddfd5f8fc0cc14c49650a ]

This fixes a minor WARNING in the cfg80211:
[  130.658034] ------------[ cut here ]------------
[  130.662805] WARNING: CPU: 1 PID: 610 at net/wireless/core.c:954 wiphy_unregister+0xb4/0x198 [cfg80211]

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 0f56be13c7ad..584e05fdca6a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1246,6 +1246,11 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_proto_detach_pre_delif(drvr);
 
+	if (drvr->mon_if) {
+		brcmf_net_detach(drvr->mon_if->ndev, false);
+		drvr->mon_if = NULL;
+	}
+
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
 		brcmf_remove_interface(drvr->iflist[i], false);
-- 
2.20.1



