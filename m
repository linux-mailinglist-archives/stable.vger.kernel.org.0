Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F391CABCC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgEHMrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgEHMrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B3BD2145D;
        Fri,  8 May 2020 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942023;
        bh=b1reyi0WARpFwl48mYlPq8Jcm5QCOzjbgJtms3E5qh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxMCmKHBQnz52anrxfi1lkkfnpbgtrcmKMWEXgdTXYW3fyb9Cc3qKv/njLeVPl9NG
         EVo/GYzBrVAudOrWp+arIaSNXEh4o7THr1jj8qIYdFPTzcrRCpnawmyYsMOAOE4ArD
         nT+zr1+jYHaM8OSqaUrVmKIQzPQphlXznwSMLEuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 265/312] et131x: Fix logical vs bitwise check in et131x_tx_timeout()
Date:   Fri,  8 May 2020 14:34:16 +0200
Message-Id: <20200508123143.075399953@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit de702da7a823ab0c4a1e53ed79a2695f0d453855 upstream.

We should be using a logical check here instead of a bitwise operation
to check if the device is closed already in et131x_tx_timeout().

Reported-by: coverity (CID 146498)
Fixes: 38df6492eb511 ("et131x: Add PCIe gigabit ethernet driver et131x to drivers/net")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/agere/et131x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3854,7 +3854,7 @@ static void et131x_tx_timeout(struct net
 	unsigned long flags;
 
 	/* If the device is closed, ignore the timeout */
-	if (~(adapter->flags & FMP_ADAPTER_INTERRUPT_IN_USE))
+	if (!(adapter->flags & FMP_ADAPTER_INTERRUPT_IN_USE))
 		return;
 
 	/* Any nonrecoverable hardware error?


