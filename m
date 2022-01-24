Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EFA498951
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbiAXSyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:54:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343945AbiAXSws (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:52:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848826151A;
        Mon, 24 Jan 2022 18:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6B1C340E5;
        Mon, 24 Jan 2022 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050366;
        bh=tiEztUcTC2j5P794DPJgbNB59Cy+LICX+yJmsLn7KSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmNllmtrGRMIiydKpk4pDD0pFJL+VSlTygyOEFQbeffhRa69ouxt20M9c/CDCBVVr
         OcyqV6qU+tnKlnu2dRTZEZ8PZK8EaOs9RrhsRZxr4yLVKl7rBVityjQ3RMuaoB7p4O
         V/VABxsBO2gdz4iQXrJhgMneSbnlLypYDPXYM19k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 096/114] power: bq25890: Enable continuous conversion for ADC at charging
Date:   Mon, 24 Jan 2022 19:43:11 +0100
Message-Id: <20220124183930.077354285@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
 drivers/power/bq25890_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq25890_charger.c b/drivers/power/bq25890_charger.c
index f993a55cde20f..faf2a62435674 100644
--- a/drivers/power/bq25890_charger.c
+++ b/drivers/power/bq25890_charger.c
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



