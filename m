Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4C73EB0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbfGXTgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388478AbfGXTgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:36:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 817F8214AF;
        Wed, 24 Jul 2019 19:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997008;
        bh=+mBgDTHX626pF5vBCtD6RPqgeKtvu0Nlkai0i99PfMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRZM3P1G6S8k8d3gizVZ4Iyv9xu+pQdMe2ObHwFbw1MJE0XaS7M4bQ0g/cmE6ey8F
         XIBsAsQGCJ8n8jclRATO+CKo5ML8uV17q4WJaIDIgBiEm6kRYRlk7AD2OvPdigMhPF
         bl3ntI/YhQAC0KbZkVLEYJpJry+TzBvH23FJbmvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.2 290/413] regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup failure
Date:   Wed, 24 Jul 2019 21:19:41 +0200
Message-Id: <20190724191756.978272502@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 70ca117b02f3b1c8830fe95e4e3dea2937038e11 upstream.

If devm_gpiod_get_from_of_node() call returns ERR_PTR, it is assigned
into an array of GPIO descriptors and used later because such error is
not treated as critical thus it is not propagated back to the probe
function.

All code later expects that such GPIO descriptor is either a NULL or
proper value.  This later might lead to dereference of ERR_PTR.

Only devices with S2MPS14 flavor are affected (other do not control
regulators with GPIOs).

Fixes: 1c984942f0a4 ("regulator: s2mps11: Pass descriptor instead of GPIO number")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/s2mps11.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -826,6 +826,7 @@ static void s2mps14_pmic_dt_parse_ext_co
 		else if (IS_ERR(gpio[reg])) {
 			dev_err(&pdev->dev, "Failed to get control GPIO for %d/%s\n",
 				reg, rdata[reg].name);
+			gpio[reg] = NULL;
 			continue;
 		}
 		if (gpio[reg])


