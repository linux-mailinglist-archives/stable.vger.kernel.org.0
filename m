Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A04338A4D2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhETKKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235707AbhETKHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30BC561425;
        Thu, 20 May 2021 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503718;
        bh=/vRINm2inUXT1BBueNtSb1XjWGGJo/Mnn0HPG+2sUvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVfDg/RsLtmV1Bw34ERGYlCR6VYTmRBY4+0eHG8IScjePvSYHMnhwieKdCzdFqg9b
         fdjUGflTKSYnQ3bNRcRa86kwIG8f3K6fS4GfcWvcS2O5E3x5sQH/Ssz9X00b+Vqx+u
         7vvQqGI63rfatRerWjWgIXOg350Olht9zF2K6T5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 348/425] sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b
Date:   Thu, 20 May 2021 11:21:57 +0200
Message-Id: <20210520092142.843961400@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 882cd5f40a0a..be5ea5e8b19e 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1948,7 +1948,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
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



