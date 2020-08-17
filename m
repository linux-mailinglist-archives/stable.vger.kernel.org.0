Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E24246AA8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgHQPkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730674AbgHQPkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02552207FF;
        Mon, 17 Aug 2020 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678837;
        bh=kLRldtUwC7t3HFPXhNORNdUQOkvhyX8mWGlBQq4PcV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCtDGdM99oT2GD53EQUG75o7x8bHXdgt5QA+QtIEznXnIavMY+aMbWvw2XxbOSoy9
         2minu+mEDqYp3s9PqtuEwlY6ZOJDcpMr1+fnIjs1D5mhdU4oubs1hpaj3FaRNUtFbE
         3fzCi5GIzR8JCengttVQQm7r0kdrjH0L0cyv0IOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.8 458/464] s390/numa: set node distance to LOCAL_DISTANCE
Date:   Mon, 17 Aug 2020 17:16:51 +0200
Message-Id: <20200817143855.712919334@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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


