Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78B827C656
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgI2LoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730825AbgI2Lnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D168D206F7;
        Tue, 29 Sep 2020 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379835;
        bh=h3nG408u8M5wAxaiEyktRjFXOeJbTF1fUnMhSBKMxi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQmDAFhtuM7T+14YQE+llF2EO0IukpG9jrXAaNEgvhwmUIl9WUxiWptaOug8GABzR
         vogk1PPf17tygF+KQ9eGdS5f8lesg49s4af41UojFKuUkDrWFHj5scPmQFkmYtaW7u
         0l15M0IzntlchMOrBR5wGx7mGf3fPuqpZeE9Mrrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 338/388] ieee802154/adf7242: check status of adf7242_read_reg
Date:   Tue, 29 Sep 2020 13:01:09 +0200
Message-Id: <20200929110026.823984980@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit e3914ed6cf44bfe1f169e26241f8314556fd1ac1 ]

Clang static analysis reports this error

adf7242.c:887:6: warning: Assigned value is garbage or undefined
        len = len_u8;
            ^ ~~~~~~

len_u8 is set in
       adf7242_read_reg(lp, 0, &len_u8);

When this call fails, len_u8 is not set.

So check the return code.

Fixes: 7302b9d90117 ("ieee802154/adf7242: Driver for ADF7242 MAC IEEE802154")

Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://lore.kernel.org/r/20200802142339.21091-1-trix@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/adf7242.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index 8dbccec6ac866..5945ac5f38eea 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -882,7 +882,9 @@ static int adf7242_rx(struct adf7242_local *lp)
 	int ret;
 	u8 lqi, len_u8, *data;
 
-	adf7242_read_reg(lp, 0, &len_u8);
+	ret = adf7242_read_reg(lp, 0, &len_u8);
+	if (ret)
+		return ret;
 
 	len = len_u8;
 
-- 
2.25.1



