Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D93C47AC9F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbhLTOpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:45:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37882 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbhLTOos (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 397F761141;
        Mon, 20 Dec 2021 14:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B308C36AE7;
        Mon, 20 Dec 2021 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011487;
        bh=Cx7fiQV8TDvWr5DRBWGmOgB/tc7QSMtVQ4ojKugAxl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2WrgVmLox6aMieSSEGG5fJ3BGNiPXm8GhrVRhJhz2KIUFn5hqdZPcdgSepnjtHhH
         NTj7RFRrcI+wPSDsz97EyjXT9yQgCf5rdwzv/8kxLYMOYVrkG1pVrdbCc+b/2Er855
         GWzQw+5b4mGeFKEjn0J1HncIKp1CQHU4X/1LPWq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Syzbot <syzbot+1ac0994a0a0c55151121@syzkaller.appspotmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/71] net/packet: rx_owner_map depends on pg_vec
Date:   Mon, 20 Dec 2021 15:34:28 +0100
Message-Id: <20211220143026.991159980@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit ec6af094ea28f0f2dda1a6a33b14cd57e36a9755 ]

Packet sockets may switch ring versions. Avoid misinterpreting state
between versions, whose fields share a union. rx_owner_map is only
allocated with a packet ring (pg_vec) and both are swapped together.
If pg_vec is NULL, meaning no packet ring was allocated, then neither
was rx_owner_map. And the field may be old state from a tpacket_v3.

Fixes: 61fad6816fc1 ("net/packet: tpacket_rcv: avoid a producer race condition")
Reported-by: Syzbot <syzbot+1ac0994a0a0c55151121@syzkaller.appspotmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20211215143937.106178-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 0ffbf3d17911a..6062bd5bf132b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4453,9 +4453,10 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	}
 
 out_free_pg_vec:
-	bitmap_free(rx_owner_map);
-	if (pg_vec)
+	if (pg_vec) {
+		bitmap_free(rx_owner_map);
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
+	}
 out:
 	return err;
 }
-- 
2.33.0



