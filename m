Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C27CB85F4
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407176AbfISWZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394131AbfISWW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D649B21920;
        Thu, 19 Sep 2019 22:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931778;
        bh=AB1E/MbgpqzKN9ZmRscBe9uf/LgHfzWk8FJCCK5DZe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lg15LTHOAw2NgTFaKehXXmUcPPRCsg9qUwfuHl5UU6oCUOuhyCVnCN9r1V4KsGHc+
         VMffYhBvOMxfO3hduwXrltamTxorh5XR1UOi5R8muTClFZki1KlGdWaNIPP1HKDEkG
         HVU57ZWfn/n89IGh+hny9VlEdw1uPpsjiWqY7bRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 08/56] sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
Date:   Fri, 20 Sep 2019 00:03:49 +0200
Message-Id: <20190919214747.939647334@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
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
@@ -505,7 +505,7 @@ static void sctp_do_8_2_transport_strike
 	 */
 	if ((transport->state == SCTP_ACTIVE) &&
 	   (transport->error_count < transport->pathmaxrxt) &&
-	   (transport->error_count > asoc->pf_retrans)) {
+	   (transport->error_count > transport->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,
 					     SCTP_TRANSPORT_PF,


