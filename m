Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBA255D64F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiF0Lib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiF0Lhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61700B04;
        Mon, 27 Jun 2022 04:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24467B81122;
        Mon, 27 Jun 2022 11:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF4C341C8;
        Mon, 27 Jun 2022 11:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329633;
        bh=E49iyCRj4QbP3/EbZLXLwZp+fDTLfjOcMQvlo3rHagI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZ01N1CSEp5yk1qcQRSJBr7UN8P59XU4xn9Tu7nTuKepOTCh3vonnUPBSFIzUCg8w
         gij9RA2ccPKOmHiNp6pcyPhcB1RQYqNNs5/f8ZbdFyO8zV+00lD8xaHuQdu8aZ0y1j
         VnubhRWojSSV7FKD3AOWjoNRCq/VtJHVKZpMugeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zdi-disclosures@trendmicro.com,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/135] udmabuf: add back sanity check
Date:   Mon, 27 Jun 2022 13:21:10 +0200
Message-Id: <20220627111939.986095750@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit 05b252cccb2e5c3f56119d25de684b4f810ba40a ]

Check vm_fault->pgoff before using it.  When we removed the warning, we
also removed the check.

Fixes: 7b26e4e2119d ("udmabuf: drop WARN_ON() check.")
Reported-by: zdi-disclosures@trendmicro.com
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index e7330684d3b8..9631f2fd2faf 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -32,8 +32,11 @@ static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct udmabuf *ubuf = vma->vm_private_data;
+	pgoff_t pgoff = vmf->pgoff;
 
-	vmf->page = ubuf->pages[vmf->pgoff];
+	if (pgoff >= ubuf->pagecount)
+		return VM_FAULT_SIGBUS;
+	vmf->page = ubuf->pages[pgoff];
 	get_page(vmf->page);
 	return 0;
 }
-- 
2.35.1



