Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DB52A518A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgKCUlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:41:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbgKCUlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E17FB2224E;
        Tue,  3 Nov 2020 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436112;
        bh=yir11J9qu9bPoOH46GfMgIzLbn7Qj9exDwBC6wBaBmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fJKnIpKUO+7ZavarXmfaO3lPqxCbVrQFjVlRQsaY5fLT5UlIM3TXQg+1FG8ZcbQs
         lSEwRXOL3yFX2MAl1SXiMpY7qcCooez1kk61OrkbyLH0U4vjcQaWoW3OyYoeodPTvn
         VBC2Ji6fvxPH2LeGvvob4e2uhbY3pYZy9vvMoesU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 109/391] samples/bpf: Fix possible deadlock in xdpsock
Date:   Tue,  3 Nov 2020 21:32:40 +0100
Message-Id: <20201103203354.175005339@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
index c821e98671393..63a9a2a39da7b 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1111,6 +1111,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
+		complete_tx_l2fwd(xsk, fds);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 			kick_tx(xsk);
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-- 
2.27.0



