Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E234214BA8F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgA1OQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbgA1OQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866F024688;
        Tue, 28 Jan 2020 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220995;
        bh=RsZ49+HuVXrU/JY3Ejeo3KXvJigAnXjCknahaYv5sjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUFvqiX4+824isnkeXGsvg0T+ks1DZMmOUr5+SN5hRqyYIBMHF44+vMrKz1xescOh
         9Irv8WIbu1CpzUalPlUy04OjH/n21+0lUTOvdvXx8jT+ZKYUtXkrAEmb47WCN+NaiG
         5niMs7VJURxxyaDzhBSNQWGhOUd+7uFFgWKPqauc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sylvain Chouleur <sylvain.chouleur@intel.com>,
        Patrick McDermott <patrick.mcdermott@libiquity.com>,
        linux-rtc@vger.kernel.org, Eric Wong <e@80x24.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 047/271] rtc: cmos: ignore bogus century byte
Date:   Tue, 28 Jan 2020 15:03:16 +0100
Message-Id: <20200128135856.145846743@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Wong <e@80x24.org>

[ Upstream commit 2a4daadd4d3e507138f8937926e6a4df49c6bfdc ]

Older versions of Libreboot and Coreboot had an invalid value
(`3' in my case) in the century byte affecting the GM45 in
the Thinkpad X200.  Not everybody's updated their firmwares,
and Linux <= 4.2 was able to read the RTC without problems,
so workaround this by ignoring invalid values.

Fixes: 3c217e51d8a272b9 ("rtc: cmos: century support")

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sylvain Chouleur <sylvain.chouleur@intel.com>
Cc: Patrick McDermott <patrick.mcdermott@libiquity.com>
Cc: linux-rtc@vger.kernel.org
Signed-off-by: Eric Wong <e@80x24.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 2f1772a358ca5..18a6f15e313d8 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -82,7 +82,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century)
+	if (century > 20)
 		time->tm_year += (century - 19) * 100;
 
 	/*
-- 
2.20.1



