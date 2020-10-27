Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5214129B33A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764524AbgJ0OrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764563AbgJ0OrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:47:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 800A821D7B;
        Tue, 27 Oct 2020 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810021;
        bh=LodZH6S89e6fpjfSBoa6p1lBwSLujVjxQyJm6kpfBCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNh2Sdk+K/V92kXDRsIhIXiz9LMyINQaFU9r1n807eykSBngnki6MIUy1AoQhZwyZ
         Vb5qqFJnI2r6FEEIyY8hBtPtyLP3O65dJvtdwNOTwdeVqhkLCVlL4SJa2jQSwqqmuL
         eCaRTkxZ/lUfLhHW/C3skohuJJOFtFkGIVopmRMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 401/408] s390/qeth: dont let HW override the configured port role
Date:   Tue, 27 Oct 2020 14:55:39 +0100
Message-Id: <20201027135513.601532068@linuxfoundation.org>
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

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit a04f0ecacdb0639d416614619225a39de3927e22 ]

The only time that our Bridgeport role should change is when we change
the configuration ourselves. In which case we also adjust our internal
state tracking, no need to do it again when we receive the corresponding
event.

Removing the locked section helps a subsequent patch that needs to flush
the workqueue while under sbp_lock.

It would be nice to raise a warning here in case HW does weird things
after all, but this could end up generating false-positives when we
change the configuration ourselves.

Suggested-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4ce28aa490cdb..8c4613617ef11 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1168,12 +1168,6 @@ static void qeth_bridge_state_change_worker(struct work_struct *work)
 		NULL
 	};
 
-	/* Role should not change by itself, but if it did, */
-	/* information from the hardware is authoritative.  */
-	mutex_lock(&data->card->sbp_lock);
-	data->card->options.sbp.role = entry->role;
-	mutex_unlock(&data->card->sbp_lock);
-
 	snprintf(env_locrem, sizeof(env_locrem), "BRIDGEPORT=statechange");
 	snprintf(env_role, sizeof(env_role), "ROLE=%s",
 		(entry->role == QETH_SBP_ROLE_NONE) ? "none" :
-- 
2.25.1



