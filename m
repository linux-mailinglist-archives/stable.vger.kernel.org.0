Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A94E2ABC54
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbgKINg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbgKINEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:04:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67FDF221F9;
        Mon,  9 Nov 2020 13:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927082;
        bh=NSGbzGVScaKQrT4fRL0SVDPkXhHp/jQGXACAcHuiIAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOYuH1yuNeakbPtQykwh5Kv8CJTAnYZ+0COqgFyqpYe/8wCwXU5KUEGnpDeGKzGXW
         gHi7C3EOfsjVrxp1vdEQ+mEElMc9OectCaHmVCXKIl1/sRftNYAGjUciSZSeWCHsSn
         R5EtGYXdx6L2wHvA/dv8D9LCI9o03nsLh0PD6QEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 104/117] of: Fix reserved-memory overlap detection
Date:   Mon,  9 Nov 2020 13:55:30 +0100
Message-Id: <20201109125030.634579716@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit ca05f33316559a04867295dd49f85aeedbfd6bfd ]

The reserved-memory overlap detection code fails to detect overlaps if
either of the regions starts at address 0x0.  The code explicitly checks
for and ignores such regions, apparently in order to ignore dynamically
allocated regions which have an address of 0x0 at this point.  These
dynamically allocated regions also have a size of 0x0 at this point, so
fix this by removing the check and sorting the dynamically allocated
regions ahead of any static regions at address 0x0.

For example, there are two overlaps in this case but they are not
currently reported:

	foo@0 {
	        reg = <0x0 0x2000>;
	};

	bar@0 {
	        reg = <0x0 0x1000>;
	};

	baz@1000 {
	        reg = <0x1000 0x1000>;
	};

	quux {
	        size = <0x1000>;
	};

but they are after this patch:

 OF: reserved mem: OVERLAP DETECTED!
 bar@0 (0x00000000--0x00001000) overlaps with foo@0 (0x00000000--0x00002000)
 OF: reserved mem: OVERLAP DETECTED!
 foo@0 (0x00000000--0x00002000) overlaps with baz@1000 (0x00001000--0x00002000)

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/ded6fd6b47b58741aabdcc6967f73eca6a3f311e.1603273666.git-series.vincent.whitchurch@axis.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 366d8c3c79893..f15bb936dfd84 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -222,6 +222,16 @@ static int __init __rmem_cmp(const void *a, const void *b)
 	if (ra->base > rb->base)
 		return 1;
 
+	/*
+	 * Put the dynamic allocations (address == 0, size == 0) before static
+	 * allocations at address 0x0 so that overlap detection works
+	 * correctly.
+	 */
+	if (ra->size < rb->size)
+		return -1;
+	if (ra->size > rb->size)
+		return 1;
+
 	return 0;
 }
 
@@ -239,8 +249,7 @@ static void __init __rmem_check_for_overlap(void)
 
 		this = &reserved_mem[i];
 		next = &reserved_mem[i + 1];
-		if (!(this->base && next->base))
-			continue;
+
 		if (this->base + this->size > next->base) {
 			phys_addr_t this_end, next_end;
 
-- 
2.27.0



