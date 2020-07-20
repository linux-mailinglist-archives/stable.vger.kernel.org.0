Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE45226AD8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgGTPwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgGTPv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B578722D00;
        Mon, 20 Jul 2020 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260319;
        bh=CiWAgRrFMF6AkD5NScixcAhor2EXs7j+HVkZRczmRzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koVZ9omFAaD5WzC+WLgcqE9rat2tT/zmJOpZT/Vu4U2yB1PixJONGz5TprdrdbjkI
         TJgIMxnfU+osE5DNkSEEb+5BMuVxEOMbipkYeYxGysAIp3PsyLlxKyfw7VDPTB5kOZ
         ItpcPasIDBAcnGcrY2owH6PjyAMsWjxIrXl0mxQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/133] phy: sun4i-usb: fix dereference of pointer phy0 before it is null checked
Date:   Mon, 20 Jul 2020 17:36:46 +0200
Message-Id: <20200720152806.580399911@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
index 1f8809bab002c..920f61eff9cd4 100644
--- a/drivers/phy/allwinner/phy-sun4i-usb.c
+++ b/drivers/phy/allwinner/phy-sun4i-usb.c
@@ -550,13 +550,14 @@ static void sun4i_usb_phy0_id_vbus_det_scan(struct work_struct *work)
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



