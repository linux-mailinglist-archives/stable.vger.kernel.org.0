Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7565F14EC1
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfEFOjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbfEFOjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A4D21479;
        Mon,  6 May 2019 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153543;
        bh=YWmIRXnPDSIST+5S/E+Jo9v990ZF95a3j597D5119sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ix10W4p6q1WIb5Zo+Fn34wIF+YhjyyWfF+f9GUrKDcujBxmtEYEpAkwk0NHLtXLax
         zbx8ze43HXQFPBgYKoT91ffJgd7/4ARdiZ/zgAzY6sfuDIOmsMRcS20eu7ixH5Z49G
         vsS2qrHVfN4ihsqA2cvVF8Oe3t8kS/v70ncijDxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.0 107/122] IB/core: Fix potential memory leak while creating MAD agents
Date:   Mon,  6 May 2019 16:32:45 +0200
Message-Id: <20190506143104.203535744@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

commit 6e88e672b69f0e627acdae74a527b730ea224b6b upstream.

If the MAD agents isn't allowed to manage the subnet, or fails to register
for the LSM notifier, the security context is leaked. Free the context in
these cases.

Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reported-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/security.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -710,16 +710,20 @@ int ib_mad_agent_security_setup(struct i
 						dev_name(&agent->device->dev),
 						agent->port_num);
 	if (ret)
-		return ret;
+		goto free_security;
 
 	agent->lsm_nb.notifier_call = ib_mad_agent_security_change;
 	ret = register_lsm_notifier(&agent->lsm_nb);
 	if (ret)
-		return ret;
+		goto free_security;
 
 	agent->smp_allowed = true;
 	agent->lsm_nb_reg = true;
 	return 0;
+
+free_security:
+	security_ib_free_security(agent->security);
+	return ret;
 }
 
 void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)


