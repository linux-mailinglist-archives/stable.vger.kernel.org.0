Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F74111DFE
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfLCW65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730585AbfLCW6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61BE220866;
        Tue,  3 Dec 2019 22:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413932;
        bh=cOpTOn6Epw/sJcpdJOqtdkwi6b0HMpyZ4aSbTlCajiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS5NVQ7u6OTRbeIkDDZ6/S+7QnMJxBDiT7LB6FTAF2jePMl97k9yzQ3ATYrSkYZTr
         xxLYJ451mVJxWLXK1z4oWC6sc2Br+gyQVak1pOVEy3+Y3DEj/JXYgU8aRD7xZ9UZDm
         Y+SslbRLIEB01/LpSx2k1xU99kMeqG1fDpA3nua8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <yellowriver2010@hotmail.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 318/321] ASoC: stm32: sai: add missing put_device()
Date:   Tue,  3 Dec 2019 23:36:24 +0100
Message-Id: <20191203223443.685790572@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <yellowriver2010@hotmail.com>

commit 1c3816a194870e7a6622345dab7fb56c7d708613 upstream.

The of_find_device_by_node() takes a reference to the underlying device
structure, we should release that reference.

Fixes: 7dd0d835582f ("ASoC: stm32: sai: simplify sync modes management")
Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>
Acked-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_sai.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/soc/stm/stm32_sai.c
+++ b/sound/soc/stm/stm32_sai.c
@@ -112,16 +112,21 @@ static int stm32_sai_set_sync(struct stm
 	if (!sai_provider) {
 		dev_err(&sai_client->pdev->dev,
 			"SAI sync provider data not found\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_put_dev;
 	}
 
 	/* Configure sync client */
 	ret = stm32_sai_sync_conf_client(sai_client, synci);
 	if (ret < 0)
-		return ret;
+		goto out_put_dev;
 
 	/* Configure sync provider */
-	return stm32_sai_sync_conf_provider(sai_provider, synco);
+	ret = stm32_sai_sync_conf_provider(sai_provider, synco);
+
+out_put_dev:
+	put_device(&pdev->dev);
+	return ret;
 }
 
 static int stm32_sai_probe(struct platform_device *pdev)


