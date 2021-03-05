Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D3F32E824
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhCEMZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhCEMY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE53F6501D;
        Fri,  5 Mar 2021 12:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947096;
        bh=DCpmbMq0oCz3p0R50qpLSTkZ3nupwcqWA1pNuq4A050=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCjLvswLZsCt3rSUAu7WazUMXkneG44iES9O0Ucc8fbMu7nFt6voOCFrGW86HxG2f
         O/YAxH+JDdoHAZgo2mOrGgXIjdNt3ma1it4ArQ/9tzeNJ/G/H2Z5rmqGHXzslevm7L
         libp1qbYZpZ4i0Ke/ZllxETq/5Ijx6Rw9EcTM1N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 046/104] selftests/bpf: Remove memory leak
Date:   Fri,  5 Mar 2021 13:20:51 +0100
Message-Id: <20210305120905.424491211@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 4896d7e37ea5217d42e210bfcf4d56964044704f ]

The allocated entry is immediately overwritten by an assignment. Fix
that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210122154725.22140-5-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1e722ee76b1f..e7945b6246c8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -729,7 +729,6 @@ static void worker_pkt_validate(void)
 	u32 payloadseqnum = -2;
 
 	while (1) {
-		pkt_node_rx_q = malloc(sizeof(struct pkt));
 		pkt_node_rx_q = TAILQ_LAST(&head, head_s);
 		if (!pkt_node_rx_q)
 			break;
-- 
2.30.1



