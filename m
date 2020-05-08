Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE61CAC0E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgEHMtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgEHMti (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA8CC218AC;
        Fri,  8 May 2020 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942178;
        bh=brmIHDI2OIjf6X5qfGk9j3hdw4WiFOYPiZME2ivsH5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De0VOPdsOkJJ8RyoEmUZ2EcHiTaW6szwsMIlCH8GtlUbk1+8ugLYKGmasKKs7kylD
         2D16ULh0EX9hG4EdJk+96kNvkEAsHRdTbB5jvxfBn0A7iU543LI/1JZUu9m0Bbqyxw
         82lrCSQooNCvWIrKW40A7nkroVeAdOKWPTeenLYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 16/18] sctp: Fix SHUTDOWN CTSN Ack in the peer restart case
Date:   Fri,  8 May 2020 14:35:19 +0200
Message-Id: <20200508123034.158652178@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123030.497793118@linuxfoundation.org>
References: <20200508123030.497793118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jere Leppänen <jere.leppanen@nokia.com>

commit 12dfd78e3a74825e6f0bc8df7ef9f938fbc6bfe3 upstream.

When starting shutdown in sctp_sf_do_dupcook_a(), get the value for
SHUTDOWN Cumulative TSN Ack from the new association, which is
reconstructed from the cookie, instead of the old association, which
the peer doesn't have anymore.

Otherwise the SHUTDOWN is either ignored or replied to with an ABORT
by the peer because CTSN Ack doesn't match the peer's Initial TSN.

Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket is closed.")
Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sctp/sm_make_chunk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -856,7 +856,11 @@ struct sctp_chunk *sctp_make_shutdown(co
 	sctp_shutdownhdr_t shut;
 	__u32 ctsn;
 
-	ctsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map);
+	if (chunk && chunk->asoc)
+		ctsn = sctp_tsnmap_get_ctsn(&chunk->asoc->peer.tsn_map);
+	else
+		ctsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map);
+
 	shut.cum_tsn_ack = htonl(ctsn);
 
 	retval = sctp_make_control(asoc, SCTP_CID_SHUTDOWN, 0,


