Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0001C29C268
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819948AbgJ0Rfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760863AbgJ0Ogt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E1DE207BB;
        Tue, 27 Oct 2020 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809408;
        bh=cq/XuqQTrvdr9EMhVUhZzusgJN+WzsKAYXLB+TUeYEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/yf0k7fOvv6p3IQynArNt2l7XTYe+W2bAg1/MVxaoZx88yBGssQRsqBnIwSi0BPH
         JyrPTCdd10FJaSvrFOx6ZrTIqct4JQExWWFt90S5dpnJuzQRhi9LhNsRLjEw/eNhZR
         p7/kxWn0t7SiWrwbuM1lnfhoMmkWSLF8dx/0g42c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/408] net: dsa: rtl8366: Skip PVID setting if not requested
Date:   Tue, 27 Oct 2020 14:51:32 +0100
Message-Id: <20201027135502.228474575@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 3dfe8dde093a07e82fa472c0f8c29a7f6a2006a5 ]

We go to lengths to determine whether the PVID should be set
for this port or not, and then fail to take it into account.
Fix this oversight.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index b941d45edd641..49c626a336803 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -436,6 +436,9 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 				"failed to set up VLAN %04x",
 				vid);
 
+		if (!pvid)
+			continue;
+
 		ret = rtl8366_set_pvid(smi, port, vid);
 		if (ret)
 			dev_err(smi->dev,
-- 
2.25.1



