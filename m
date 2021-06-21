Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD53AEE95
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhFUQaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232354AbhFUQ3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEBE4613F7;
        Mon, 21 Jun 2021 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292645;
        bh=O2XPWVWlhWU/2tR7FC3Y/YzLoTfXutzXfOlO4TyzjLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsYdW4rX/zieSwFXGh1NtzX6qwE0TeaB2gfeCgg50SKQ6cVl483NzQkrjyRxKCbc/
         GFj7bmzFpOlYMAKZnV18dIXR3AP/1qNNdUfkx2uWSTF9XXmGLZoQ2WsgJlnJs0Jqxr
         D4uKmPDTbw8bEnmPXXx5Akb75amj6Sn6tR/cvdvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/146] regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting
Date:   Mon, 21 Jun 2021 18:15:06 +0200
Message-Id: <20210621154915.758899763@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 0514582a1a5b4ac1a3fd64792826d392d7ae9ddc ]

The valid selectors for bd70528 bucks are 0 ~ 0xf, so the .n_voltages
should be 16 (0x10). Use 0x10 to make it consistent with BD70528_LDO_VOLTS.
Also remove redundant defines for BD70528_BUCK_VOLTS.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20210523071045.2168904-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/rohm-bd70528.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/mfd/rohm-bd70528.h b/include/linux/mfd/rohm-bd70528.h
index a57af878fd0c..4a5966475a35 100644
--- a/include/linux/mfd/rohm-bd70528.h
+++ b/include/linux/mfd/rohm-bd70528.h
@@ -26,9 +26,7 @@ struct bd70528_data {
 	struct mutex rtc_timer_lock;
 };
 
-#define BD70528_BUCK_VOLTS 17
-#define BD70528_BUCK_VOLTS 17
-#define BD70528_BUCK_VOLTS 17
+#define BD70528_BUCK_VOLTS 0x10
 #define BD70528_LDO_VOLTS 0x20
 
 #define BD70528_REG_BUCK1_EN	0x0F
-- 
2.30.2



