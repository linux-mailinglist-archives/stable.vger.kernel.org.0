Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D145D40E304
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbhIPQoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245629AbhIPQmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 634A861A2E;
        Thu, 16 Sep 2021 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809463;
        bh=2ZQgAdSqM3Z1B/NFboHJ5P2AqXD4GDXImXq2D9M7XEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wp9QTUEvCBsIobJgD+hTB1BrBb2s+YlMpyRVHc/YZlwC68vtbg/y+Zd7amlCLlHLI
         JQ9vF4gi8fXiwVVYmEEccyi67s4RRSqMLNQRONWIUknuNblq7j4X/94LeNhWqV4lvt
         qTw+OBO8UfkBLL6CcNm1mqfQsAp2w/mwzPil5Xpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 163/380] net: ipa: fix IPA v4.11 interconnect data
Date:   Thu, 16 Sep 2021 17:58:40 +0200
Message-Id: <20210916155809.631614748@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 0ac26271344478ff718329fa9d4ef81d4bcbc43b ]

Currently three interconnects are defined for the Qualcomm SC7280
SoC, but this was based on a misunderstanding.  There should only be
two interconnects defined:  one between the IPA and system memory;
and another between the AP and IPA config space.  The bandwidths
defined for the memory and config interconnects do not match what I
understand to be proper values, so update these.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_data-v4.11.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 05806ceae8b5..157f8d47058b 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -346,18 +346,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
-		.peak_bandwidth		= 465000,	/* 465 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps */
-	},
-	/* Average rate is unused for the next two interconnects */
-	{
-		.name			= "imem",
-		.peak_bandwidth		= 68570,	/* 68.57 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps (unused?) */
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
+	/* Average rate is unused for the next interconnect */
 	{
 		.name			= "config",
-		.peak_bandwidth		= 30000,	/* 30 MBps */
+		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
 };
-- 
2.30.2



