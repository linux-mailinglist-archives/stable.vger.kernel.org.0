Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1A3AEE6B
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhFUQ2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231874AbhFUQ1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19472613DA;
        Mon, 21 Jun 2021 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292571;
        bh=wU82TVApRkhtI7f0iv/+54MYKfS6dYu+wuaftVjHOJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vq8VV/gztFCylWGW6p2TAHnR6pXfUDjP3rNk0pHoHYq4kArR7gRmvC8otjsKJ09oV
         CMHdtit/A0JJcyCpxNZyqQ4FscXnK8zGTlKHUtBTJqgUu5aw+UbDq5uDn9nWFOK/uK
         IBvUu32nBqbuwrwCdSy+SkwnmGAa9uyyfbAErD2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kev Jackson <foamdino@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/146] libbpf: Fixes incorrect rx_ring_setup_done
Date:   Mon, 21 Jun 2021 18:14:06 +0200
Message-Id: <20210621154911.820327580@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kev Jackson <foamdino@gmail.com>

[ Upstream commit 11fc79fc9f2e395aa39fa5baccae62767c5d8280 ]

When calling xsk_socket__create_shared(), the logic at line 1097 marks a
boolean flag true within the xsk_umem structure to track setup progress
in order to support multiple calls to the function.  However, instead of
marking umem->tx_ring_setup_done, the code incorrectly sets
umem->rx_ring_setup_done.  This leads to improper behaviour when
creating and destroying xsk and umem structures.

Multiple calls to this function is documented as supported.

Fixes: ca7a83e2487a ("libbpf: Only create rx and tx XDP rings when necessary")
Signed-off-by: Kev Jackson <foamdino@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/YL4aU4f3Aaik7CN0@linux-dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 7150e34cf2af..3028f932e10c 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -779,7 +779,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			goto out_put_ctx;
 		}
 		if (xsk->fd == umem->fd)
-			umem->rx_ring_setup_done = true;
+			umem->tx_ring_setup_done = true;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
-- 
2.30.2



