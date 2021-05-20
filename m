Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA5338A4A2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhETKH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235587AbhETKFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07DDB613DC;
        Thu, 20 May 2021 09:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503672;
        bh=datGG+ULmL2SRs8W4f2zAfv1mM24UTw08EVWAF2wmRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJ0wPcx8knqmU8EbU8aBb739Qyy460BFNKBi4DPoGJWCUtwWEYr4dlP6hL7UMQjGx
         je1FsLc4sKnq7UWJlMkqNS/JV93OXn4rI9SleY+GwcdBzETAcvU6m5/gAHW+eo8/wX
         x+7cBUTSWAQkajaEmb4EqC0iiS6lpr4Gal3Bvf5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Wensheng <wangwensheng4@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 293/425] mm/sparse: add the missing sparse_buffer_fini() in error branch
Date:   Thu, 20 May 2021 11:21:02 +0200
Message-Id: <20210520092141.081872654@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 2284f47fe9fe2ed2ef619e5474e155cfeeebd569 ]

sparse_buffer_init() and sparse_buffer_fini() should appear in pair, or a
WARN issue would be through the next time sparse_buffer_init() runs.

Add the missing sparse_buffer_fini() in error branch.

Link: https://lkml.kernel.org/r/20210325113155.118574-1-wangwensheng4@huawei.com
Fixes: 85c77f791390 ("mm/sparse: add new sparse_init_nid() and sparse_init()")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/sparse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index 3b24ba903d9e..ed60f0a375fe 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -467,6 +467,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
 			pnum_begin = pnum;
+			sparse_buffer_fini();
 			goto failed;
 		}
 		check_usemap_section_nr(nid, usemap);
-- 
2.30.2



