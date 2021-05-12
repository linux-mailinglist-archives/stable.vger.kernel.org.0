Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6437C299
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhELPMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhELPJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953C261622;
        Wed, 12 May 2021 15:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831760;
        bh=wCiYaKp75zFHqpiAV0IPXiIyF/xDlx9nKBzIXxqJ2Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e87cl2HbinMcKKIVCUlNo2Zvoxo0Piq1ebG/cwsZDuZ131AMUDVEtMLxIYAc/sMzJ
         l7yw3VilCFYRTLtdxFhEErw6+CjbXCUW7ngJaMGYH5/NFo0I/9ykHhSCAESJsXwBlZ
         MZr/U6Bntg8RPhBqlUa4QD4Gf1ASRb7PzjTiXajc=
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
Subject: [PATCH 5.4 237/244] mm/sparse: add the missing sparse_buffer_fini() in error branch
Date:   Wed, 12 May 2021 16:50:08 +0200
Message-Id: <20210512144750.585890495@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 78bbecd904c3..191e29cca3fb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -551,6 +551,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
 			pnum_begin = pnum;
+			sparse_buffer_fini();
 			goto failed;
 		}
 		check_usemap_section_nr(nid, usage);
-- 
2.30.2



