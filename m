Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABB81380A9
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgAKKcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731293AbgAKKcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:32:45 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89ACD20678;
        Sat, 11 Jan 2020 10:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738765;
        bh=ARu5wbjtq+VmR9Sl0KDeo986xTS2vi01f/eBTHLGts4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZr804y3EC2LFaxGQXrYABjomtjX8//rpg+nwis/GVc7iMxb063olZuiJhkzylbic
         ULGSmBjN1mmaZZAEKMTSTF3dxdoKWG2EMqmKtlMQWCoMpFwJX1tZR42F8/MtLAXhJ5
         BxjcZtSL9QVmgU/L3MIrXhahQe1K4t09JSL/XBz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/165] s390/qeth: dont return -ENOTSUPP to userspace
Date:   Sat, 11 Jan 2020 10:50:52 +0100
Message-Id: <20200111094936.507006833@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 39bdbf3e648d801596498a5a625fbc9fc1c0002f ]

ENOTSUPP is not uapi, use EOPNOTSUPP instead.

Fixes: d66cb37e9664 ("qeth: Add new priority queueing options")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 9f392497d570..4c3e222e5572 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -227,7 +227,7 @@ static ssize_t qeth_dev_prioqing_store(struct device *dev,
 		card->qdio.default_out_queue = QETH_DEFAULT_QUEUE;
 	} else if (sysfs_streq(buf, "prio_queueing_vlan")) {
 		if (IS_LAYER3(card)) {
-			rc = -ENOTSUPP;
+			rc = -EOPNOTSUPP;
 			goto out;
 		}
 		card->qdio.do_prio_queueing = QETH_PRIO_Q_ING_VLAN;
-- 
2.20.1



