Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938E22014CA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390687AbgFSPBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390678AbgFSPBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:01:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3307B20734;
        Fri, 19 Jun 2020 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578860;
        bh=CarzX7jrFj2dLReUZB4e6YJK8BhpEudbGb6UOINdud4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ID/WVkzO0Lhuu0qtfH3sSzlToIEjH+0HORgX62Uw4y2bE8jjJKrfXsxQp1fEVjL4x
         gOPElzjNpVAGBVf0hZrJ7/Mk0EdCpT4L63Ws7PY+OSQfK0Z68Rqf1RzgLkjurNOeZb
         bddQYo5UsmIzlZUhkKu6J79c/e/4Oq9AlrgupFsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/267] wcn36xx: Fix error handling path in wcn36xx_probe()
Date:   Fri, 19 Jun 2020 16:32:20 +0200
Message-Id: <20200619141656.251971234@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a86308fc534edeceaf64670c691e17485436a4f4 ]

In case of error, 'qcom_wcnss_open_channel()' must be undone by a call to
'rpmsg_destroy_ept()', as already done in the remove function.

Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200507043619.200051-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 79998a3ddb7a..ad051f34e65b 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1341,7 +1341,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	if (addr && ret != ETH_ALEN) {
 		wcn36xx_err("invalid local-mac-address\n");
 		ret = -EINVAL;
-		goto out_wq;
+		goto out_destroy_ept;
 	} else if (addr) {
 		wcn36xx_info("mac address: %pM\n", addr);
 		SET_IEEE80211_PERM_ADDR(wcn->hw, addr);
@@ -1349,7 +1349,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
 
 	ret = wcn36xx_platform_get_resources(wcn, pdev);
 	if (ret)
-		goto out_wq;
+		goto out_destroy_ept;
 
 	wcn36xx_init_ieee80211(wcn);
 	ret = ieee80211_register_hw(wcn->hw);
@@ -1361,6 +1361,8 @@ static int wcn36xx_probe(struct platform_device *pdev)
 out_unmap:
 	iounmap(wcn->ccu_base);
 	iounmap(wcn->dxe_base);
+out_destroy_ept:
+	rpmsg_destroy_ept(wcn->smd_channel);
 out_wq:
 	ieee80211_free_hw(hw);
 out_err:
-- 
2.25.1



