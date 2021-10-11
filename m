Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE17A429026
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhJKOFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239901AbhJKODj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:03:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C329610C8;
        Mon, 11 Oct 2021 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960717;
        bh=GMhc6I8DDQgc0a7x2KGDJiQjriPSHBRYhxMh2YNidh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bch7Rg7sKyEefCWOonG/Tk/ZX2O6Ndd8+pXYG1l+4qIn1j+UJBwGcYEa3Jnh0e0ZK
         KykWdLA47sFZ1R1QV1msIvb5eL9qTs7sVcvrUowrSxIvgvt1vexVGSOHfwG9JdXxZ8
         Cl/MeyiW57PPC54tbG5zU1cR7mtSJ3lOXJLLA1m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Martorana <amartora@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 037/151] soc: qcom: socinfo: Fixed argument passed to platform_set_data()
Date:   Mon, 11 Oct 2021 15:45:09 +0200
Message-Id: <20211011134519.046785097@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index b2f049faa3df..a6cffd57d3c7 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -628,7 +628,7 @@ static int qcom_socinfo_probe(struct platform_device *pdev)
 	/* Feed the soc specific unique data into entropy pool */
 	add_device_randomness(info, item_size);
 
-	platform_set_drvdata(pdev, qs->soc_dev);
+	platform_set_drvdata(pdev, qs);
 
 	return 0;
 }
-- 
2.33.0



