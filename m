Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4196A412330
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351957AbhITSWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377671AbhITSUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28127632AC;
        Mon, 20 Sep 2021 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158599;
        bh=rpPqGKgfM15i4Rlvu3p2CmWloaT4ekZ+qYf52qwrXcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ua5qMAGngVLnH1iBnbXKC03mGuU/g21UUnblo5Ubia/7zGUZDm3NH3S4Gh1YMWW52
         q2D4k1dSM9RK3jP2ofcIHIY8E4HxG8W6KctCIvjnAGETg1SGIbb5FGfeTVhWuEA1ci
         32Qcny5DES6kXDLK8ykDxuJoB1VTOOj0rrisa6DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 231/260] net: hns3: fix the timing issue of VF clearing interrupt sources
Date:   Mon, 20 Sep 2021 18:44:09 +0200
Message-Id: <20210920163938.967614638@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

commit 427900d27d86b820c559037a984bd403f910860f upstream.

Currently, the VF does not clear the interrupt source immediately after
receiving the interrupt. As a result, if the second interrupt task is
triggered when processing the first interrupt task, clearing the
interrupt source before exiting will clear the interrupt sources of the
two tasks at the same time. As a result, no interrupt is triggered for
the second task. The VF detects the missed message only when the next
interrupt is generated.

Clearing it immediately after executing check_evt_cause ensures that:
1. Even if two interrupt tasks are triggered at the same time, they can
be processed.
2. If the second task is triggered during the processing of the first
task and the interrupt source is not cleared, the interrupt is reported
after vector0 is enabled.

Fixes: b90fcc5bd904 ("net: hns3: add reset handling for VF when doing Core/Global/IMP reset")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1956,6 +1956,8 @@ static irqreturn_t hclgevf_misc_irq_hand
 
 	hclgevf_enable_vector(&hdev->misc_vector, false);
 	event_cause = hclgevf_check_evt_cause(hdev, &clearval);
+	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
+		hclgevf_clear_event_cause(hdev, clearval);
 
 	switch (event_cause) {
 	case HCLGEVF_VECTOR0_EVENT_RST:
@@ -1968,10 +1970,8 @@ static irqreturn_t hclgevf_misc_irq_hand
 		break;
 	}
 
-	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER) {
-		hclgevf_clear_event_cause(hdev, clearval);
+	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
 		hclgevf_enable_vector(&hdev->misc_vector, true);
-	}
 
 	return IRQ_HANDLED;
 }


