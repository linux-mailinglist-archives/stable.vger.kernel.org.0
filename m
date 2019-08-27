Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457B19DF7E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfH0Hyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730164AbfH0Hyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:54:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9754D206BA;
        Tue, 27 Aug 2019 07:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892489;
        bh=hSXiHTaIGZAtakKjmWxzWPqo1JJ9IeJSuT3tMk0Qho4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hy4mk58PicfsKxdibXUIqz6+xqrjAFI/qz0jUdXlwhu3mnrJKqR7AMU6zWApv3Os
         Op3l6dU3BVBJMHbv1amw/faMlKc0gPbwRSzjpC5QNTp6bDOPAYb05Wo0bLBNlBZTpp
         z2qdU80MATW2Jak5riL37AxfQArJtpMxWar1VGcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Kondratiev <vladimir.kondratiev@linux.intel.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/98] mips: fix cacheinfo
Date:   Tue, 27 Aug 2019 09:49:42 +0200
Message-Id: <20190827072718.323552414@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b8bea8a5e5d942e62203416ab41edecaed4fda02 ]

Because CONFIG_OF defined for MIPS, cacheinfo attempts to fill information
from DT, ignoring data filled by architecture routine. This leads to error
reported

 cacheinfo: Unable to detect cache hierarchy for CPU 0

Way to fix this provided in
commit fac51482577d ("drivers: base: cacheinfo: fix x86 with
 CONFIG_OF enabled")

Utilize same mechanism to report that cacheinfo set by architecture
specific function

Signed-off-by: Vladimir Kondratiev <vladimir.kondratiev@linux.intel.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cacheinfo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/kernel/cacheinfo.c b/arch/mips/kernel/cacheinfo.c
index 97d5239ca47ba..428ef21892039 100644
--- a/arch/mips/kernel/cacheinfo.c
+++ b/arch/mips/kernel/cacheinfo.c
@@ -80,6 +80,8 @@ static int __populate_cache_leaves(unsigned int cpu)
 	if (c->tcache.waysize)
 		populate_cache(tcache, this_leaf, 3, CACHE_TYPE_UNIFIED);
 
+	this_cpu_ci->cpu_map_populated = true;
+
 	return 0;
 }
 
-- 
2.20.1



