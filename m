Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596F745C1AD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348674AbhKXNUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349240AbhKXNSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3647E61AE4;
        Wed, 24 Nov 2021 12:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757953;
        bh=lOINc8zJAMoX3k8oG/uZ9gevZh0lJ56ObrmXG8BE5yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ck2DmmB8jmSaS5t4ad5Q7xMBYOYFPZtlUBN6W0h7DAtN3QsVkUoRftKUEIEhUFnU3
         dbvRwhvDUmz2Ehh7Bt8qA+0SexoGAv4JbygEmtuZkiTXrEpsjLfq3zkb0GjIc1nhtj
         vHZJUi0r0iEHFRg7xXhg3c5HCzR8FbakW4qrW9Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        linux-mips@vger.kernel.org, John Crispin <john@phrozen.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 292/323] mips: lantiq: add support for clk_get_parent()
Date:   Wed, 24 Nov 2021 12:58:02 +0100
Message-Id: <20211124115728.764318250@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit fc1aabb088860d6cf9dd03612b7a6f0de91ccac2 ]

Provide a simple implementation of clk_get_parent() in the
lantiq subarch so that callers of it will build without errors.

Fixes this build error:
ERROR: modpost: "clk_get_parent" [drivers/iio/adc/ingenic-adc.ko] undefined!

Fixes: 171bb2f19ed6 ("MIPS: Lantiq: Add initial support for Lantiq SoCs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: linux-mips@vger.kernel.org
Cc: John Crispin <john@phrozen.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: John Crispin <john@phrozen.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/clk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/lantiq/clk.c b/arch/mips/lantiq/clk.c
index a263d1b751ffe..a8e309dcd38d7 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -160,6 +160,12 @@ void clk_deactivate(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_deactivate);
 
+struct clk *clk_get_parent(struct clk *clk)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(clk_get_parent);
+
 static inline u32 get_counter_resolution(void)
 {
 	u32 res;
-- 
2.33.0



