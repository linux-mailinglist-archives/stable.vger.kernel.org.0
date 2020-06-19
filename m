Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA492200C64
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbgFSOpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388682AbgFSOpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B75420A8B;
        Fri, 19 Jun 2020 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577917;
        bh=afey/RecsirKQAD3ec+xHIOS+5OO1hTmH62iLsK7Xk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzJjvtghmIISWZqF8XLNy6rtUY1OkAmBUUcmmMglDEwZ0Adp2wLW0iXplE/HQYHNg
         R/mZKYaJjRrxwm7xvu4YmJ+EkcWK80yn3cDlbhYnBBcgPcqhbfNBUrGSpIMOWv0tcV
         MjdL/hQ5kdbsH2X6OjTscBstyqFjXV9oc9nIlvnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 013/190] drivers/net/ibmvnic: Update VNIC protocol version reporting
Date:   Fri, 19 Jun 2020 16:30:58 +0200
Message-Id: <20200619141634.133139918@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 784688993ebac34dffe44a9f2fabbe126ebfd4db ]

VNIC protocol version is reported in big-endian format, but it
is not byteswapped before logging. Fix that, and remove version
comparison as only one protocol version exists at this time.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 956fbb164e6f..85c11dafb4cd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3560,12 +3560,10 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			dev_err(dev, "Error %ld in VERSION_EXCHG_RSP\n", rc);
 			break;
 		}
-		dev_info(dev, "Partner protocol version is %d\n",
-			 crq->version_exchange_rsp.version);
-		if (be16_to_cpu(crq->version_exchange_rsp.version) <
-		    ibmvnic_version)
-			ibmvnic_version =
+		ibmvnic_version =
 			    be16_to_cpu(crq->version_exchange_rsp.version);
+		dev_info(dev, "Partner protocol version is %d\n",
+			 ibmvnic_version);
 		send_cap_queries(adapter);
 		break;
 	case QUERY_CAPABILITY_RSP:
-- 
2.25.1



