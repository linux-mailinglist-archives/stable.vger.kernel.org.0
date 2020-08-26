Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD3A252DCB
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgHZMGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgHZMDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6AC20B1F;
        Wed, 26 Aug 2020 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443411;
        bh=XFf6WD/mS3WUjtPuRD+AuZx4AOOaYLXdV+Z07SqZ1wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHqn7Zn2QIXZyPsX+BSLQ77zSPv+GExF4MMu/XxlI792/R+GkQeJShNKmDde0WxBw
         f16OSMqaubwkAvJhJBP+aCErUYRQkLulFoYpln02F8qAESBdIE/+YYfTtGITNvi+9a
         HClJmmkIeuEhK8t3t7vS27Cv/vKlIN6xzTmnDxhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 14/16] netlink: fix state reallocation in policy export
Date:   Wed, 26 Aug 2020 14:02:51 +0200
Message-Id: <20200826114911.918676140@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
References: <20200826114911.216745274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d1fb55592909ea249af70170c7a52e637009564d ]

Evidently, when I did this previously, we didn't have more than
10 policies and didn't run into the reallocation path, because
it's missing a memset() for the unused policies. Fix that.

Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/policy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -51,6 +51,9 @@ static int add_policy(struct nl_policy_d
 	if (!state)
 		return -ENOMEM;
 
+	memset(&state->policies[state->n_alloc], 0,
+	       flex_array_size(state, policies, n_alloc - state->n_alloc));
+
 	state->policies[state->n_alloc].policy = policy;
 	state->policies[state->n_alloc].maxtype = maxtype;
 	state->n_alloc = n_alloc;


