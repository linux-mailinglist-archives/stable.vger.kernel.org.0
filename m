Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5758740E87D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355987AbhIPRoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355399AbhIPRl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93EB761357;
        Thu, 16 Sep 2021 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811173;
        bh=8B59y0L/wT2zvmO07cGzKGTGPzz20BmRT7PsdET3T74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4MCBBII86dMRu67RIkpDPrdIn3GiCf6vu0H/N0odJdETPZiJxvo3p9LvSMKwMKk4
         B7WtXG6QUaxldiOgFfHcBEhdxmNUnmcOKVedMwEenKJvK7SIOpGyYq33ufhKQUU2If
         7uc7YEexg7V0wamLyDcuBYR5FAyxszCevQ1sEGV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 377/432] usb: isp1760: fix memory pool initialization
Date:   Thu, 16 Sep 2021 18:02:06 +0200
Message-Id: <20210916155823.594534994@linuxfoundation.org>
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

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit f757f9291f920e1da4c6cfd4064c6bf59639983e ]

The loops to setup the memory pool were skipping some
blocks, that was not visible on the ISP1763 because it has
fewer blocks than the ISP1761. But won testing on that IP
from the family that would be an issue.

Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/r/20210827131154.4151862-2-rui.silva@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/isp1760/isp1760-hcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/isp1760/isp1760-hcd.c b/drivers/usb/isp1760/isp1760-hcd.c
index 27168b4a4ef2..ffb3a0c8c909 100644
--- a/drivers/usb/isp1760/isp1760-hcd.c
+++ b/drivers/usb/isp1760/isp1760-hcd.c
@@ -588,8 +588,8 @@ static void init_memory(struct isp1760_hcd *priv)
 
 	payload_addr = PAYLOAD_OFFSET;
 
-	for (i = 0, curr = 0; i < ARRAY_SIZE(mem->blocks); i++) {
-		for (j = 0; j < mem->blocks[i]; j++, curr++) {
+	for (i = 0, curr = 0; i < ARRAY_SIZE(mem->blocks); i++, curr += j) {
+		for (j = 0; j < mem->blocks[i]; j++) {
 			priv->memory_pool[curr + j].start = payload_addr;
 			priv->memory_pool[curr + j].size = mem->blocks_size[i];
 			priv->memory_pool[curr + j].free = 1;
-- 
2.30.2



