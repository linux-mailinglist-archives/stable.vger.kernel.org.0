Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38BE19BAD5
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 06:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgDBEC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 00:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbgDBEC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 00:02:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EFE4206E9;
        Thu,  2 Apr 2020 04:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585800146;
        bh=yEANSQNTDEg3s6+T/qARwfi+FDj8BcnZWcHkBnUGGoc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZctaS9Q18US50tNh3+0RJhcFMHFN1AUNshtzEwAl+e3RPbfuIR/mZlb6a//aFm4Ab
         10SeDC0jOavpEYd8z8n+HPBUPxHFTrm1Tpeltv4Soz1LtsuAJ4EG129cFgwptNH/mf
         m6MP6wepRAm2OHJsyMdHZI1Kx2YssFyb9dm9+vrM=
Date:   Wed, 01 Apr 2020 21:02:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dsahern@kernel.org,
        johannes@sipsolutions.net, laoar.shao@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nagar@watson.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 001/155] tools/accounting/getdelays.c: fix netlink
 attribute length
Message-ID: <20200402040225.favho3pCV%akpm@linux-foundation.org>
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Subject: tools/accounting/getdelays.c: fix netlink attribute length

A recent change to the netlink code: 6e237d099fac ("netlink: Relax attr
validation for fixed length types") logs a warning when programs send
messages with invalid attributes (e.g., wrong length for a u32).  Yafang
reported this error message for tools/accounting/getdelays.c.

send_cmd() is wrongly adding 1 to the attribute length.  As noted in
include/uapi/linux/netlink.h nla_len should be NLA_HDRLEN + payload
length, so drop the +1.

Link: http://lkml.kernel.org/r/20200327173111.63922-1-dsahern@kernel.org
Fixes: 9e06d3f9f6b1 ("per task delay accounting taskstats interface: documentation fix")
Signed-off-by: David Ahern <dsahern@kernel.org>
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/accounting/getdelays.c~getdelays-fix-netlink-attribute-length
+++ a/tools/accounting/getdelays.c
@@ -136,7 +136,7 @@ static int send_cmd(int sd, __u16 nlmsg_
 	msg.g.version = 0x1;
 	na = (struct nlattr *) GENLMSG_DATA(&msg);
 	na->nla_type = nla_type;
-	na->nla_len = nla_len + 1 + NLA_HDRLEN;
+	na->nla_len = nla_len + NLA_HDRLEN;
 	memcpy(NLA_DATA(na), nla_data, nla_len);
 	msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
 
_
