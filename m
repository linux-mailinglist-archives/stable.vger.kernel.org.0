Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EB8450AF6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbhKORQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236911AbhKORO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:14:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C062363238;
        Mon, 15 Nov 2021 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996298;
        bh=oGJLf83O6OzUpdaQ1v2eWXUAolQuONopokAhlzDmSQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSodtPDbMGIgbNowZxRa1/W4qV2P2AhGWYdjN5xDAFjstNPsoUYEbgefiDlEo/J0F
         e8YM3abk/pe8cGwllUzuHuubdqV7IheR/3OSoU79Lx82ceWqZVzdtoqrB+UmwulR6V
         IQ3Ng+UTlIY10CuwhYU5uhEl6kV0qWWcAwf0kFws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 088/355] power: supply: max17042_battery: Prevent int underflow in set_soc_threshold
Date:   Mon, 15 Nov 2021 18:00:12 +0100
Message-Id: <20211115165316.649551756@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

commit e660dbb68c6b3f7b9eb8b9775846a44f9798b719 upstream.

max17042_set_soc_threshold gets called with offset set to 1, which means
that minimum threshold value would underflow once SOC got down to 0,
causing invalid alerts from the gauge.

Fixes: e5f3872d2044 ("max17042: Add support for signalling change in SOC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -834,7 +834,8 @@ static void max17042_set_soc_threshold(s
 	regmap_read(map, MAX17042_RepSOC, &soc);
 	soc >>= 8;
 	soc_tr = (soc + off) << 8;
-	soc_tr |= (soc - off);
+	if (off < soc)
+		soc_tr |= soc - off;
 	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
 }
 


