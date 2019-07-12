Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08F66C7A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfGLMUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfGLMUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:20:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBE12166E;
        Fri, 12 Jul 2019 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934030;
        bh=JcVTYSmEquGqUaaH+cWCIyPJmKR2psxEv0qovG255wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/DsrS9KfJ2jB4uOT7dk+cqwHuyu2lmdRLXWl1DRv5bqAPHgOuq5pfa/L8f5lhEmU
         6bKGh4OTcCno4VmQYOQe5SukmyT7eaVnyeJBAuZMRIZksl4bu8OkijqvctHOWHxYg7
         QyNoY47C160b8XirKKpqC4uZJoT9RtK0/q+GUF5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/91] ibmvnic: Do not close unopened driver during reset
Date:   Fri, 12 Jul 2019 14:18:26 +0200
Message-Id: <20190712121622.637816904@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1f94608b0ce141be5286dde31270590bdf35b86a ]

Check driver state before halting it during a reset. If the driver is
not running, do nothing. Otherwise, a request to deactivate a down link
can cause an error and the reset will fail.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 426789e2c23d..bf0a5fe0da17 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1754,7 +1754,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 	ibmvnic_cleanup(netdev);
 
-	if (adapter->reset_reason != VNIC_RESET_MOBILITY &&
+	if (reset_state == VNIC_OPEN &&
+	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
 		rc = __ibmvnic_close(netdev);
 		if (rc)
-- 
2.20.1



