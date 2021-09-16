Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A18340E75E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347467AbhIPRbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353036AbhIPR3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0656563156;
        Thu, 16 Sep 2021 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810781;
        bh=uLZ/voZxpdGW5MEY6zifV7PeAzyie8gXGgGTSK/r0Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO9UZILpQ0nFUIu0KG3qlsH5Td6k13OCUaZ7FXwNTV+V3kLq83tG7gnUsNxRAQi/k
         kzGwEY1oT4RE+9p1gOh8xJSXpG7o6weRIZxdNqf3Taogm5h8iaBuQLHCJy9zS7KftY
         nZpPbxT63moVVX6L0Y25DnquHEXyl0pUsBykQL3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 264/432] net: ipa: fix IPA v4.9 interconnects
Date:   Thu, 16 Sep 2021 18:00:13 +0200
Message-Id: <20210916155819.772539221@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 0fd75f5760b6a7a7f35dff46a6cdc4f6d1a86ee8 ]

Three interconnects are defined for IPA version 4.9, but there
should only be two.  They should also use names that match what's
used for other platforms (and specified in the Device Tree binding).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_data-v4.9.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 798d43e1eb13..4cce5dce9215 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -416,18 +416,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 /* Interconnect rates are in 1000 byte/second units */
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
-		.name			= "ipa_to_llcc",
+		.name			= "memory",
 		.peak_bandwidth		= 600000,	/* 600 MBps */
 		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
-	{
-		.name			= "llcc_to_ebi1",
-		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
-		.average_bandwidth	= 150000,	/* 150 MBps */
-	},
 	/* Average rate is unused for the next interconnect */
 	{
-		.name			= "appss_to_ipa",
+		.name			= "config",
 		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
-- 
2.30.2



