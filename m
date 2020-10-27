Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586DC29B961
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802420AbgJ0Psb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796415AbgJ0PSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D4122281;
        Tue, 27 Oct 2020 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811895;
        bh=skxQn2Q8BFuMrIntLxxY4y0j8PNdzBpcUrS+8INXU2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZfVZp0ANbMc3xItZ71hyPFB+S4aJASOspLLdGO7z0Xjc1ql3xDoajhzG9hMgiT4s
         NRiZPgyvQ7oVF3qM4ks+BWzGvyW+p3JHe+CgDrmWeprRltrmhp0RWN3xmUE9mGyRSM
         anYkFXZhxFIcMN43JRjjdYrdC4Ij94rXslv1tE/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 021/757] socket: dont clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled
Date:   Tue, 27 Oct 2020 14:44:31 +0100
Message-Id: <20201027135451.514946399@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 4e3bbb33e6f36e4b05be1b1b9b02e3dd5aaa3e69 ]

SOCK_TSTAMP_NEW (timespec64 instead of timespec) is also used for
hardware time stamps (configured via SO_TIMESTAMPING_NEW).

User space (ptp4l) first configures hardware time stamping via
SO_TIMESTAMPING_NEW which sets SOCK_TSTAMP_NEW. In the next step, ptp4l
disables SO_TIMESTAMPNS(_NEW) (software time stamps), but this must not
switch hardware time stamps back to "32 bit mode".

This problem happens on 32 bit platforms were the libc has already
switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
socket options). ptp4l complains with "missing timestamp on transmitted
peer delay request" because the wrong format is received (and
discarded).

Fixes: 887feae36aee ("socket: Add SO_TIMESTAMP[NS]_NEW")
Fixes: 783da70e8396 ("net: add sock_enable_timestamps")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -769,7 +769,6 @@ static void __sock_set_timestamps(struct
 	} else {
 		sock_reset_flag(sk, SOCK_RCVTSTAMP);
 		sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-		sock_reset_flag(sk, SOCK_TSTAMP_NEW);
 	}
 }
 


