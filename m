Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1B498B5A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346907AbiAXTM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345148AbiAXTLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB21B81233;
        Mon, 24 Jan 2022 19:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A115C340E5;
        Mon, 24 Jan 2022 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051492;
        bh=AXv0bhwDFHYDlHSaMxBSRFCsCriGi5RSJxtkFLs0kwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyLTs/s1knjfeW2UOCGNfMvjuyVN8WtOfjStxTBrM+6cj+uLnkmwxbiWA8kEYY4UF
         FB0xV99oLmDjtVJJas0YHOzZGb6t+SA76RCcR4RlkQfBAdSoJb0hVm9DJHddKabjIi
         SoEwq1Xy7wqP8aL993AnDLbuNmqhVzFRui54Yeog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 147/186] power: bq25890: Enable continuous conversion for ADC at charging
Date:   Mon, 24 Jan 2022 19:43:42 +0100
Message-Id: <20220124183941.832765733@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yauhen Kharuzhy <jekhor@gmail.com>

[ Upstream commit 80211be1b9dec04cc2805d3d81e2091ecac289a1 ]

Instead of one shot run of ADC at beginning of charging, run continuous
conversion to ensure that all charging-related values are monitored
properly (input voltage, input current, themperature etc.).

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 8e2c41ded171c..e90253b3f6561 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -521,12 +521,12 @@ static void bq25890_handle_state_change(struct bq25890_device *bq,
 
 	if (!new_state->online) {			     /* power removed */
 		/* disable ADC */
-		ret = bq25890_field_write(bq, F_CONV_START, 0);
+		ret = bq25890_field_write(bq, F_CONV_RATE, 0);
 		if (ret < 0)
 			goto error;
 	} else if (!old_state.online) {			    /* power inserted */
 		/* enable ADC, to have control of charge current/voltage */
-		ret = bq25890_field_write(bq, F_CONV_START, 1);
+		ret = bq25890_field_write(bq, F_CONV_RATE, 1);
 		if (ret < 0)
 			goto error;
 	}
-- 
2.34.1



