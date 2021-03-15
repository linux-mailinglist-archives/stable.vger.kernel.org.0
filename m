Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F7933B653
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhCON5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhCON5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22FA64EED;
        Mon, 15 Mar 2021 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816617;
        bh=YFrVHkSmnBUXIH4k+iOLP0UXegrJ1zI1zz5bKlhSZvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sB9M6bDhEZH+s58O2rtKB/rrXQ2lSRceWwCDcLP1v6trikGVxdc0w/My8LAa20+SQ
         23iic83kksoxxstibJe3yFvccTOc8eXs9SIQyxzOrbejyesiyRBzBCg8uTs6Zpx2Wc
         UewFLWyFzjrWF7NMNWtHOeGCjTnfeFe/mJRTAxgQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arjun Roy <arjunroy@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 023/306] tcp: Fix sign comparison bug in getsockopt(TCP_ZEROCOPY_RECEIVE)
Date:   Mon, 15 Mar 2021 14:51:26 +0100
Message-Id: <20210315135508.410372732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Arjun Roy <arjunroy@google.com>

commit 2107d45f17bedd7dbf4178462da0ac223835a2a7 upstream.

getsockopt(TCP_ZEROCOPY_RECEIVE) has a bug where we read a
user-provided "len" field of type signed int, and then compare the
value to the result of an "offsetofend" operation, which is unsigned.

Negative values provided by the user will be promoted to large
positive numbers; thus checking that len < offsetofend() will return
false when the intention was that it return true.

Note that while len is originally checked for negative values earlier
on in do_tcp_getsockopt(), subsequent calls to get_user() re-read the
value from userspace which may have changed in the meantime.

Therefore, re-add the check for negative values after the call to
get_user in the handler code for TCP_ZEROCOPY_RECEIVE.

Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Arjun Roy <arjunroy@google.com>
Link: https://lore.kernel.org/r/20210225232628.4033281-1-arjunroy.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4088,7 +4088,8 @@ static int do_tcp_getsockopt(struct sock
 
 		if (get_user(len, optlen))
 			return -EFAULT;
-		if (len < offsetofend(struct tcp_zerocopy_receive, length))
+		if (len < 0 ||
+		    len < offsetofend(struct tcp_zerocopy_receive, length))
 			return -EINVAL;
 		if (len > sizeof(zc)) {
 			len = sizeof(zc);


