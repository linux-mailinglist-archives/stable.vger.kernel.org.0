Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2912A52ED
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbgKCUyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731955AbgKCUys (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:54:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 626B72053B;
        Tue,  3 Nov 2020 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436887;
        bh=FsuqPvptEOh9bnEUCkAE4VHhg7XcmMiOvu/IENmUCe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BKFjAtnsyK0PDwezJO9uIHfJj9hRD1PDdWuBDSd3srboRLNbZOF1ZhTNTfpU6n6W
         niKhNogynArYPNXKPCkYoKjL2xld+/3T/7LryNwZ5dyq7Rr2W5t0YeuGkggb929mj5
         PxnzYKrolF9vvE2gnkDT36ng1WKaVQDar9yPQUPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/214] samples/bpf: Fix possible deadlock in xdpsock
Date:   Tue,  3 Nov 2020 21:35:02 +0100
Message-Id: <20201103203255.318895565@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 5a2a0dd88f0f267ac5953acd81050ae43a82201f ]

Fix a possible deadlock in the l2fwd application in xdpsock that can
occur when there is no space in the Tx ring. There are two ways to get
the kernel to consume entries in the Tx ring: calling sendto() to make
it send packets and freeing entries from the completion ring, as the
kernel will not send a packet if there is no space for it to add a
completion entry in the completion ring. The Tx loop in l2fwd only
used to call sendto(). This patches adds cleaning the completion ring
in that loop.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/1599726666-8431-3-git-send-email-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdpsock_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index df011ac334022..79d1005ff2ee3 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -677,6 +677,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
+		complete_tx_l2fwd(xsk, fds);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 			kick_tx(xsk);
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-- 
2.27.0



