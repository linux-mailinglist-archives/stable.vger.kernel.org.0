Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D17963A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403758AbfG2Ttu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389840AbfG2Ttu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:49:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BD221655;
        Mon, 29 Jul 2019 19:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429788;
        bh=1Np7r3LAsxti73689pvspT3FnyQs5zyBYCe9YqO5YqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elDc/BnBuLKQ47e//BXXnO5wfThU3U65rt8LvPDc2XvNxS2UArP7IfDZpMLwaLRlZ
         44jHJx2xslkLzunPDKCAsBxfiEDIoC7+WsUG2wdt8fsn3j0giP8xstIb23cdu7ro3+
         grLU5Cg0rjehDbyHTE98FcaNcBojELgd5tst5qPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Daniel Gomez <dagmcr@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 096/215] mfd: madera: Add missing of table registration
Date:   Mon, 29 Jul 2019 21:21:32 +0200
Message-Id: <20190729190755.827160052@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5aa3709c0a5c026735b0ddd4ec80810a23d65f5b ]

MODULE_DEVICE_TABLE(of, <of_match_table>) should be called to complete DT
OF mathing mechanism and register it.

Before this patch:
modinfo ./drivers/mfd/madera.ko | grep alias

After this patch:
modinfo ./drivers/mfd/madera.ko | grep alias
alias:          of:N*T*Ccirrus,wm1840C*
alias:          of:N*T*Ccirrus,wm1840
alias:          of:N*T*Ccirrus,cs47l91C*
alias:          of:N*T*Ccirrus,cs47l91
alias:          of:N*T*Ccirrus,cs47l90C*
alias:          of:N*T*Ccirrus,cs47l90
alias:          of:N*T*Ccirrus,cs47l85C*
alias:          of:N*T*Ccirrus,cs47l85
alias:          of:N*T*Ccirrus,cs47l35C*
alias:          of:N*T*Ccirrus,cs47l35

Reported-by: Javier Martinez Canillas <javier@dowhile0.org>
Signed-off-by: Daniel Gomez <dagmcr@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/madera-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/madera-core.c b/drivers/mfd/madera-core.c
index 2a77988d0462..826b971ccb86 100644
--- a/drivers/mfd/madera-core.c
+++ b/drivers/mfd/madera-core.c
@@ -286,6 +286,7 @@ const struct of_device_id madera_of_match[] = {
 	{ .compatible = "cirrus,wm1840", .data = (void *)WM1840 },
 	{}
 };
+MODULE_DEVICE_TABLE(of, madera_of_match);
 EXPORT_SYMBOL_GPL(madera_of_match);
 
 static int madera_get_reset_gpio(struct madera *madera)
-- 
2.20.1



