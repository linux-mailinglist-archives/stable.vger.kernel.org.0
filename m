Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0D82B638E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgKQNjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732408AbgKQNjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D705520870;
        Tue, 17 Nov 2020 13:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620346;
        bh=KQCuwdMUqM8EjjgvAFkva6iPqgagY4BwNMp1qW9+J0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCI533KXeHEO080roUq8nC34aH2RCIQvJWHLCxjQCgG76s/SqTkdlEiZZ5hBiW/cg
         3lz3TAxmh3IFXCBSbxmF8y/lQPO53TO4pIjPhYstxYW0w8uOUGFuh774Bk///GZcN0
         HZRiPqOj0ia04cIeEf2xlnIysHVUnhyEg4SkzPz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 157/255] net: phy: realtek: support paged operations on RTL8201CP
Date:   Tue, 17 Nov 2020 14:04:57 +0100
Message-Id: <20201117122146.590282409@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit f3037c5a31b58a73b32a36e938ad0560085acadd ]

The RTL8401-internal PHY identifies as RTL8201CP, and the init
sequence in r8169, copied from vendor driver r8168, uses paged
operations. Therefore set the same paged operation callbacks as
for the other Realtek PHY's.

Fixes: cdafdc29ef75 ("r8169: sync support for RTL8401 with vendor driver")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/69882f7a-ca2f-e0c7-ae83-c9b6937282cd@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 0f09609718007..81a614f903c4a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -542,6 +542,8 @@ static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
 		.name           = "RTL8201CP Ethernet",
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc816),
 		.name		= "RTL8201F Fast Ethernet",
-- 
2.27.0



