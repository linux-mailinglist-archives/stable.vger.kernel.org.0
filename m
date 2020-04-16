Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876EE1ACC06
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504171AbgDPPxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896263AbgDPNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F24B621D94;
        Thu, 16 Apr 2020 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043834;
        bh=/aB5ZQPjIvOzuahP2sOeMKjKwI7vTSL9/R8D2dpZKo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phyqzm6lXEgTumWKZI2YM54MBsSM6PN38JS40WLJ2EjoQ8g7K96NVSoy5LRKp/pTw
         C3jbu9/jD7CaH5i92PIgnhrdtZHyQbVP0OTTFvXpskV6nO/tk7TKNjjQ1uikW+uX5Q
         tH18huoUNAuYZwi4cyKxbSOZvwWy7l4U41r6NQ1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 117/146] clk: ingenic/jz4770: Exit with error if CGU init failed
Date:   Thu, 16 Apr 2020 15:24:18 +0200
Message-Id: <20200416131258.618318810@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit c067b46d731a764fc46ecc466c2967088c97089e upstream.

Exit jz4770_cgu_init() if the 'cgu' pointer we get is NULL, since the
pointer is passed as argument to functions later on.

Fixes: 7a01c19007ad ("clk: Add Ingenic jz4770 CGU driver")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lkml.kernel.org/r/20200213161952.37460-1-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ingenic/jz4770-cgu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/clk/ingenic/jz4770-cgu.c
+++ b/drivers/clk/ingenic/jz4770-cgu.c
@@ -436,8 +436,10 @@ static void __init jz4770_cgu_init(struc
 
 	cgu = ingenic_cgu_new(jz4770_cgu_clocks,
 			      ARRAY_SIZE(jz4770_cgu_clocks), np);
-	if (!cgu)
+	if (!cgu) {
 		pr_err("%s: failed to initialise CGU\n", __func__);
+		return;
+	}
 
 	retval = ingenic_cgu_register_clocks(cgu);
 	if (retval)


