Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888841C1496
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgEANlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbgEANlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79410208DB;
        Fri,  1 May 2020 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340459;
        bh=vvE3TtarqiqFcQ9034O6c6gzuzlgyDUK67pLiVR1O8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuG2KULItIJE4NP05L+Uz/53dk5bRbGb0oKh3aIFFNpRuef+Qz74HiODfcYI/G3L3
         szPWvV1sWY8bZL0EilLiybLvrTsM4gn/z8xgolQiItErSs6IRE4xZILABdzKjrFZPV
         B18zutP+10PX21GnqwcKGKV8bW6YSFIiLr3cdrtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Syromiatnikov <esyr@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 76/83] taprio: do not use BIT() in TCA_TAPRIO_ATTR_FLAG_* definitions
Date:   Fri,  1 May 2020 15:23:55 +0200
Message-Id: <20200501131542.110508340@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Syromiatnikov <esyr@redhat.com>

commit 673040c3a82a7564423e09c791e242a846591e30 upstream.

BIT() macro definition is internal to the Linux kernel and is not
to be used in UAPI headers; replace its usage with the _BITUL() macro
that is already used elsewhere in the header.

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/pkt_sched.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1160,8 +1160,8 @@ enum {
  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
  */
 
-#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	BIT(0)
-#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	BIT(1)
+#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
+#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
 
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,


