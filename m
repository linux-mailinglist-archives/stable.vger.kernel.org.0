Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A0D3642E9
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhDSNMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhDSNLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E05C261246;
        Mon, 19 Apr 2021 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837849;
        bh=qWNd7Sy3XiCXmtTcRBCpnKokIX9emHoWsK6lp2dXgus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHXRTARf9O20sny4dWP5/sbI3V14NbLEXtIKWxQ8G5o03upEjMgyYHfRZijw7m++8
         Kv/ibmMRNvZGnzNd5QANHCYI4qLC8wnrvRByMiaEK96xqp2KGqp3+6U3Ealujocigg
         e9FSkHyZsHqQPzEe86iuJ/CjaggdSmQ6S22LXaJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.11 077/122] libbpf: Fix potential NULL pointer dereference
Date:   Mon, 19 Apr 2021 15:05:57 +0200
Message-Id: <20210419130532.786389947@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

commit afd0be7299533bb2e2b09104399d8a467ecbd2c5 upstream.

Wait until after the UMEM is checked for null to dereference it.

Fixes: 43f1bc1efff1 ("libbpf: Restore umem state after socket create failure")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210408052009.7844-1-ciara.loftus@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/xsk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -777,18 +777,19 @@ int xsk_socket__create_shared(struct xsk
 			      struct xsk_ring_cons *comp,
 			      const struct xsk_socket_config *usr_config)
 {
+	bool unmap, rx_setup_done = false, tx_setup_done = false;
 	void *rx_map = NULL, *tx_map = NULL;
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
 	struct xsk_ctx *ctx;
 	int err, ifindex;
-	bool unmap = umem->fill_save != fill;
-	bool rx_setup_done = false, tx_setup_done = false;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
 
+	unmap = umem->fill_save != fill;
+
 	xsk = calloc(1, sizeof(*xsk));
 	if (!xsk)
 		return -ENOMEM;


