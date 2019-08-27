Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191869E00C
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfH0H77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730721AbfH0H76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96000206BF;
        Tue, 27 Aug 2019 07:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892798;
        bh=xaWelcPPqQjbYJIjD9T+FNUz1VwcHbQUGS4SZ6Jrn34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by+3g0AVvko/BkS5XeOY8g6FmqPaStwwz5kbCTY+Qe3m80xh3+uXVLcPd8OfW+Rat
         q5ocLrY3NV1ITVakGX0rc7i8tu6JwtdrCtCLlxTgXRgmLyqmaX0ObsR+uQJ9PO4Ybc
         7wUgpbTFaLJL0GBtElxWBAdlrCbY13rfXIw8FpJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 008/162] regulator: axp20x: fix DCDC5 and DCDC6 for AXP803
Date:   Tue, 27 Aug 2019 09:48:56 +0200
Message-Id: <20190827072738.559612488@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8f46e22b5ac692b48d04bb722547ca17b66dda02 ]

Refactoring of axp20x driver introduced a bug in AXP803's DCDC6
regulator definition. AXP803_DCDC6_1120mV_STEPS was obtained by
subtracting 0x47 and 0x33. This should be 0x14 (hex) and not 14
(dec).

Refactoring also carried over a bug in DCDC5 regulator definition.
Number of possible voltages must be for 1 bigger than maximum valid
voltage index, because 0 is also valid and it means lowest voltage.

Fixes: 1dbe0ccb0631 ("regulator: axp20x-regulator: add support for AXP803")
Fixes: db4a555f7c4c ("regulator: axp20x: use defines for masks")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20190713090717.347-3-jernej.skrabec@siol.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index c951568994a11..989506bd90b19 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -174,14 +174,14 @@
 #define AXP803_DCDC5_1140mV_STEPS	35
 #define AXP803_DCDC5_1140mV_END		\
 	(AXP803_DCDC5_1140mV_START + AXP803_DCDC5_1140mV_STEPS)
-#define AXP803_DCDC5_NUM_VOLTAGES	68
+#define AXP803_DCDC5_NUM_VOLTAGES	69
 
 #define AXP803_DCDC6_600mV_START	0x00
 #define AXP803_DCDC6_600mV_STEPS	50
 #define AXP803_DCDC6_600mV_END		\
 	(AXP803_DCDC6_600mV_START + AXP803_DCDC6_600mV_STEPS)
 #define AXP803_DCDC6_1120mV_START	0x33
-#define AXP803_DCDC6_1120mV_STEPS	14
+#define AXP803_DCDC6_1120mV_STEPS	20
 #define AXP803_DCDC6_1120mV_END		\
 	(AXP803_DCDC6_1120mV_START + AXP803_DCDC6_1120mV_STEPS)
 #define AXP803_DCDC6_NUM_VOLTAGES	72
-- 
2.20.1



