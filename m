Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB145BCC6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243149AbhKXMcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344164AbhKXMag (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4A461357;
        Wed, 24 Nov 2021 12:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756338;
        bh=Z21uXDc1DuDB4PRAlDpt8PcbtMN24Ym+qp/ljDs9LT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pd0PNbndbmSnwrx2egXtx2jGE4BiukG+yUuazpoAiaU5RqzukAnPtJV7vhYMzLqt1
         jOBn1+DkXzk4HrTDB47XnwX+XGfe97djAG4T1DDJk4G0/xdd/j04c8jyCV11dwM/RT
         T1N43yP4uijEfjBNgtj1ezhLOdXUJxW901iLFoD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.14 051/251] power: supply: max17042_battery: Prevent int underflow in set_soc_threshold
Date:   Wed, 24 Nov 2021 12:54:53 +0100
Message-Id: <20211124115712.026307984@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
@@ -825,7 +825,8 @@ static void max17042_set_soc_threshold(s
 	regmap_read(map, MAX17042_RepSOC, &soc);
 	soc >>= 8;
 	soc_tr = (soc + off) << 8;
-	soc_tr |= (soc - off);
+	if (off < soc)
+		soc_tr |= soc - off;
 	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
 }
 


