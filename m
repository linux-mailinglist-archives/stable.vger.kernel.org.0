Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842A6B5C09
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfIRGWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbfIRGWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:22:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE24A218AF;
        Wed, 18 Sep 2019 06:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787728;
        bh=Am3LBOHvWGKg614T7SoYKCS7JrSTDbZ+TlF37TA2tKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FClmb+z9u/3bTSBk2FQq3tRRPkmW9Kg8jMYDnRNZDsbEbhIgkmra70Ga3fViNNqPl
         AAJRCDI2CROpwG9ghw49v/GeUU+jCdtPwz+l44A5nMhnNN9ALK0p8XMxHgnAE5hXz+
         koRWAhZRpBge340EF1dYUqMk8nVQIVuF4F8fx4cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/50] sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
Date:   Wed, 18 Sep 2019 08:18:55 +0200
Message-Id: <20190918061224.308579712@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
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
@@ -562,7 +562,7 @@ static void sctp_do_8_2_transport_strike
 	if (net->sctp.pf_enable &&
 	   (transport->state == SCTP_ACTIVE) &&
 	   (transport->error_count < transport->pathmaxrxt) &&
-	   (transport->error_count > asoc->pf_retrans)) {
+	   (transport->error_count > transport->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,
 					     SCTP_TRANSPORT_PF,


