Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167D7404D86
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243634AbhIIMDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244195AbhIIMBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D1F261423;
        Thu,  9 Sep 2021 11:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187977;
        bh=8B59y0L/wT2zvmO07cGzKGTGPzz20BmRT7PsdET3T74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkpcoWf46bpT/WVywGNrP2/bdGOK07x8GfYLLlrWz89lXU3TFdcy3VF3iSW5f+5WN
         JH1TngTZHaww1G5z/vJ705a+OttDIJhpwqkWW+D+X5oCBUSJUs+X+uFIHJm7kjTHpO
         PjKgadMY2GYeyl+opMQAKR3tOcXrxvRkRBlYGt0TxzIWTsE61rQ6bxV9XyrdbS3qjC
         J89OkN3ZUiMO6+CwWa0C/PWF2x7fYrPoal4T7B0VU0k3ffNkIrLBK+wWkUpA+d5NRR
         9SjDTycwfqIxpLVwGBTDn+3jUCi05AomxiYr+x3clvY2x6S7nQLrKFzUNpvm1Iv0wA
         SNgnWsHq07Srg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Miguel Silva <rui.silva@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 239/252] usb: isp1760: fix memory pool initialization
Date:   Thu,  9 Sep 2021 07:40:53 -0400
Message-Id: <20210909114106.141462-239-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

