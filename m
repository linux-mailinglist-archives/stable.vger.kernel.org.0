Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9267D1D85E3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgERRuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbgERRuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A688F20826;
        Mon, 18 May 2020 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824250;
        bh=zvL4WUKqUr4egYTxLwiT19jrJbcEYPSa8vWOmxhsTdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBz3WnlUPPm+IMrlR5LhELc5h81+ARmHafzQ7mkGP2CoTxFyVjH0GdbAYFrFHGIKN
         ORUyw+0Tnl6A8CGx10qzzF98As7NbqhHbil5W3+34g0uE+lMws3RpbPS0Z+VJcOE0A
         FZ5ruk5VDJKanUt/GD2Qsl4kM3sd5i9HKejQXYrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 17/80] net: dsa: loop: Add module soft dependency
Date:   Mon, 18 May 2020 19:36:35 +0200
Message-Id: <20200518173453.904987186@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 3047211ca11bf77b3ecbce045c0aa544d934b945 ]

There is a soft dependency against dsa_loop_bdinfo.ko which sets up the
MDIO device registration, since there are no symbols referenced by
dsa_loop.ko, there is no automatic loading of dsa_loop_bdinfo.ko which
is needed.

Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/dsa_loop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -360,6 +360,7 @@ static void __exit dsa_loop_exit(void)
 }
 module_exit(dsa_loop_exit);
 
+MODULE_SOFTDEP("pre: dsa_loop_bdinfo");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Fainelli");
 MODULE_DESCRIPTION("DSA loopback driver");


