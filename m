Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B851461EFF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379893AbhK2Sme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45612 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379894AbhK2Sk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C777B815C3;
        Mon, 29 Nov 2021 18:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65836C53FAD;
        Mon, 29 Nov 2021 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211025;
        bh=afdACg28FIlsepRd+qfx5tuSf75ZK0A+Bn8eG7/lbjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIj9N1/lTVfONXxXi+ZjtxUpbP8tqQeyUysaqlFJ7pL5iTD13P4XCt22Ar/ue4jlZ
         SrFGWczSiXv/fYNxA4SOB3yQO9ApqcQPiaR+uc4SqNOw46Y839p7LHAk9/wPMNTaGQ
         Y1IRTAoRp2YpcWJmoxyTKWF07PomR7zapHXIvXoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/179] ASoC: codecs: wcd938x: fix volatile register range
Date:   Mon, 29 Nov 2021 19:17:51 +0100
Message-Id: <20211129181721.486270516@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit ea157c2ba821dab789a544cd9fbe44dc07036ff8 ]

Interrupt Clear registers WCD938X_INTR_CLEAR_0 -  WCD938X_INTR_CLEAR_2
are not marked as volatile. This has resulted in a missing interrupt bug
while performing runtime pm. regcache_sync() during runtime pm resume path
will write to Interrupt clear registers with previous values which basically
clears the pending interrupt and actual interrupt handler never sees this
interrupt.

This issue is more visible with headset plug-in plug-out case compared to
headset button.

Fix this by adding the Interrupt clear registers to volatile range

Fixes: 8d78602aa87a ("ASoC: codecs: wcd938x: add basic driver")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114623.11891-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 52de7d14b1398..67151c7770c65 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -1174,6 +1174,9 @@ static bool wcd938x_readonly_register(struct device *dev, unsigned int reg)
 	case WCD938X_DIGITAL_INTR_STATUS_0:
 	case WCD938X_DIGITAL_INTR_STATUS_1:
 	case WCD938X_DIGITAL_INTR_STATUS_2:
+	case WCD938X_DIGITAL_INTR_CLEAR_0:
+	case WCD938X_DIGITAL_INTR_CLEAR_1:
+	case WCD938X_DIGITAL_INTR_CLEAR_2:
 	case WCD938X_DIGITAL_SWR_HM_TEST_0:
 	case WCD938X_DIGITAL_SWR_HM_TEST_1:
 	case WCD938X_DIGITAL_EFUSE_T_DATA_0:
-- 
2.33.0



