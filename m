Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBCA7983E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbfG2TlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389354AbfG2TlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:41:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD9C206DD;
        Mon, 29 Jul 2019 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429277;
        bh=gMtJx6n2k6Cgtgh0FR7msq+MIrOSZmtui9BJYIUlbLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tvDAnBaDj3l9iL1DymS3OfYvbq285SjanDHnVn19pCJ0AVj4dU56dNdOZ6TWNu5+
         vjfIIO0AFwoLLH2MRu6w1GNRd9KzFud/1hX2uz5qfaJgKtNieiiKggJFPHG7KBY7k4
         On3/HBUHNmgerYIvzUGZBjOCbt4+LZLuZb5h6W3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Daniel Gomez <dagmcr@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/113] mfd: madera: Add missing of table registration
Date:   Mon, 29 Jul 2019 21:22:15 +0200
Message-Id: <20190729190707.024661411@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
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
index 8cfea969b060..45c7d8b97349 100644
--- a/drivers/mfd/madera-core.c
+++ b/drivers/mfd/madera-core.c
@@ -278,6 +278,7 @@ const struct of_device_id madera_of_match[] = {
 	{ .compatible = "cirrus,wm1840", .data = (void *)WM1840 },
 	{}
 };
+MODULE_DEVICE_TABLE(of, madera_of_match);
 EXPORT_SYMBOL_GPL(madera_of_match);
 
 static int madera_get_reset_gpio(struct madera *madera)
-- 
2.20.1



