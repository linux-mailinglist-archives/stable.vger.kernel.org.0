Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065761576C8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgBJMzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgBJMlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:49 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B229B2080C;
        Mon, 10 Feb 2020 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338508;
        bh=EoklstDWNnn2rWz0l7oezB9IjLDwq59jnrNWLRfUkFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/TGU23ZwtTK2L9YPJhG6cfR8RhGmg12oX+soGsU1pS7Ty8TSV+ZqBcgz34dpFG2a
         VHSMQzrU0RiNEWI+tE5zhyOsev0rdNZqDB8r2rQHOcn4wrHJZPDM4RSc46KH9kCD36
         /G3LD7ORCluAUT7icZxulTTtnhKjiu5A7h4RNEw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.5 311/367] mfd: bd70528: Fix hour register mask
Date:   Mon, 10 Feb 2020 04:33:44 -0800
Message-Id: <20200210122452.013434780@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

commit 6c883472e1c11cb05561b6dd0c28bb037c2bf2de upstream.

When RTC is used in 24H mode (and it is by this driver) the maximum
hour value is 24 in BCD. This occupies bits [5:0] - which means
correct mask for HOUR register is 0x3f not 0x1f. Fix the mask

Fixes: 32a4a4ebf768 ("rtc: bd70528: Initial support for ROHM bd70528 RTC")

Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mfd/rohm-bd70528.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mfd/rohm-bd70528.h
+++ b/include/linux/mfd/rohm-bd70528.h
@@ -317,7 +317,7 @@ enum {
 #define BD70528_MASK_RTC_MINUTE		0x7f
 #define BD70528_MASK_RTC_HOUR_24H	0x80
 #define BD70528_MASK_RTC_HOUR_PM	0x20
-#define BD70528_MASK_RTC_HOUR		0x1f
+#define BD70528_MASK_RTC_HOUR		0x3f
 #define BD70528_MASK_RTC_DAY		0x3f
 #define BD70528_MASK_RTC_WEEK		0x07
 #define BD70528_MASK_RTC_MONTH		0x1f


