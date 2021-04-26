Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F7636AE19
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhDZHll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233555AbhDZHjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324D6613C6;
        Mon, 26 Apr 2021 07:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422679;
        bh=3HMu736YuqwVAbCDUhlkGow54NNd0D83Yn5olVJTAWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1oCX1Gz2lZniEXzWQ84vhnlvPbTIuqIR3FT2FSYx843jBkctPvSbX7c31sVsPNH2
         LhYo9K0zyEphxmxS2wfL+lnoiOCAQc/zqiCFxER6z7suBRcnQcjzUxz4/Bs+h2q+ob
         S9GueGdARpwdK/VQQiu7/bVdmwBZP746oSnAZMIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        Lijun Pan <lijunp213@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 37/57] ibmvnic: avoid calling napi_disable() twice
Date:   Mon, 26 Apr 2021 09:29:34 +0200
Message-Id: <20210426072821.828786541@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

commit 0775ebc4cf8554bdcd2c212669a0868ab68df5c0 upstream.

__ibmvnic_open calls napi_disable without checking whether NAPI polling
has already been disabled or not. This could cause napi_disable
being called twice, which could generate deadlock. For example,
the first napi_disable will spin until NAPI_STATE_SCHED is cleared
by napi_complete_done, then set it again.
When napi_disable is called the second time, it will loop infinitely
because no dev->poll will be running to clear NAPI_STATE_SCHED.

To prevent above scenario from happening, call ibmvnic_napi_disable()
which checks if napi is disabled or not before calling napi_disable.

Fixes: bfc32f297337 ("ibmvnic: Move resource initialization to its own routine")
Suggested-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1092,8 +1092,7 @@ static int __ibmvnic_open(struct net_dev
 
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
-		for (i = 0; i < adapter->req_rx_queues; i++)
-			napi_disable(&adapter->napi[i]);
+		ibmvnic_napi_disable(adapter);
 		release_resources(adapter);
 		return rc;
 	}


