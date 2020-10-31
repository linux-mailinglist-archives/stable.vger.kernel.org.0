Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F302A16E3
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgJaLls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbgJaLls (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F2F420791;
        Sat, 31 Oct 2020 11:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144507;
        bh=WOeR5q4Stn4rnNDEQqHOr44KHoF273FAr4WbkJsmNAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnsYs+PZsPUlEZy2PgdtWMkoKtu+EeSuf6Wwsq7sIjGBgRILv/x1S6Vo3Mi/HQ6Fv
         ghX+8KHqF0k2jQY7ZFgywUq8LjxLyZ15XL/NGSElWW+eh4kt8uiYiIjPWWyknNO/Cp
         Ni68XkzcjWr4KvR/iOZEC0+yMlWW9P/vO37oszgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 44/70] r8169: fix issue with forced threading in combination with shared interrupts
Date:   Sat, 31 Oct 2020 12:36:16 +0100
Message-Id: <20201031113501.608327456@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2734a24e6e5d18522fbf599135c59b82ec9b2c9e ]

As reported by Serge flag IRQF_NO_THREAD causes an error if the
interrupt is actually shared and the other driver(s) don't have this
flag set. This situation can occur if a PCI(e) legacy interrupt is
used in combination with forced threading.
There's no good way to deal with this properly, therefore we have to
remove flag IRQF_NO_THREAD. For fixing the original forced threading
issue switch to napi_schedule().

Fixes: 424a646e072a ("r8169: fix operation under forced interrupt threading")
Link: https://www.spinics.net/lists/netdev/msg694960.html
Reported-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Link: https://lore.kernel.org/r/b5b53bfe-35ac-3768-85bf-74d1290cf394@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4559,7 +4559,7 @@ static irqreturn_t rtl8169_interrupt(int
 	}
 
 	rtl_irq_disable(tp);
-	napi_schedule_irqoff(&tp->napi);
+	napi_schedule(&tp->napi);
 out:
 	rtl_ack_events(tp, status);
 
@@ -4727,7 +4727,7 @@ static int rtl_open(struct net_device *d
 	rtl_request_firmware(tp);
 
 	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
-			     IRQF_NO_THREAD | IRQF_SHARED, dev->name, tp);
+			     IRQF_SHARED, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 


