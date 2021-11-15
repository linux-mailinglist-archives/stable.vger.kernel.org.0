Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673604513FD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348823AbhKOUAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344157AbhKOTXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F3263309;
        Mon, 15 Nov 2021 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002377;
        bh=6A4ZhmQazWHCbZUPJML7CESiRJKd+cWp6qyLwSEpfQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehLJmg/nL68KKq3zcdOOJnhAfxoGvL4NeHvyTvcvJbEdFon1NlGK679IXYiNjDgwg
         6Y/aR8hUJzPAnBd4pghBsRDukXqUiBrrmi0VFKtLNTEH3XVH2VMOhyVH1nsFc7Gha2
         c5neiHrto5PLIhB7bO2pmqb3FOxzCpdPJnhHcvd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 543/917] sctp: reset probe_timer in sctp_transport_pl_update
Date:   Mon, 15 Nov 2021 18:00:38 +0100
Message-Id: <20211115165447.169007036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit c6ea04ea692fa0d8e7faeb133fcd28e3acf470a0 ]

sctp_transport_pl_update() is called when transport update its dst and
pathmtu, instead of stopping the PLPMTUD probe timer, PLPMTUD should
start over and reset the probe timer. Otherwise, the PLPMTUD service
would stop.

Fixes: 92548ec2f1f9 ("sctp: add the probe timer in transport for PLPMTUD")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 69bab88ad66b1..bc00410223b03 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -653,12 +653,10 @@ static inline void sctp_transport_pl_update(struct sctp_transport *t)
 	if (t->pl.state == SCTP_PL_DISABLED)
 		return;
 
-	if (del_timer(&t->probe_timer))
-		sctp_transport_put(t);
-
 	t->pl.state = SCTP_PL_BASE;
 	t->pl.pmtu = SCTP_BASE_PLPMTU;
 	t->pl.probe_size = SCTP_BASE_PLPMTU;
+	sctp_transport_reset_probe_timer(t);
 }
 
 static inline bool sctp_transport_pl_enabled(struct sctp_transport *t)
-- 
2.33.0



