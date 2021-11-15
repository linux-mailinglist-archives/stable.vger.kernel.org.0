Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432A2451173
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbhKOTIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240751AbhKOTF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:05:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10722633DB;
        Mon, 15 Nov 2021 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000180;
        bh=GAzVAPTE69AY6PAlkLKOCa7SLfphR169bzNECnoBx8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R95L5elysymDxiWzDMkZDQieCArfgpLFCERWjdX0o4Sa4VHQnPhtD+z44CksFucxe
         wMTDctZ7k2ryHrJkVoM3T3b+RwTllb4a6Up9kHnLkmzc8BEXj5/Ml7yUOwafuD71/z
         GbMwU/ccbfYse9FDstnNy0vGsJdv8hLbnaTRu3Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 533/849] sctp: return true only for pathmtu update in sctp_transport_pl_toobig
Date:   Mon, 15 Nov 2021 18:00:16 +0100
Message-Id: <20211115165438.299254322@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 75cf662c64dd8543f56c329c69eba18141c8fd9f ]

sctp_transport_pl_toobig() supposes to return true only if there's
pathmtu update, so that in sctp_icmp_frag_needed() it would call
sctp_assoc_sync_pmtu() and sctp_retransmit(). This patch is to fix
these return places in sctp_transport_pl_toobig().

Fixes: 836964083177 ("sctp: do state transition when receiving an icmp TOOBIG packet")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 1f2dfad768d52..133f1719bf1b7 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -368,6 +368,7 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			return true;
 		}
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
 		if (pmtu >= SCTP_BASE_PLPMTU && pmtu < t->pl.pmtu) {
@@ -378,11 +379,10 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 			t->pl.probe_high = 0;
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			return true;
 		} else if (pmtu > t->pl.pmtu && pmtu < t->pl.probe_size) {
 			t->pl.probe_size = pmtu;
 			t->pl.probe_count = 0;
-
-			return false;
 		}
 	} else if (t->pl.state == SCTP_PL_COMPLETE) {
 		if (pmtu >= SCTP_BASE_PLPMTU && pmtu < t->pl.pmtu) {
@@ -393,10 +393,11 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 			t->pl.probe_high = 0;
 			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+			return true;
 		}
 	}
 
-	return true;
+	return false;
 }
 
 bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
-- 
2.33.0



