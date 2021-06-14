Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A213A643B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhFNLWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236006AbhFNLUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE40A6146E;
        Mon, 14 Jun 2021 10:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667901;
        bh=80xPTjGxB3oWK8U4ReXEVcVbGqODO2pmNPNUiJ8o5bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luvIYLRJ04Fv151u0YX3ztNNSbHiJAphSaPMCA9uf6/QreDKxiNm9lJlWorT12CRw
         e7vIityHygyjdH61YtlTocJ30edNIjsA8aQdLays6qqQhMDlq9iEQoot1ovsxWAr3D
         KYcwqjrDfuLPFo+56MKENdi3tniVtU782smcvPRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 118/173] regulator: fixed: Ensure enable_counter is correct if reg_domain_disable fails
Date:   Mon, 14 Jun 2021 12:27:30 +0200
Message-Id: <20210614102702.091459873@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 855bfff9d623e7aff6556bfb6831d324dec8d96a upstream.

dev_pm_genpd_set_performance_state() may fail, so had better to check it's
return value before decreasing priv->enable_counter.

Fixes: bf3a28cf4241 ("regulator: fixed: support using power domain for enable/disable")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210520111811.1806293-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/fixed.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -88,10 +88,15 @@ static int reg_domain_disable(struct reg
 {
 	struct fixed_voltage_data *priv = rdev_get_drvdata(rdev);
 	struct device *dev = rdev->dev.parent;
+	int ret;
+
+	ret = dev_pm_genpd_set_performance_state(dev, 0);
+	if (ret)
+		return ret;
 
 	priv->enable_counter--;
 
-	return dev_pm_genpd_set_performance_state(dev, 0);
+	return 0;
 }
 
 static int reg_is_enabled(struct regulator_dev *rdev)


