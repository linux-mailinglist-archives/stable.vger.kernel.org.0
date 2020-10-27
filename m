Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9411129B812
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799369AbgJ0PbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761003AbgJ0PbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3BFA22202;
        Tue, 27 Oct 2020 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812668;
        bh=gLX4n3vF6AoNc709FWw3JlpXKTPKNeonbdcsEyIP2y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bx7iVC0c13uab1DW6zXFOLCaI6ecG0ovr4J5kSBeS6mg6jU6ACBtK5yYVOxsPDuvX
         Iu/jCA88ZCK8p4q3I49sdQGSra0ORVRe9QMb/s4RvwP6Me3zKBKrAKZLnOtIQssKmX
         +9fXgQ7OjAcW+Uz6Azs60vsULi1B0dpIhazOrimA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 290/757] net: dsa: rtl8366: Skip PVID setting if not requested
Date:   Tue, 27 Oct 2020 14:49:00 +0100
Message-Id: <20201027135504.173199166@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index bd3c947976ce0..c58ca324a4b24 100644
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



