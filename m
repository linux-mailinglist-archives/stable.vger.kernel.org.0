Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358651EC8B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 12:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEOK6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfEOK6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4FBC20843;
        Wed, 15 May 2019 10:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917929;
        bh=7zboopaMA9k2DkNa3WQVgftBt5PDHUj8PJczGXoSEN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtfcCDMa3jQFQjnu0TvpQOcGT3DiqvVrWTDycaAIJyR7NXeQE7NYBmcGt5y5IhYAw
         yT1gZJcFwG0Xj5ievWK6SYWMduNn7/Wxwtt1rFKIqUxUJjmlBvH1CTJFv91j97y09N
         0iB2Bm9jVLD650Z+9UMNos5rU1V7gqSmOfwYcF70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 29/86] ipv6: invert flowlabel sharing check in process and user mode
Date:   Wed, 15 May 2019 12:55:06 +0200
Message-Id: <20190515090648.566210140@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
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
@@ -629,9 +629,9 @@ recheck:
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


