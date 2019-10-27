Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7AE6E669F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbfJ0VNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730296AbfJ0VNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:13:35 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC9E21848;
        Sun, 27 Oct 2019 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210814;
        bh=vW1v0bdiaoO5qLt/wRfmrZMyJ9hLMVSRboHbA1ea6v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRZ0CYFJOJ7w6FfAOoLLPReehl/NVWs+nX/JJT7IlBybaFs+7QInjE6juM0rebXwq
         zsu94gfKnhD7I5PkL0s05eidppw3pNfuv+5Ehfy1m000zR+bZE3cPqH//pcIABAN0u
         hiCmIIKtmYp0dPdPd8+Qd8rTlkHq8cbauW9qmwzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Walter <walteste@inf.ethz.ch>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Coddington <bcodding@redhat.com>,
        Gonzalo Siero <gsierohu@redhat.com>
Subject: [PATCH 4.19 26/93] ipv4: Return -ENETUNREACH if we cant create route but saddr is valid
Date:   Sun, 27 Oct 2019 22:00:38 +0100
Message-Id: <20191027203256.485343857@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 595e0651d0296bad2491a4a29a7a43eae6328b02 ]

...instead of -EINVAL. An issue was found with older kernel versions
while unplugging a NFS client with pending RPCs, and the wrong error
code here prevented it from recovering once link is back up with a
configured address.

Incidentally, this is not an issue anymore since commit 4f8943f80883
("SUNRPC: Replace direct task wakeups from softirq context"), included
in 5.2-rc7, had the effect of decoupling the forwarding of this error
by using SO_ERROR in xs_wake_error(), as pointed out by Benjamin
Coddington.

To the best of my knowledge, this isn't currently causing any further
issue, but the error code doesn't look appropriate anyway, and we
might hit this in other paths as well.

In detail, as analysed by Gonzalo Siero, once the route is deleted
because the interface is down, and can't be resolved and we return
-EINVAL here, this ends up, courtesy of inet_sk_rebuild_header(),
as the socket error seen by tcp_write_err(), called by
tcp_retransmit_timer().

In turn, tcp_write_err() indirectly calls xs_error_report(), which
wakes up the RPC pending tasks with a status of -EINVAL. This is then
seen by call_status() in the SUN RPC implementation, which aborts the
RPC call calling rpc_exit(), instead of handling this as a
potentially temporary condition, i.e. as a timeout.

Return -EINVAL only if the input parameters passed to
ip_route_output_key_hash_rcu() are actually invalid (this is the case
if the specified source address is multicast, limited broadcast or
all zeroes), but return -ENETUNREACH in all cases where, at the given
moment, the given source address doesn't allow resolving the route.

While at it, drop the initialisation of err to -ENETUNREACH, which
was added to __ip_route_output_key() back then by commit
0315e3827048 ("net: Fix behaviour of unreachable, blackhole and
prohibit routes"), but actually had no effect, as it was, and is,
overwritten by the fib_lookup() return code assignment, and anyway
ignored in all other branches, including the if (fl4->saddr) one:
I find this rather confusing, as it would look like -ENETUNREACH is
the "default" error, while that statement has no effect.

Also note that after commit fc75fc8339e7 ("ipv4: dont create routes
on down devices"), we would get -ENETUNREACH if the device is down,
but -EINVAL if the source address is specified and we can't resolve
the route, and this appears to be rather inconsistent.

Reported-by: Stefan Walter <walteste@inf.ethz.ch>
Analysed-by: Benjamin Coddington <bcodding@redhat.com>
Analysed-by: Gonzalo Siero <gsierohu@redhat.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2381,14 +2381,17 @@ struct rtable *ip_route_output_key_hash_
 	int orig_oif = fl4->flowi4_oif;
 	unsigned int flags = 0;
 	struct rtable *rth;
-	int err = -ENETUNREACH;
+	int err;
 
 	if (fl4->saddr) {
-		rth = ERR_PTR(-EINVAL);
 		if (ipv4_is_multicast(fl4->saddr) ||
 		    ipv4_is_lbcast(fl4->saddr) ||
-		    ipv4_is_zeronet(fl4->saddr))
+		    ipv4_is_zeronet(fl4->saddr)) {
+			rth = ERR_PTR(-EINVAL);
 			goto out;
+		}
+
+		rth = ERR_PTR(-ENETUNREACH);
 
 		/* I removed check for oif == dev_out->oif here.
 		   It was wrong for two reasons:


