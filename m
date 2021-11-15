Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD96C4523CD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344981AbhKPBbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243262AbhKOSzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:55:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A7F361131;
        Mon, 15 Nov 2021 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999894;
        bh=f+gareNvqS7C7WH5fPJTCvAFTlVTkNCvOI85HwFjYDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLgKI5RxM7w9Us1JhqK2avNLsqkgz4uZ0LG9WIt+6xQLJ+DvLH/yS+Zw5yYAIEMes
         grKJyoMD9ajw2G2VPsZmeH01czVvhgowE4E2BYnMN7HGepRDKgZ9UeycnGSqgVaMyT
         vC2JT40LDtvpKIfoTIT5yYmwQvsF+//Dc0dorfTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-um@lists.infradead.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 429/849] net: fealnx: fix build for UML
Date:   Mon, 15 Nov 2021 17:58:32 +0100
Message-Id: <20211115165434.788360359@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 0f141c14d72df..a417f0c072e9b 100644
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



