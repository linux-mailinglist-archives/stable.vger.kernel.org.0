Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356DCB857E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394071AbfISWVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733140AbfISWTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1247F20678;
        Thu, 19 Sep 2019 22:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931586;
        bh=9Cb/7Dxwdgc3rSVccFfgH4ZMgneEXgFibVvzSzLCIyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVxNsJsP/82zj3yRy7Pxx2t+lbBaQ9/jhvGiZQfj40v9rb3r5ek6+yTG/oSEAJpsO
         VHKK+8zNo2h7bppS/Xbo+jhWdn63PCh2cgdiopKP8onNYk55BBZsfxXeKbmpOZ6KXC
         avcPtY5vacF1IZ6LEXgu2Xi/gz2t1xOOgCG7ap+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 09/74] sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
Date:   Fri, 20 Sep 2019 00:03:22 +0200
Message-Id: <20190919214803.931884674@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 10eb56c582c557c629271f1ee31e15e7a9b2558b ]

Transport should use its own pf_retrans to do the error_count
check, instead of asoc's. Otherwise, it's meaningless to make
pf_retrans per transport.

Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -509,7 +509,7 @@ static void sctp_do_8_2_transport_strike
 	if (net->sctp.pf_enable &&
 	   (transport->state == SCTP_ACTIVE) &&
 	   (transport->error_count < transport->pathmaxrxt) &&
-	   (transport->error_count > asoc->pf_retrans)) {
+	   (transport->error_count > transport->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,
 					     SCTP_TRANSPORT_PF,


