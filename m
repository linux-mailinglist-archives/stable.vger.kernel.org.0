Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6E85EA516
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbiIZL5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiIZL4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:56:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1EC79EF1;
        Mon, 26 Sep 2022 03:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA25BB801BF;
        Mon, 26 Sep 2022 10:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07438C433D6;
        Mon, 26 Sep 2022 10:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189436;
        bh=ta6WOsgekpI1LcjSNwrf+fIaiHq0dPDmyVFgINRy+pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLZnjgQFzM4Dhht1dVVt6pCh4ojF/QQ7svuTkqAa/vAoxUfkQsQrM7z0+Z1mXcZRG
         LnlAfh9QiwqVZ6dF1L6uvkmyiArCRa2bBtP3L0pY7hlY8KO//VRG5PGa7Ybwtv+09J
         A9LEFKpvJFKxLoSCDZdLVSfh7f8hmpUeP1LbBn3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 187/207] pmem: fix a name collision
Date:   Mon, 26 Sep 2022 12:12:56 +0200
Message-Id: <20220926100814.986280270@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit 149d17140bcedc906082c4f874dec98b1ffc5a90 ]

Kernel test robot detected name collision when compiled on 'um'
architecture.  Rename "to_phys()"  to "pmem_to_phys()".

>> drivers/nvdimm/pmem.c:48:20: error: conflicting types for 'to_phys'; have 'phys_addr_t(struct pmem_device *, phys_addr_t)' {aka 'long long unsigned int(struct pmem_device *, long long unsigned int)'}
      48 | static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
         |                    ^~~~~~~
   In file included from arch/um/include/asm/page.h:98,
                    from arch/um/include/asm/thread_info.h:15,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/um/include/generated/asm/preempt.h:1,

   arch/um/include/shared/mem.h:12:29: note: previous definition of 'to_phys' with type 'long unsigned int(void *)'
      12 | static inline unsigned long to_phys(void *virt)
         |                             ^~~~~~~

vim +48 drivers/nvdimm/pmem.c
    47
  > 48	static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
    49	{
    50		return pmem->phys_addr + offset;
    51	}
    52

Fixes: 9409c9b6709e (pmem: refactor pmem_clear_poison())
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220630182802.3250449-1-jane.chu@oracle.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/pmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 629d10fcf53b..b9f1a8e9f88c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -45,7 +45,7 @@ static struct nd_region *to_region(struct pmem_device *pmem)
 	return to_nd_region(to_dev(pmem)->parent);
 }
 
-static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
+static phys_addr_t pmem_to_phys(struct pmem_device *pmem, phys_addr_t offset)
 {
 	return pmem->phys_addr + offset;
 }
@@ -63,7 +63,7 @@ static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
 static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
-	phys_addr_t phys = to_phys(pmem, offset);
+	phys_addr_t phys = pmem_to_phys(pmem, offset);
 	unsigned long pfn_start, pfn_end, pfn;
 
 	/* only pmem in the linear map supports HWPoison */
@@ -97,7 +97,7 @@ static void pmem_clear_bb(struct pmem_device *pmem, sector_t sector, long blks)
 static long __pmem_clear_poison(struct pmem_device *pmem,
 		phys_addr_t offset, unsigned int len)
 {
-	phys_addr_t phys = to_phys(pmem, offset);
+	phys_addr_t phys = pmem_to_phys(pmem, offset);
 	long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
 
 	if (cleared > 0) {
-- 
2.35.1



