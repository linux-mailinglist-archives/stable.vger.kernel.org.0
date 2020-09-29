Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B519B27C56F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgI2Lfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729855AbgI2Lff (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C751623D3B;
        Tue, 29 Sep 2020 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378995;
        bh=7nx6L7CIlCnwbUjI5k57By6WW/f07Buc2fPTqmV2PUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJEAbadqLRlu23m+SZHssqMjXZrq6A0UX8nUXixLr+1dMbXqM4N99MJvJboz7xTV9
         9u/wORrW6fa5wC65DvY8Mr2vKIqEjCVyPWl/QFdzlyceH+xLo7SmsBSftyNBZRbBot
         FJO68L/Y26LNQFq4yGQPiInoj7lq2a9HK21hXGhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/245] ieee802154/adf7242: check status of adf7242_read_reg
Date:   Tue, 29 Sep 2020 13:01:07 +0200
Message-Id: <20200929105957.492554534@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 71be8524cca87..a686926bba71e 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -883,7 +883,9 @@ static int adf7242_rx(struct adf7242_local *lp)
 	int ret;
 	u8 lqi, len_u8, *data;
 
-	adf7242_read_reg(lp, 0, &len_u8);
+	ret = adf7242_read_reg(lp, 0, &len_u8);
+	if (ret)
+		return ret;
 
 	len = len_u8;
 
-- 
2.25.1



