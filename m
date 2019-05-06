Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A839414DD6
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfEFOpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbfEFOpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:45:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B032087F;
        Mon,  6 May 2019 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153907;
        bh=CIKD/B1Zm0gtqABATy0oarRntlk7GQ5gB5VoW1963I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkAI97HGrd9vXolW/DPBhqGzMhOtfFwTiL2zEwuKak1i3WLs71qfoUudSXXRRmMgk
         DnCWyqMTZNCckNKF1rMJ5ix4Wls7RTp5zzHTmmyFEMh8RZYAAWrz/w5inVpVxS5fbr
         F0Wkdoi4UQ4/WSNdoOxK5/7DIe+0GqcP6y7k83po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 04/75] ipv6: invert flowlabel sharing check in process and user mode
Date:   Mon,  6 May 2019 16:32:12 +0200
Message-Id: <20190506143053.652343919@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
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
@@ -640,9 +640,9 @@ recheck:
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


