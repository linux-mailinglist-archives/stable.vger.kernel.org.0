Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBC36087BD
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiJVIFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiJVIEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB402D37FC;
        Sat, 22 Oct 2022 00:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C6460B80;
        Sat, 22 Oct 2022 07:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF531C433D7;
        Sat, 22 Oct 2022 07:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425108;
        bh=3i1Ed3bk0XkELjKa8ysuyW1Wad/0dMDZaLkwWHH547Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9JVKIKov24Hr0ly3q1g9QhO1x4GsGtaCq07Adl/Bc6BNIITo8+0xkGqoK0nHLUNV
         kG7OLzauQzoDE/JrPpwYfcKG3N6tmgFAC8YwxzxLSjPsolbxfkDVQeF+yiv6pfyS+w
         6Ttv22+D8LDNULEf1KjLV8ThsPG7QjIE2hVrAv4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ben Widawsky <bwidawsk@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-ia64@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Keith Mannthey <kmannth@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 362/717] ia64: export memory_add_physaddr_to_nid to fix cxl build error
Date:   Sat, 22 Oct 2022 09:24:01 +0200
Message-Id: <20221022072512.283950772@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 97c318bfbe84efded246e80428054f300042f110 ]

cxl_pmem.ko uses memory_add_physaddr_to_nid() but ia64 does not export it,
so this causes a build error:

ERROR: modpost: "memory_add_physaddr_to_nid" [drivers/cxl/cxl_pmem.ko] undefined!

Fix this by exporting that function.

Fixes: 8c2676a5870a ("hot-add-mem x86_64: memory_add_physaddr_to_nid node fixup")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <bwidawsk@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-ia64@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Keith Mannthey <kmannth@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/mm/numa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/mm/numa.c b/arch/ia64/mm/numa.c
index d6579ec3ea32..4c7b1f50e3b7 100644
--- a/arch/ia64/mm/numa.c
+++ b/arch/ia64/mm/numa.c
@@ -75,5 +75,6 @@ int memory_add_physaddr_to_nid(u64 addr)
 		return 0;
 	return nid;
 }
+EXPORT_SYMBOL(memory_add_physaddr_to_nid);
 #endif
 #endif
-- 
2.35.1



