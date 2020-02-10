Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB4157795
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgBJNBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729834AbgBJMkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:55 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 537662085B;
        Mon, 10 Feb 2020 12:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338454;
        bh=Rb4+5OZy8/cgfkqgiWf+evdbzazPvvSkiaJPEhlwwHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6I/jkilf028Qmnt/79qqONuy8ad8Ls0554q8MCB2lQ1OPJZHoOx8slNkrWn1slqC
         0q1RrJgdnqlf2vOt0vP2P5vglayP18OrjzKTjCAGMVUX7IpskcXy97yUMkzlScwVGK
         TvgFy0ptgNkQzjfNQXzacFYA4k1Clpn+Ya4OK2rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amol Grover <frextrite@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH 5.5 163/367] bpf, devmap: Pass lockdep expression to RCU lists
Date:   Mon, 10 Feb 2020 04:31:16 -0800
Message-Id: <20200210122439.878252174@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>

commit 485ec2ea9cf556e9c120e07961b7b459d776a115 upstream.

head is traversed using hlist_for_each_entry_rcu outside an RCU
read-side critical section but under the protection of dtab->index_lock.

Hence, add corresponding lockdep expression to silence false-positive
lockdep warnings, and harden RCU lists.

Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
Signed-off-by: Amol Grover <frextrite@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20200123120437.26506-1-frextrite@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/devmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -293,7 +293,8 @@ struct bpf_dtab_netdev *__dev_map_hash_l
 	struct hlist_head *head = dev_map_index_hash(dtab, key);
 	struct bpf_dtab_netdev *dev;
 
-	hlist_for_each_entry_rcu(dev, head, index_hlist)
+	hlist_for_each_entry_rcu(dev, head, index_hlist,
+				 lockdep_is_held(&dtab->index_lock))
 		if (dev->idx == key)
 			return dev;
 


