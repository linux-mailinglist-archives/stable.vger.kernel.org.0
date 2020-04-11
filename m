Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9BC1A4FC8
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgDKMLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgDKMLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:11:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103E3215A4;
        Sat, 11 Apr 2020 12:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607097;
        bh=wjsPonv04TDwjYRoFnqSJdDu9tOwOMFKJaUUT5iV0x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok/qvI/mn2079ro2kaIMv8x2T72dSme+C3wmCBPGJDbm2hsz8rYdEIYVvkK2+2BXI
         GW5vAXLTYBby1q89BW6wPHIaTPARLD1o+WqZ2lX8U+Xjbw4x9vrzlttCBEww0BKc3n
         B6e/JWQ+qj0Wo1V3mCuKD0rEnkQVEKnX4l78MrJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Shailabh Nagar <nagar@watson.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 20/29] tools/accounting/getdelays.c: fix netlink attribute length
Date:   Sat, 11 Apr 2020 14:08:50 +0200
Message-Id: <20200411115411.267967922@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 4054ab64e29bb05b3dfe758fff3c38a74ba753bb upstream.

A recent change to the netlink code: 6e237d099fac ("netlink: Relax attr
validation for fixed length types") logs a warning when programs send
messages with invalid attributes (e.g., wrong length for a u32).  Yafang
reported this error message for tools/accounting/getdelays.c.

send_cmd() is wrongly adding 1 to the attribute length.  As noted in
include/uapi/linux/netlink.h nla_len should be NLA_HDRLEN + payload
length, so drop the +1.

Fixes: 9e06d3f9f6b1 ("per task delay accounting taskstats interface: documentation fix")
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200327173111.63922-1-dsahern@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/accounting/getdelays.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -135,7 +135,7 @@ static int send_cmd(int sd, __u16 nlmsg_
 	msg.g.version = 0x1;
 	na = (struct nlattr *) GENLMSG_DATA(&msg);
 	na->nla_type = nla_type;
-	na->nla_len = nla_len + 1 + NLA_HDRLEN;
+	na->nla_len = nla_len + NLA_HDRLEN;
 	memcpy(NLA_DATA(na), nla_data, nla_len);
 	msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
 


