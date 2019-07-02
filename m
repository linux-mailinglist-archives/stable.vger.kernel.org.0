Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE125CBAF
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfGBIPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbfGBIEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5F420659;
        Tue,  2 Jul 2019 08:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054694;
        bh=jIOQbsCP4X+3mrOpraffnVNqY8f0gWvNEEoEDdaJRt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxvUyvpHByVje9LmkQ2WBwt3pKC11e/VDsRcd3ZyKmH/0L0e85IpodulHin9h/ZD9
         YeIb58WFdixCo+5tn3cwq+2StYHsdFvtYHxta8Pir9fByz7RzxNiwO2hG4tvwUu/tL
         3Oh6J3dNMnRoKf39bBDOoNBgNsFrryIj+VuNc/y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com,
        syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 38/55] sctp: change to hold sk after auth shkey is created successfully
Date:   Tue,  2 Jul 2019 10:01:46 +0200
Message-Id: <20190702080126.103992090@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 25bff6d5478b2a02368097015b7d8eb727c87e16 ]

Now in sctp_endpoint_init(), it holds the sk then creates auth
shkey. But when the creation fails, it doesn't release the sk,
which causes a sk defcnf leak,

Here to fix it by only holding the sk when auth shkey is created
successfully.

Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/endpointola.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -133,10 +133,6 @@ static struct sctp_endpoint *sctp_endpoi
 	/* Initialize the bind addr area */
 	sctp_bind_addr_init(&ep->base.bind_addr, 0);
 
-	/* Remember who we are attached to.  */
-	ep->base.sk = sk;
-	sock_hold(ep->base.sk);
-
 	/* Create the lists of associations.  */
 	INIT_LIST_HEAD(&ep->asocs);
 
@@ -169,6 +165,10 @@ static struct sctp_endpoint *sctp_endpoi
 	ep->prsctp_enable = net->sctp.prsctp_enable;
 	ep->reconf_enable = net->sctp.reconf_enable;
 
+	/* Remember who we are attached to.  */
+	ep->base.sk = sk;
+	sock_hold(ep->base.sk);
+
 	return ep;
 
 nomem_shkey:


