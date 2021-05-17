Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963A8383034
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbhEQOZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239225AbhEQOW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E84613BE;
        Mon, 17 May 2021 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260719;
        bh=Gyz8a5InTYkZXWKi7pCFWIwgU7luEqB4PmUgOTWukFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBGXtG3p8YJUwMMq7bFAKEOQZrgRyEW82K835pfIjBv9SoxipF44tS0FNwV8d9Jdk
         GjEOzhMkfoUEN9nE2XIbIG06ywvj7iO8yO+MZnPm1pbWtif6EiV/D6Qjkb+6L8OLOq
         rIDtfW0p+gehTIY7WTcj4wpo8CJ1tHGhKBSQq0eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 208/363] sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b
Date:   Mon, 17 May 2021 16:01:14 +0200
Message-Id: <20210517140309.617599358@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f282df0391267fb2b263da1cc3233aa6fb81defc ]

Normally SCTP_MIB_CURRESTAB is always incremented once asoc enter into
ESTABLISHED from the state < ESTABLISHED and decremented when the asoc
is being deleted.

However, in sctp_sf_do_dupcook_b(), the asoc's state can be changed to
ESTABLISHED from the state >= ESTABLISHED where it shouldn't increment
SCTP_MIB_CURRESTAB. Otherwise, one asoc may increment MIB_CURRESTAB
multiple times but only decrement once at the end.

I was able to reproduce it by using scapy to do the 4-way shakehands,
after that I replayed the COOKIE-ECHO chunk with 'peer_vtag' field
changed to different values, and SCTP_MIB_CURRESTAB was incremented
multiple times and never went back to 0 even when the asoc was freed.

This patch is to fix it by only incrementing SCTP_MIB_CURRESTAB when
the state < ESTABLISHED in sctp_sf_do_dupcook_b().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index c7138f85f18f..73bb4c6e9201 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1944,7 +1944,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
 	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_ESTABLISHED));
-	SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
+	if (asoc->state < SCTP_STATE_ESTABLISHED)
+		SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
 
 	repl = sctp_make_cookie_ack(new_asoc, chunk);
-- 
2.30.2



