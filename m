Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ADC226615
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbgGTQAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:32992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731840AbgGTQAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3063020773;
        Mon, 20 Jul 2020 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260807;
        bh=61N1JrhVoGC69lHR01/ihGSNnZtEraMQ42MzNixm1v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNxU4OOFhBoc77wH8MIlYyaHlb7Gywr6EoZE62gWG2SQRUNzxarBQtQ6kYYvcEWiH
         u273Me6HDVw6lLz7VGKNTVpYwj9z30sgy1tErnJf10sklTjnTFHTbT+QMIRzBSqxkU
         7A8FTgSwv5XYD8hAXHCyOKm20f1eUMTic+kCKpiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/215] phy: sun4i-usb: fix dereference of pointer phy0 before it is null checked
Date:   Mon, 20 Jul 2020 17:36:18 +0200
Message-Id: <20200720152824.777983859@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 38b1927e5bf9bcad4a2e33189ef1c5569f9599ba ]

Currently pointer phy0 is being dereferenced via the assignment of
phy on the call to phy_get_drvdata before phy0 is null checked, this
can lead to a null pointer dereference. Fix this by performing the
null check on phy0 before the call to phy_get_drvdata. Also replace
the phy0 == NULL check with the more usual !phy0 idiom.

Addresses-Coverity: ("Dereference before null check")
Fixes: e6f32efb1b12 ("phy: sun4i-usb: Make sure to disable PHY0 passby for peripheral mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200625124428.83564-1-colin.king@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/allwinner/phy-sun4i-usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
index 8569273822487..e5842e48a5e07 100644
--- a/drivers/phy/allwinner/phy-sun4i-usb.c
+++ b/drivers/phy/allwinner/phy-sun4i-usb.c
@@ -545,13 +545,14 @@ static void sun4i_usb_phy0_id_vbus_det_scan(struct work_struct *work)
 	struct sun4i_usb_phy_data *data =
 		container_of(work, struct sun4i_usb_phy_data, detect.work);
 	struct phy *phy0 = data->phys[0].phy;
-	struct sun4i_usb_phy *phy = phy_get_drvdata(phy0);
+	struct sun4i_usb_phy *phy;
 	bool force_session_end, id_notify = false, vbus_notify = false;
 	int id_det, vbus_det;
 
-	if (phy0 == NULL)
+	if (!phy0)
 		return;
 
+	phy = phy_get_drvdata(phy0);
 	id_det = sun4i_usb_phy0_get_id_det(data);
 	vbus_det = sun4i_usb_phy0_get_vbus_det(data);
 
-- 
2.25.1



