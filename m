Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD45D1B40A5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgDVKQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbgDVKPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EADE52076B;
        Wed, 22 Apr 2020 10:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550551;
        bh=H6Jz1gPFvJZTTN9HpqV/4O7COMP3h5MT2YQATGXcV4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POoC5iMUPL5IQAHCJfjZ1joRP1ILHp7Vj27wHwZBKPsDIPWJGb3TjPmCBd3Fyojeu
         4IXVXlZP2GO9GIVZ8/A4BmG9Mrif2WYthSyAT1zNM6uP32JXQWHNTAf1PyQ6/DdTBg
         PfsXYGDS8QuEGfzsIUhevKgQIW8+M/IqmiojkFM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/64] xsk: Add missing check on user supplied headroom size
Date:   Wed, 22 Apr 2020 11:57:04 +0200
Message-Id: <20200422095016.685614794@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 99e3a236dd43d06c65af0a2ef9cb44306aef6e02 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 556a649512b60..706fad12f22cf 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -260,7 +260,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	unsigned int chunks, chunks_per_page;
 	u64 addr = mr->addr, size = mr->len;
-	int size_chk, err, i;
+	int err, i;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
 		/* Strictly speaking we could support this, if:
@@ -295,8 +295,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 
 	headroom = ALIGN(headroom, 64);
 
-	size_chk = chunk_size - headroom - XDP_PACKET_HEADROOM;
-	if (size_chk < 0)
+	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
 
 	umem->address = (unsigned long)addr;
-- 
2.20.1



