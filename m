Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D9F15C457
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgBMPqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgBMP1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:18 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C1720661;
        Thu, 13 Feb 2020 15:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607636;
        bh=AzMvOGFeP02uYb2htvlWBAJwij+2RSgKQh/WezhmmP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lJ5gmJmRyI0zh+XeYpOAG+hvPTLuI0o987osSdu1EbTspbLxowOI0xDb3BOn5TSY
         AeS3v7H3aoIvdlbTpLc4clpOvmaGgFeCMJlLlGBrdMv3SLA7GYNvSkWyfqwLOJDihx
         KSuIR8v7Te7v7SZ6aEmeP62tQrO0gBtgRoF2qcRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.4 23/96] bpf, sockhash: Synchronize_rcu before freeing map
Date:   Thu, 13 Feb 2020 07:20:30 -0800
Message-Id: <20200213151848.153137952@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 0b2dc83906cf1e694e48003eae5df8fa63f76fd9 upstream.

We need to have a synchronize_rcu before free'ing the sockhash because any
outstanding psock references will have a pointer to the map and when they
use it, this could trigger a use after free.

This is a sister fix for sockhash, following commit 2bb90e5cc90e ("bpf:
sockmap, synchronize_rcu before free'ing map") which addressed sockmap,
which comes from a manual audit.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200206111652.694507-3-jakub@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/sock_map.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -250,6 +250,7 @@ static void sock_map_free(struct bpf_map
 	}
 	raw_spin_unlock_bh(&stab->lock);
 
+	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
 
 	bpf_map_area_free(stab->sks);
@@ -873,6 +874,9 @@ static void sock_hash_free(struct bpf_ma
 		raw_spin_unlock_bh(&bucket->lock);
 	}
 
+	/* wait for psock readers accessing its map link */
+	synchronize_rcu();
+
 	bpf_map_area_free(htab->buckets);
 	kfree(htab);
 }


