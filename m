Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8996C450F5D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbhKOSaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241562AbhKOS1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:27:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CE8A6343A;
        Mon, 15 Nov 2021 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999026;
        bh=29uDwupZ7Simv5RW0dCkY4xYlIQumskuSVRP3ejNQxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKG1I3fcb26Tva4ANo6aUE69XHuevF8QXPVe3r5t3qWQTxZ38Re7Dbml5CesWLgT4
         NXgmZoBfhH0FlnWIcG8JlRx2Zl9aHJYRJUqo9ZkuRRIjJu2ee9VWhNk0pgZx3mzCii
         qYWLfCYwj4yx+gG4PoRX8EOM0oDUl4LxLR903ZdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.14 150/849] power: supply: max17042_battery: Prevent int underflow in set_soc_threshold
Date:   Mon, 15 Nov 2021 17:53:53 +0100
Message-Id: <20211115165425.214623875@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -861,7 +861,8 @@ static void max17042_set_soc_threshold(s
 	regmap_read(map, MAX17042_RepSOC, &soc);
 	soc >>= 8;
 	soc_tr = (soc + off) << 8;
-	soc_tr |= (soc - off);
+	if (off < soc)
+		soc_tr |= soc - off;
 	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
 }
 


