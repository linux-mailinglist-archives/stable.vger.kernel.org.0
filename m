Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6279A1380EC
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgAKKik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:38:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbgAKKik (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:38:40 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA2820848;
        Sat, 11 Jan 2020 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578739120;
        bh=OcCU+lLVcQEXm1jrGQG9cvUwcTHwxePTl7ZsUnaZ3Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlMbKhikK0QmAi++n2BMhsf4TwiOlya2cy9CTfvSFC/1BzjRBgah7UWkxztJDWP7r
         o3HNO3ez4fGKbhUkySBVzlY/sv3/bUkO1iJ80+LppgFuHGjK3HjIHBK/526bskcEmj
         w3W9UK6Al7wGyjwo5hwWaXH8VxwImfj0DTu2GAOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/165] platform/x86: pcengines-apuv2: fix simswap GPIO assignment
Date:   Sat, 11 Jan 2020 10:50:42 +0100
Message-Id: <20200111094934.271788492@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enrico Weigelt, metux IT consult <info@metux.net>

[ Upstream commit d4ac8f83dafec205c5db9b86b21587fba43bc017 ]

The mapping entry has to hold the GPIO line index instead of
controller's register number.

Fixes: 5037d4ddda31 ("platform/x86: pcengines-apuv2: wire up simswitch gpio as led")
Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pcengines-apuv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/pcengines-apuv2.c b/drivers/platform/x86/pcengines-apuv2.c
index 48b112b4f0b0..c32daf087640 100644
--- a/drivers/platform/x86/pcengines-apuv2.c
+++ b/drivers/platform/x86/pcengines-apuv2.c
@@ -95,7 +95,7 @@ static struct gpiod_lookup_table gpios_led_table = {
 				NULL, 1, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_LINE_LED3,
 				NULL, 2, GPIO_ACTIVE_LOW),
-		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_REG_SIMSWAP,
+		GPIO_LOOKUP_IDX(AMD_FCH_GPIO_DRIVER_NAME, APU2_GPIO_LINE_SIMSWAP,
 				NULL, 3, GPIO_ACTIVE_LOW),
 	}
 };
-- 
2.20.1



