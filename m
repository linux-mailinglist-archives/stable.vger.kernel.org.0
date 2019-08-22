Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D14D99BA2
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404685AbfHVR0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404680AbfHVR0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:16 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210DA2064A;
        Thu, 22 Aug 2019 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494776;
        bh=yzV8aBirFxzFdB6YbMsMP8IDuhdboW/Ikz5v6e2tgTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AT9TOo004PLtW4WU5NZb7XITGPwxRbirO7wIyYNEWHpk3Szf4wx/cJ6pvOVXNUBzs
         Usf1UDGHLAkHRfMbidMJRr7aH1Lij21g8mVXV0nf/wykMXozB4EnI+bFyIynZNqUWy
         /3KNiie644FI/zRor0w3GmB15CeXK5RsqXrsQT6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 81/85] tipc: initialise addr_trail_end when setting node addresses
Date:   Thu, 22 Aug 2019 10:19:54 -0700
Message-Id: <20190822171734.586180140@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 8874ecae2977e5a2d4f0ba301364435b81c05938 ]

We set the field 'addr_trial_end' to 'jiffies', instead of the current
value 0, at the moment the node address is initialized. This guarantees
we don't inadvertently enter an address trial period when the node
address is explicitly set by the user.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/addr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/addr.c
+++ b/net/tipc/addr.c
@@ -75,6 +75,7 @@ void tipc_set_node_addr(struct net *net,
 		tipc_set_node_id(net, node_id);
 	}
 	tn->trial_addr = addr;
+	tn->addr_trial_end = jiffies;
 	pr_info("32-bit node address hash set to %x\n", addr);
 }
 


