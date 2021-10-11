Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F84428F26
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhJKNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237535AbhJKNxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F31160C49;
        Mon, 11 Oct 2021 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960294;
        bh=NfUNsgt+VZMmzCIjLXLbWZAAS/BhC6Mm2YmrfctCi2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nbw82ilj4j/WkMkk7+EOV2Pn6CE12UwUzIJuAC4QDEJV+iEGPMYoGw2wAL8n/JhQg
         Ikrlc9WGbdzCfpUT2qauEusXkpWH96vEncycQCkm5zyXs7L9InjgzaagNMY0vOfu1s
         9OQ/IFbN0qfJso1+TRNK0ufNjTV2aqxrRcgAcGXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Martorana <amartora@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/83] soc: qcom: socinfo: Fixed argument passed to platform_set_data()
Date:   Mon, 11 Oct 2021 15:45:42 +0200
Message-Id: <20211011134509.128878036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Martorana <amartora@codeaurora.org>

[ Upstream commit 9c5a4ec69bbf5951f84ada9e0db9c6c50de61808 ]

Set qcom_socinfo pointer as data being stored instead of pointer
to soc_device structure. Aligns with future calls to platform_get_data()
which expects qcom_socinfo pointer.

Fixes: efb448d0a3fc ("soc: qcom: Add socinfo driver")
Signed-off-by: Antonio Martorana <amartora@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1629159879-95777-1-git-send-email-amartora@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index e0620416e574..60c82dcaa8d1 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -521,7 +521,7 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
 	/* Feed the soc specific unique data into entropy pool */
 	add_device_randomness(info, item_size);
 
-	platform_set_drvdata(pdev, qs->soc_dev);
+	platform_set_drvdata(pdev, qs);
 
 	return 0;
 }
-- 
2.33.0



