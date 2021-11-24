Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC4145BF69
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347007AbhKXM5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345293AbhKXMzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:55:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DE9061372;
        Wed, 24 Nov 2021 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757120;
        bh=lJjvbzuSA+9OIfeS9+MlFxe3LibsCphUyYHM5VmS0aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpmNJzUXzT5lDFWgrdYKJNpTtBjc1xmW/hXA1C2c8ySk9KdvHrUlODbErrY6TX8n2
         rnEpQztalPSEfsWTkhfG9/d+zwdq26pjAK6Mav4kgCQbcK3bbXtlR2kvuAl8E5zE8t
         VAzDMJIcH1454HHpT9u12iwuMYk4Xh7X5l6n6x0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 065/323] power: supply: max17042_battery: Prevent int underflow in set_soc_threshold
Date:   Wed, 24 Nov 2021 12:54:15 +0100
Message-Id: <20211124115721.053792872@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -848,7 +848,8 @@ static void max17042_set_soc_threshold(s
 	regmap_read(map, MAX17042_RepSOC, &soc);
 	soc >>= 8;
 	soc_tr = (soc + off) << 8;
-	soc_tr |= (soc - off);
+	if (off < soc)
+		soc_tr |= soc - off;
 	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
 }
 


