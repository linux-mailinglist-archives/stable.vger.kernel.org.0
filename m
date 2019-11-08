Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C7AF5681
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391761AbfKHTJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391265AbfKHTJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 758BE20673;
        Fri,  8 Nov 2019 19:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240154;
        bh=fFmKlk09ajJ78pWQurmV9l9LYHsomVaDHUaR7UfZzGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8sic+Eq9qsyJG0bxCfNQbRCTlLfUFA0UhvHt4Q3dVTPLyIzyfIh0ODqbbn4xB9Rk
         p8iGLcH44Amdoq/tVCCs//VSB/kh8KGHOYKkryAy2NIm5EUDl5jktCwXMeoIdtxYwh
         jlKL/rv+qqrEtU3Qu6gE6hYprNo1iJZPuGjSR1p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 106/140] net/smc: keep vlan_id for SMC-R in smc_listen_work()
Date:   Fri,  8 Nov 2019 19:50:34 +0100
Message-Id: <20191108174911.596119360@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit ca5f8d2dd5229ccacdd5cfde1ce4d32b0810e454 ]

Creating of an SMC-R connection with vlan-id fails, because
smc_listen_work() determines the vlan_id of the connection,
saves it in struct smc_init_info ini, but clears the ini area
again if SMC-D is not applicable.
This patch just resets the ISM device before investigating
SMC-R availability.

Fixes: bc36d2fc93eb ("net/smc: consolidate function parameters")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1298,8 +1298,8 @@ static void smc_listen_work(struct work_
 	/* check if RDMA is available */
 	if (!ism_supported) { /* SMC_TYPE_R or SMC_TYPE_B */
 		/* prepare RDMA check */
-		memset(&ini, 0, sizeof(ini));
 		ini.is_smcd = false;
+		ini.ism_dev = NULL;
 		ini.ib_lcl = &pclc->lcl;
 		rc = smc_find_rdma_device(new_smc, &ini);
 		if (rc) {


