Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736C9246BA3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730978AbgHQP7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730964AbgHQP7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:59:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A821206FA;
        Mon, 17 Aug 2020 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679961;
        bh=kLRldtUwC7t3HFPXhNORNdUQOkvhyX8mWGlBQq4PcV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qBjtwDaxOUQjqvvenH6FRGmF79VuxICOn3HLyGZnrps5mh2uBfIFZwDA+Wo48G4y
         KSJeb3IExNtG7oqzsjipfFopKxYmbA//XOAENqOVzTCvAW1KvgcfWXstc3G9WGjnph
         1HsW3T78JyE+stzrqaFw+B42x78m4mYF25Qe2u9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.7 386/393] s390/numa: set node distance to LOCAL_DISTANCE
Date:   Mon, 17 Aug 2020 17:17:16 +0200
Message-Id: <20200817143838.323520254@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit 535e4fc623fab2e09a0653fc3a3e17f382ad0251 upstream.

The node distance is hardcoded to 0, which causes a trouble
for some user-level applications. In particular, "libnuma"
expects the distance of a node to itself as LOCAL_DISTANCE.
This update removes the offending node distance override.

Cc: <stable@vger.kernel.org> # 4.4
Fixes: 3a368f742da1 ("s390/numa: add core infrastructure")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/topology.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -86,12 +86,6 @@ static inline const struct cpumask *cpum
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
-#define node_distance(a, b) __node_distance(a, b)
-static inline int __node_distance(int a, int b)
-{
-	return 0;
-}
-
 #else /* !CONFIG_NUMA */
 
 #define numa_node_id numa_node_id


