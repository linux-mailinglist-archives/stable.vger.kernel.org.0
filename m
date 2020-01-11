Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98665137E39
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgAKKGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbgAKKGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:06:25 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89F020848;
        Sat, 11 Jan 2020 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737184;
        bh=ho01mEuU6dIoDhvyrj06jtKiuTZ+VxeJY4a9GyouQ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiT47FhxAMSr4lKzTKTSYDo2vtFOTu7OA6EF1uzrtPakubSZo/7r/C/niu7vWVHxz
         4A29CWmOtSaDO1SrBqTGZGyd7fjAgugi1m9xscRdBLbQaaT0WxXmcpVz9akuJFUHuA
         rHdY5yAb1CByTyAhnq3KKoE1befcNs3tOv1Y4/4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 85/91] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
Date:   Sat, 11 Jan 2020 10:50:18 +0100
Message-Id: <20200111094912.821724459@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit c9655008e7845bcfdaac10a1ed8554ec167aea88 ]

When we receive a D-SACK, where the sequence number satisfies:
	undo_marker <= start_seq < end_seq <= prior_snd_una
we consider this is a valid D-SACK and tcp_is_sackblock_valid()
returns true, then this D-SACK is discarded as "old stuff",
but the variable first_sack_index is not marked as negative
in tcp_sacktag_write_queue().

If this D-SACK also carries a SACK that needs to be processed
(for example, the previous SACK segment was lost), this SACK
will be treated as a D-SACK in the following processing of
tcp_sacktag_write_queue(), which will eventually lead to
incorrect updates of undo_retrans and reordering.

Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & simplify access to them")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1741,8 +1741,11 @@ tcp_sacktag_write_queue(struct sock *sk,
 		}
 
 		/* Ignore very old stuff early */
-		if (!after(sp[used_sacks].end_seq, prior_snd_una))
+		if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
+			if (i == 0)
+				first_sack_index = -1;
 			continue;
+		}
 
 		used_sacks++;
 	}


