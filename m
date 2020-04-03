Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4744E19DF6F
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 22:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgDCUet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 16:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUet (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 16:34:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7D02076E;
        Fri,  3 Apr 2020 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585946087;
        bh=Jjhpx8lwJvjrss0F1Ruu9JKolc6g01G5wUrLor9BF9w=;
        h=Date:From:To:Subject:From;
        b=eQtAhGLmUmC7WM0C4ebPoI564ncX+DN3mrZ3p/Dc94Q4ZO2Gu+YALx+wguQ9zAMmA
         Ct3qg/QpcR2hSmdSqhVyZ/4PIepxpjVYFD79BpPriJAj5bYv4TNaorzNetPfZKCFej
         EZIZ4K5oCPNobONlqRe3P2sCqiF+csLkDFUkwJyo=
Date:   Fri, 03 Apr 2020 13:34:46 -0700
From:   akpm@linux-foundation.org
To:     dsahern@kernel.org, johannes@sipsolutions.net,
        laoar.shao@gmail.com, mm-commits@vger.kernel.org,
        nagar@watson.ibm.com, stable@vger.kernel.org
Subject:  [merged] getdelays-fix-netlink-attribute-length.patch
 removed from -mm tree
Message-ID: <20200403203446.7Y-81g_t1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tools/accounting/getdelays.c: fix netlink attribute length
has been removed from the -mm tree.  Its filename was
     getdelays-fix-netlink-attribute-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dsahern@kernel.org are


