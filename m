Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E5917818F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgCCSDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbgCCSB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA0B20CC7;
        Tue,  3 Mar 2020 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258486;
        bh=MC5FXkUrXqYCGbHfBmE2VvoUd6IX0tYSr75c/vkeMqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mqrj+ZzpV3Lt2MFHn3dB9jznHYqylEYJ4hoctQPJ77SXf4T4g6SJBMjjzThlVJwmz
         ItyCj0DFnvSV31hbvVqEn8fXNmJMBMejo4qD7vRVTewYxlezGNAQHCtTzGN8E2afyn
         lpi/IVuc8bXN3Cd2oRCMnNJX0eo0iJGnpEyMJ1HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 65/87] net/smc: no peer ID in CLC decline for SMCD
Date:   Tue,  3 Mar 2020 18:43:56 +0100
Message-Id: <20200303174356.167499727@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

commit 369537c97024dca99303a8d4d6ab38b4f54d3909 upstream.

Just SMCR requires a CLC Peer ID, but not SMCD. The field should be
zero for SMCD.

Fixes: c758dfddc1b5 ("net/smc: add SMC-D support in CLC messages")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/smc/smc_clc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -364,7 +364,9 @@ int smc_clc_send_decline(struct smc_sock
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
 	dclc.hdr.version = SMC_CLC_V1;
 	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
-	memcpy(dclc.id_for_peer, local_systemid, sizeof(local_systemid));
+	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
+		memcpy(dclc.id_for_peer, local_systemid,
+		       sizeof(local_systemid));
 	dclc.peer_diagnosis = htonl(peer_diag_info);
 	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 


