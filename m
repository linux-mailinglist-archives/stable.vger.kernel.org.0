Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D6C1F4418
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbgFISAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733092AbgFIRy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECE120774;
        Tue,  9 Jun 2020 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725266;
        bh=4+Cz8ptYSoYm2xcypo5QyXImcSVs9nbjvhvcyN0v64c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnwQIgllwGswcu7NpFpE9/NEPjcvetNjzIot1nGmOXGIl8MwJBAimsRqJp17CJqTO
         6U5MAxfrXl0wcE2pRWyj0La3fjTeqjKjOWBvy+bcZPttXaPWt+kx0GnHGJXunJFqHS
         Jr2zTlk4srqxcrNmpBH0/QtVCNtxxg46maPGeP1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Falkevik <jonas.falkevik@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 10/41] sctp: check assoc before SCTP_ADDR_{MADE_PRIM, ADDED} event
Date:   Tue,  9 Jun 2020 19:45:12 +0200
Message-Id: <20200609174113.106939763@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Falkevik <jonas.falkevik@gmail.com>

[ Upstream commit 45ebf73ebcec88a34a778f5feaa0b82b1c76069e ]

Make sure SCTP_ADDR_{MADE_PRIM,ADDED} are sent only for associations
that have been established.

These events are described in rfc6458#section-6.1
SCTP_PEER_ADDR_CHANGE:
This tag indicates that an address that is
part of an existing association has experienced a change of
state (e.g., a failure or return to service of the reachability
of an endpoint via a specific transport address).

Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/ulpevent.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_chan
 	struct sockaddr_storage addr;
 	struct sctp_ulpevent *event;
 
+	if (asoc->state < SCTP_STATE_ESTABLISHED)
+		return;
+
 	memset(&addr, 0, sizeof(struct sockaddr_storage));
 	memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
 


