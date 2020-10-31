Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392A52A15E0
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgJaLfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbgJaLfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC5220739;
        Sat, 31 Oct 2020 11:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144139;
        bh=rweIGlG+ZbtlwpDdeVwPAUBqIuux5pYn8QHPnRHFzyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lY50UJeGMGJ+T2NqRA+xTV33DLw/RaOYSQkzg4aqmmjcu5gEhUEwM9LL1v1t7TVPw
         esUr6tSDVt80j+ov62Lt1kKo3Fm4cMY7y+bzczvF1BEPm6n+fTqac6IUXYkk1CIpAA
         5VdQKkrLlQ+j6ilGY4OoZ5b0ceesk+H8Eqvsg1i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 02/49] socket: dont clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled
Date:   Sat, 31 Oct 2020 12:34:58 +0100
Message-Id: <20201031113455.565850615@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit 4e3bbb33e6f36e4b05be1b1b9b02e3dd5aaa3e69 upstream.

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
@@ -923,7 +923,6 @@ set_rcvbuf:
 		} else {
 			sock_reset_flag(sk, SOCK_RCVTSTAMP);
 			sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_reset_flag(sk, SOCK_TSTAMP_NEW);
 		}
 		break;
 


