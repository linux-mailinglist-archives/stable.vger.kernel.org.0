Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CEF19C817
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbgDBRdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389989AbgDBRdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:33:05 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B0952078B;
        Thu,  2 Apr 2020 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848784;
        bh=sJF7vQJ8ozzfmrxTOD4ZSjgxGMIIeoVp+SeF6PQjLt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akwTSgasVO4KUgnagC8cQGTnd2zVWGrlHF6D+l6a4FGxBMezTYJX9a9+f/F+z+sZN
         4XldhxcpxFs9Rhh21X1ijO9ZhsQthJOpNMZv3K5FpzW/D20T6BQy05iaX2uOcdOx8E
         xtTedkFHsQxb5rQRxUE/qys1oXCbl8X6sz0kZvqc=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4/8] l2tp: ensure session can't get removed during pppol2tp_session_ioctl()
Date:   Thu,  2 Apr 2020 18:32:46 +0100
Message-Id: <20200402173250.7858-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402173250.7858-1-will@kernel.org>
References: <20200402173250.7858-1-will@kernel.org>
MIME-Version: 1.0
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
---
 net/l2tp/l2tp_ppp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index bc5fca07d2ee..74b211312d4d 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1168,11 +1168,18 @@ static int pppol2tp_tunnel_ioctl(struct l2tp_tunnel *tunnel,
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
-- 
2.26.0.rc2.310.g2932bb562d-goog

