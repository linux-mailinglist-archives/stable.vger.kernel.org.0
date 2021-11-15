Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9544513AF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348621AbhKOTyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343872AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD99863393;
        Mon, 15 Nov 2021 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002073;
        bh=ELe964MnL6byNaeDUTR2gPdUO6JYoB1JQSLrQAenmBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyMO8Ky6qcNt2zysPfh2NCnExSD0pgJg2tdJ+5qfA1SUi0fSi7/XcyHGn/x0Q694b
         Y3nJMKfOaXeDKU8MXKqfSJnjdrtaK/ZSEzcK07ssAIxNVvb1d4wTissCB24ssnwQYJ
         rS1sBp2lMP1R0giI12dluCYqIzdg++Wjf7MMVMB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-um@lists.infradead.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/917] net: fealnx: fix build for UML
Date:   Mon, 15 Nov 2021 17:58:44 +0100
Message-Id: <20211115165443.338738029@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit cd2621d07d517473611b170c69beb6524c677740 ]

On i386, when builtin (not a loadable module), the fealnx driver
inspects boot_cpu_data to see what CPU family it is running on, and
then acts on that data. The "family" struct member (x86) does not exist
when running on UML, so prevent that test and do the default action.

Prevents this build error on UML + i386:

../drivers/net/ethernet/fealnx.c: In function ‘netdev_open’:
../drivers/net/ethernet/fealnx.c:861:19: error: ‘struct cpuinfo_um’ has no member named ‘x86’

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20211014050500.5620-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/fealnx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index 25c91b3c5fd30..819266d463b07 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -857,7 +857,7 @@ static int netdev_open(struct net_device *dev)
 	np->bcrvalue |= 0x04;	/* big-endian */
 #endif
 
-#if defined(__i386__) && !defined(MODULE)
+#if defined(__i386__) && !defined(MODULE) && !defined(CONFIG_UML)
 	if (boot_cpu_data.x86 <= 4)
 		np->crvalue = 0xa00;
 	else
-- 
2.33.0



