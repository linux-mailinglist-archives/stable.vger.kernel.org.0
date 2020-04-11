Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E521A4FB4
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgDKMK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgDKMKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:10:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656EF20787;
        Sat, 11 Apr 2020 12:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607053;
        bh=RFJIfy9W+Q0N57EzhTdawISFExCi5EriOmkwKyuQ5Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1/id3wk4cRb/dv3gSGM7bpfA7T7hS0lzJWi+4achyOC6yak3gdM+uT7DkWcrahqw
         4lqjt2uYnjlLf/UZ6vjmWyFQm00C3d6E+qSywG6sHnlomaYkZoQBsZl71Q4Ox7bOSO
         FsIIv1g3mjJpLiN1oTjR2jVA/BQ1DoWcplpwRYQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.4 08/29] l2tp: ensure session cant get removed during pppol2tp_session_ioctl()
Date:   Sat, 11 Apr 2020 14:08:38 +0200
Message-Id: <20200411115409.008779923@linuxfoundation.org>
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

From: Guillaume Nault <g.nault@alphalink.fr>

commit 57377d63547861919ee634b845c7caa38de4a452 upstream.

Holding a reference on session is required before calling
pppol2tp_session_ioctl(). The session could get freed while processing the
ioctl otherwise. Since pppol2tp_session_ioctl() uses the session's socket,
we also need to take a reference on it in l2tp_session_get().

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1168,11 +1168,18 @@ static int pppol2tp_tunnel_ioctl(struct
 		if (stats.session_id != 0) {
 			/* resend to session ioctl handler */
 			struct l2tp_session *session =
-				l2tp_session_find(sock_net(sk), tunnel, stats.session_id);
-			if (session != NULL)
-				err = pppol2tp_session_ioctl(session, cmd, arg);
-			else
+				l2tp_session_get(sock_net(sk), tunnel,
+						 stats.session_id, true);
+
+			if (session) {
+				err = pppol2tp_session_ioctl(session, cmd,
+							     arg);
+				if (session->deref)
+					session->deref(session);
+				l2tp_session_dec_refcount(session);
+			} else {
 				err = -EBADR;
+			}
 			break;
 		}
 #ifdef CONFIG_XFRM


