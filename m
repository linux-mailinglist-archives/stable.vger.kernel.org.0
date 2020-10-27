Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B5429C355
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760010AbgJ0Oaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759279AbgJ0O2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:28:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B138206DC;
        Tue, 27 Oct 2020 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808926;
        bh=xgx1so219T4rWZKoJhHNU5YSg4YydUSkx+/hJ2YQFVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNWShjuSjW/pvN0K0VZ3Gkjk6tlcZjVX9DLJ2Veap9aEUAqxqSHoNchspv2b9QzdG
         xz2QK8MAe9JEY8fUsySIdqK7nUaWWdC9/TSyGbd5gWS2KqmjFp13sgSAOWv2c0RKOc
         3Gplnzc6ePhbN4YBTx7TcBMdWSxWj7swA707T0ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 012/408] socket: fix option SO_TIMESTAMPING_NEW
Date:   Tue, 27 Oct 2020 14:49:10 +0100
Message-Id: <20201027135455.624667809@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
@@ -928,8 +928,6 @@ set_rcvbuf:
 		break;
 
 	case SO_TIMESTAMPING_NEW:
-		sock_set_flag(sk, SOCK_TSTAMP_NEW);
-		/* fall through */
 	case SO_TIMESTAMPING_OLD:
 		if (val & ~SOF_TIMESTAMPING_MASK) {
 			ret = -EINVAL;
@@ -958,16 +956,14 @@ set_rcvbuf:
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


