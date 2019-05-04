Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7A8138ED
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfEDK1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727592AbfEDK1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2238206BB;
        Sat,  4 May 2019 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965669;
        bh=WxviFEhBUVUEYscPUv8ZVWpQNTSHav4t3Z4Ag8TB/i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXIRrpkmOPte8nRlLUZ9Rh5el7KTewWeXhwrRnCrpOo1Ge1CbK0HqljcwWRSCx/iy
         VVinkSq1NGh9Ad6Vft06a8XjMFQ9++pyJhQgRPBCbE4DK0RMMPboywgErPQRwHAzWL
         EpMlnMccCN3vdkM5UzedtzUELWZVAcH5gjj0taks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/23] ipv6: invert flowlabel sharing check in process and user mode
Date:   Sat,  4 May 2019 12:25:07 +0200
Message-Id: <20190504102451.747750335@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 95c169251bf734aa555a1e8043e4d88ec97a04ec ]

A request for a flowlabel fails in process or user exclusive mode must
fail if the caller pid or uid does not match. Invert the test.

Previously, the test was unsafe wrt PID recycling, but indeed tested
for inequality: fl1->owner != fl->owner

Fixes: 4f82f45730c68 ("net ip6 flowlabel: Make owner a union of struct pid* and kuid_t")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_flowlabel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -639,9 +639,9 @@ recheck:
 				if (fl1->share == IPV6_FL_S_EXCL ||
 				    fl1->share != fl->share ||
 				    ((fl1->share == IPV6_FL_S_PROCESS) &&
-				     (fl1->owner.pid == fl->owner.pid)) ||
+				     (fl1->owner.pid != fl->owner.pid)) ||
 				    ((fl1->share == IPV6_FL_S_USER) &&
-				     uid_eq(fl1->owner.uid, fl->owner.uid)))
+				     !uid_eq(fl1->owner.uid, fl->owner.uid)))
 					goto release;
 
 				err = -ENOMEM;


