Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049BF4891F2
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbiAJHhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34018 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiAJHdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3578FB81215;
        Mon, 10 Jan 2022 07:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A622C36AE9;
        Mon, 10 Jan 2022 07:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800014;
        bh=o+k6N9U2JrIm38Mm1wYeA64g57JqPN9hKHTLzztN/EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGRrSGQLJE2XZOAlL8Sy1yWpbM59Ofq8EsE/kWLe8o28VlsCrZFUAiUZWjnxBakYh
         vPLZAv6rjfSBsZaJrL9liT8kN1HywGzG+H+yeG+5OwDstsgJ6fvr0MKsNPjE+bfpRA
         NRlIdYl4NaR8oT4SU5d5h5IvMmIzakX/lqOJ6g3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 50/72] power: bq25890: Enable continuous conversion for ADC at charging
Date:   Mon, 10 Jan 2022 08:23:27 +0100
Message-Id: <20220110071823.241410554@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yauhen Kharuzhy <jekhor@gmail.com>

commit 80211be1b9dec04cc2805d3d81e2091ecac289a1 upstream.

Instead of one shot run of ADC at beginning of charging, run continuous
conversion to ensure that all charging-related values are monitored
properly (input voltage, input current, themperature etc.).

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq25890_charger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -581,12 +581,12 @@ static irqreturn_t __bq25890_handle_irq(
 
 	if (!new_state.online && bq->state.online) {	    /* power removed */
 		/* disable ADC */
-		ret = bq25890_field_write(bq, F_CONV_START, 0);
+		ret = bq25890_field_write(bq, F_CONV_RATE, 0);
 		if (ret < 0)
 			goto error;
 	} else if (new_state.online && !bq->state.online) { /* power inserted */
 		/* enable ADC, to have control of charge current/voltage */
-		ret = bq25890_field_write(bq, F_CONV_START, 1);
+		ret = bq25890_field_write(bq, F_CONV_RATE, 1);
 		if (ret < 0)
 			goto error;
 	}


