Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA331B409C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgDVKQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbgDVKQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D862076B;
        Wed, 22 Apr 2020 10:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550591;
        bh=dgsp2o5jhO3cVaLbl6yI7GcuL8xJF4PWHyAwkSBbIFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXbtkGXZBB1JVl7mlnU4ewxKblAmsa41iUXOTrUnbgvXxDzIsCO3njfgk+LUZNVA9
         QfK2eutDTY5XNCi4CWzK5imk0zCeNdpddsskHyri+kl2EXTzhUxnVt8Ooc59YvJlfN
         nQJ9DZ98M/QMT68U0QyhV+nBspVQhqtHZjS+HeD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 014/118] xsk: Add missing check on user supplied headroom size
Date:   Wed, 22 Apr 2020 11:56:15 +0200
Message-Id: <20200422095033.911940986@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 99e3a236dd43d06c65af0a2ef9cb44306aef6e02 upstream.

Add a check that the headroom cannot be larger than the available
space in the chunk. In the current code, a malicious user can set the
headroom to a value larger than the chunk size minus the fixed XDP
headroom. That way packets with a length larger than the supported
size in the umem could get accepted and result in an out-of-bounds
write.

Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Reported-by: Bui Quang Minh <minhquangbui99@gmail.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=207225
Link: https://lore.kernel.org/bpf/1586849715-23490-1-git-send-email-magnus.karlsson@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xdp/xdp_umem.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -343,7 +343,7 @@ static int xdp_umem_reg(struct xdp_umem
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	unsigned int chunks, chunks_per_page;
 	u64 addr = mr->addr, size = mr->len;
-	int size_chk, err;
+	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
 		/* Strictly speaking we could support this, if:
@@ -382,8 +382,7 @@ static int xdp_umem_reg(struct xdp_umem
 			return -EINVAL;
 	}
 
-	size_chk = chunk_size - headroom - XDP_PACKET_HEADROOM;
-	if (size_chk < 0)
+	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
 
 	umem->address = (unsigned long)addr;


