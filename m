Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3401F35BC92
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhDLInr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237534AbhDLIno (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B1E961288;
        Mon, 12 Apr 2021 08:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217007;
        bh=cmHVdTf/6f6hO/2gg50eFrVxz8QJJAGwBLV/6AxIydc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL0vidfh/UbSeYJ82X9P2JBMgXKhnf1eYS3/y49TuHwmUHDVrlh3HbjESBEfvbaVh
         Yos4vBrjfOpFhlh1wicWkBgwPHReSqfSjUPeta7lKSDPhassPSW4i+j91DCMlfD1K7
         uYLFlZNN5a8uRJASlRi9NGK8qecnGbMmp6jtM8TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <musamaanjum@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/66] net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh
Date:   Mon, 12 Apr 2021 10:40:14 +0200
Message-Id: <20210412083958.410192221@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <musamaanjum@gmail.com>

commit 864db232dc7036aa2de19749c3d5be0143b24f8f upstream.

nlh is being checked for validtity two times when it is dereferenced in
this function. Check for validity again when updating the flags through
nlh pointer to make the dereferencing safe.

CC: <stable@vger.kernel.org>
Addresses-Coverity: ("NULL pointer dereference")
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4514,9 +4514,11 @@ static int ip6_route_multipath_add(struc
 		 * nexthops have been replaced by first new, the rest should
 		 * be added to it.
 		 */
-		cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
-						     NLM_F_REPLACE);
-		cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
+		if (cfg->fc_nlinfo.nlh) {
+			cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
+							     NLM_F_REPLACE);
+			cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
+		}
 		nhn++;
 	}
 


