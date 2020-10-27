Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C2029C164
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775679AbgJ0OxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766322AbgJ0OsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBBA21556;
        Tue, 27 Oct 2020 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810092;
        bh=nNd1aTy7IdqvLlg8BaABLpBD5kG9tu04CLwxx/nojAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7Ayu1ZnxwkxTu0+ZMHNIHFwoMq/atUNR2ATzHJWilJ4Vz8sBt5spySjmbH1jg5YP
         f4FAy3OqFQwDnzlnGlibbpsWYayQal1Wj5tVZ4L3bSAoDS03UfvqQgiBcC7mh6NLI7
         h2yITBxJXfvGZx9QJCBR0tw9I0XZQ7p4D5LLypYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 018/633] socket: fix option SO_TIMESTAMPING_NEW
Date:   Tue, 27 Oct 2020 14:46:01 +0100
Message-Id: <20201027135523.540256958@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 59e611a566e7cd48cf54b6777a11fe3f9c2f9db5 ]

The comparison of optname with SO_TIMESTAMPING_NEW is wrong way around,
so SOCK_TSTAMP_NEW will first be set and than reset again. Additionally
move it out of the test for SOF_TIMESTAMPING_RX_SOFTWARE as this seems
unrelated.

This problem happens on 32 bit platforms were the libc has already
switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
socket options). ptp4l complains with "missing timestamp on transmitted
peer delay request" because the wrong format is received (and
discarded).

Fixes: 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1007,8 +1007,6 @@ set_sndbuf:
 		__sock_set_timestamps(sk, valbool, true, true);
 		break;
 	case SO_TIMESTAMPING_NEW:
-		sock_set_flag(sk, SOCK_TSTAMP_NEW);
-		/* fall through */
 	case SO_TIMESTAMPING_OLD:
 		if (val & ~SOF_TIMESTAMPING_MASK) {
 			ret = -EINVAL;
@@ -1037,16 +1035,14 @@ set_sndbuf:
 		}
 
 		sk->sk_tsflags = val;
+		sock_valbool_flag(sk, SOCK_TSTAMP_NEW, optname == SO_TIMESTAMPING_NEW);
+
 		if (val & SOF_TIMESTAMPING_RX_SOFTWARE)
 			sock_enable_timestamp(sk,
 					      SOCK_TIMESTAMPING_RX_SOFTWARE);
-		else {
-			if (optname == SO_TIMESTAMPING_NEW)
-				sock_reset_flag(sk, SOCK_TSTAMP_NEW);
-
+		else
 			sock_disable_timestamp(sk,
 					       (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE));
-		}
 		break;
 
 	case SO_RCVLOWAT:


