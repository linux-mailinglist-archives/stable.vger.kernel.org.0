Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568E63A62EB
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhFNLGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235118AbhFNLEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C096261408;
        Mon, 14 Jun 2021 10:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667494;
        bh=GVzGZgoNbDlNANypM7xWU77ZalK+MFILsGcxNreyzhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJGQaIX2qUKUKgnO3fsiDFIZ/QsG0Z8amwv43mywbLJsnEd1ebaSI+sjYg7nKBz9t
         +UvyI6AnPODtP1fFcSoKl1ZP3W+LdLRz+zZGibGFenB3zVSQ0DxS7zOppbi/6r4Fo5
         LgL+jiqYic/CUwfMz8bDiEqsaAxC3UfcaYeiAnwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 094/131] regulator: bd71828: Fix .n_voltages settings
Date:   Mon, 14 Jun 2021 12:27:35 +0200
Message-Id: <20210614102656.191504304@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 4c668630bf8ea90a041fc69c9984486e0f56682d upstream.

Current .n_voltages settings do not cover the latest 2 valid selectors,
so it fails to set voltage for the hightest voltage support.
The latest linear range has step_uV = 0, so it does not matter if we
count the .n_voltages to maximum selector + 1 or the first selector of
latest linear range + 1.
To simplify calculating the n_voltages, let's just set the
.n_voltages to maximum selector + 1.

Fixes: 522498f8cb8c ("regulator: bd71828: Basic support for ROHM bd71828 PMIC regulators")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20210523071045.2168904-2-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mfd/rohm-bd71828.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mfd/rohm-bd71828.h
+++ b/include/linux/mfd/rohm-bd71828.h
@@ -26,11 +26,11 @@ enum {
 	BD71828_REGULATOR_AMOUNT,
 };
 
-#define BD71828_BUCK1267_VOLTS		0xEF
-#define BD71828_BUCK3_VOLTS		0x10
-#define BD71828_BUCK4_VOLTS		0x20
-#define BD71828_BUCK5_VOLTS		0x10
-#define BD71828_LDO_VOLTS		0x32
+#define BD71828_BUCK1267_VOLTS		0x100
+#define BD71828_BUCK3_VOLTS		0x20
+#define BD71828_BUCK4_VOLTS		0x40
+#define BD71828_BUCK5_VOLTS		0x20
+#define BD71828_LDO_VOLTS		0x40
 /* LDO6 is fixed 1.8V voltage */
 #define BD71828_LDO_6_VOLTAGE		1800000
 


