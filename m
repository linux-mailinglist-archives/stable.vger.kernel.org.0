Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CC7144FE2
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgAVJmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733131AbgAVJmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5A624680;
        Wed, 22 Jan 2020 09:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686121;
        bh=pLeUwWoGssYb3xBxY9l4C0o/DuV7/FRhpyqk7odZj1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiI099Hq7iOZ0peU6skrsoki96pgyMu0T6umUGx/6+FYy1ci72pEyRX6ie66T9JBG
         a4fS8ekwuaOyUirocTx++36pKSyU6n1I4S51LZBoQLgyxCoAWFL372+e0re11IrFhZ
         jghPFz5MbWYgaqkwDZ51I9gBSh+wYZy6qSU5TAbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 051/103] net: stmmac: Enable 16KB buffer size
Date:   Wed, 22 Jan 2020 10:29:07 +0100
Message-Id: <20200122092811.413972310@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit b2f3a481c4cd62f78391b836b64c0a6e72b503d2 upstream.

XGMAC supports maximum MTU that can go to 16KB. Lets add this check in
the calculation of RX buffer size.

Fixes: 7ac6653a085b ("stmmac: Move the STMicroelectronics driver")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1082,7 +1082,9 @@ static int stmmac_set_bfsize(int mtu, in
 {
 	int ret = bufsize;
 
-	if (mtu >= BUF_SIZE_4KiB)
+	if (mtu >= BUF_SIZE_8KiB)
+		ret = BUF_SIZE_16KiB;
+	else if (mtu >= BUF_SIZE_4KiB)
 		ret = BUF_SIZE_8KiB;
 	else if (mtu >= BUF_SIZE_2KiB)
 		ret = BUF_SIZE_4KiB;


