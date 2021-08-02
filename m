Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C80B3DD902
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbhHBN4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234620AbhHBNwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DDC160555;
        Mon,  2 Aug 2021 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912308;
        bh=+dsKwnnReKoHkgjNqx1g7+OyrDcwFH6QCnfIcEnTTsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znAjx3ZMIzqsWV0VAYMvoyVP2tGPdxkqCknjHBi628tzURjPqik3N0TcmhEQ74Wii
         yq//58kPElZzS6ffygGiiUbBY/bqpfqZTRZYDFXj294jTLXna1xgTKefKb7OzIuniU
         A+OmUPcEumZAzs5XFYCnYxjd2SYxMUkzMPR0LgGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaochen Zou <xzou017@ucr.edu>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 40/40] can: j1939: j1939_session_deactivate(): clarify lifetime of session object
Date:   Mon,  2 Aug 2021 15:45:20 +0200
Message-Id: <20210802134336.673660790@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 0c71437dd50dd687c15d8ca80b3b68f10bb21d63 upstream.

The j1939_session_deactivate() is decrementing the session ref-count and
potentially can free() the session. This would cause use-after-free
situation.

However, the code calling j1939_session_deactivate() does always hold
another reference to the session, so that it would not be free()ed in
this code path.

This patch adds a comment to make this clear and a WARN_ON, to ensure
that future changes will not violate this requirement. Further this
patch avoids dereferencing the session pointer as a precaution to avoid
use-after-free if the session is actually free()ed.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/r/20210714111602.24021-1-o.rempel@pengutronix.de
Reported-by: Xiaochen Zou <xzou017@ucr.edu>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1075,11 +1075,16 @@ static bool j1939_session_deactivate_loc
 
 static bool j1939_session_deactivate(struct j1939_session *session)
 {
+	struct j1939_priv *priv = session->priv;
 	bool active;
 
-	j1939_session_list_lock(session->priv);
+	j1939_session_list_lock(priv);
+	/* This function should be called with a session ref-count of at
+	 * least 2.
+	 */
+	WARN_ON_ONCE(kref_read(&session->kref) < 2);
 	active = j1939_session_deactivate_locked(session);
-	j1939_session_list_unlock(session->priv);
+	j1939_session_list_unlock(priv);
 
 	return active;
 }


