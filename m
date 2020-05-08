Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9045F1CACD4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgEHM4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730162AbgEHM4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:56:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 627C7218AC;
        Fri,  8 May 2020 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942574;
        bh=O5FR41JTbKq16AdmkKYLVI7ggdGMxpluv76/vMSoG50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0/l1NSDxDO7Yz3wV1azycuAj/oyFK+4vXJLt5gLcmQdymM/DPgTVE+eGfiKJ8FAB
         PYPAcY6l2w71lhKJXjzSuG4r+YI0HK5xpVvHtLZKUXhSO16nNKyoQV3hihTTYa0dua
         PJ8Xqttq5P4AvBi1j3woyxka7bZ46+bM+AnPoM2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 22/49] remoteproc: qcom_q6v5_mss: fix a bug in q6v5_probe()
Date:   Fri,  8 May 2020 14:35:39 +0200
Message-Id: <20200508123046.099775269@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 13c060b50a341dd60303e5264d12108b5747f200 ]

If looking up the DT "firmware-name" property fails in q6v6_probe(),
the function returns without freeing the remoteproc structure
that has been allocated.  Fix this by jumping to the free_rproc
label, which takes care of this.

Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20200403175005.17130-3-elder@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 0b1d737b0e97d..8844fc56c5f6d 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1607,7 +1607,7 @@ static int q6v5_probe(struct platform_device *pdev)
 	ret = of_property_read_string_index(pdev->dev.of_node, "firmware-name",
 					    1, &qproc->hexagon_mdt_image);
 	if (ret < 0 && ret != -EINVAL)
-		return ret;
+		goto free_rproc;
 
 	platform_set_drvdata(pdev, qproc);
 
-- 
2.20.1



