Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7E1498E62
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348912AbiAXTk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348707AbiAXTiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A59361542;
        Mon, 24 Jan 2022 19:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F5EC340F2;
        Mon, 24 Jan 2022 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053099;
        bh=czH9XBhxjWjGG03F484H/P9l8nncul0Wz3+TzAgzUM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehIhafkHmxRnfryTpC6volZ8mozWKmFYfnfy36zIQk6IirgxG9F2tn8A2ZNwZjxjg
         u2zmLl8OoccW3c4F8gbLSbffqQCVIbHLqTZJAxDrgPPW+GPJXGiHHR8sJrXFFjRRlH
         rj4OLAfJGSqYlktX+mlXlJTgxu9WSWnZiHCdAy9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/320] power: bq25890: Enable continuous conversion for ADC at charging
Date:   Mon, 24 Jan 2022 19:43:48 +0100
Message-Id: <20220124184002.288511565@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 9d1ec8d677de6..5afe55119fe65 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -531,12 +531,12 @@ static void bq25890_handle_state_change(struct bq25890_device *bq,
 
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



