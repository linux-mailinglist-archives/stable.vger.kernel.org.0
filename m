Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3149F147AD3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgAXJif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:38:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730713AbgAXJie (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:38:34 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 448112087E;
        Fri, 24 Jan 2020 09:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858713;
        bh=SDDaB161FtBEIaSP+fWw8KSAAgxMEZyjIlZlrl1TXmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEr+nvjWRi/PKyqUehqz8VeR1egDoO/BYr20RNj+3c4w5tTwEd4hVNC1SsJc485OI
         suoB8rgT8FR9nSMug+kmJy80EQnbRqQ7KjXsb3yTPD/QxP45m+B2jroe5mmZcLiqok
         88tmuA6aNwEYF+6ZBe/Bigf43K2gkmbyHDr0quzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.4 031/102] phy: ti: gmii-sel: fix mac tx internal delay for rgmii-rxid
Date:   Fri, 24 Jan 2020 10:30:32 +0100
Message-Id: <20200124092810.920947941@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit 316b429459066215abb50060873ec0832efc4044 upstream.

Now phy-gmii-sel will disable MAC TX internal delay for PHY interface mode
"rgmii-rxid" which is incorrect.
Hence, fix it by enabling MAC TX internal delay in the case of "rgmii-rxid"
mode.

Fixes: 92b58b34741f ("phy: ti: introduce phy-gmii-sel driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/ti/phy-gmii-sel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -69,11 +69,11 @@ static int phy_gmii_sel_mode(struct phy
 		break;
 
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
 		gmii_sel_mode = AM33XX_GMII_SEL_MODE_RGMII;
 		break;
 
 	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		gmii_sel_mode = AM33XX_GMII_SEL_MODE_RGMII;
 		rgmii_id = 1;


