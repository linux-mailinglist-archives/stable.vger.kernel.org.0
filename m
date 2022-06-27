Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E042155E0DD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiF0Lbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiF0LbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E76DDF;
        Mon, 27 Jun 2022 04:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 858F8B81120;
        Mon, 27 Jun 2022 11:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC595C3411D;
        Mon, 27 Jun 2022 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329334;
        bh=Ijmwv+syevkvdt93fWVqN1GeiV0joTO4w7doeUlDHqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIV2JxwihspDQNFvVGR89JhLpEd2tW8Z74Bo+uQRudYJ9QZH5l94/qU+1RX+xeagr
         T06b3FuHSanXkExAzQcnatQJRPyPe/k/M13UBvcMSYFy7NBpow0BpnFGwUqS8yGwJ+
         JubN0gBKqSogqAAt/vDxjuSfD8mfXJZL97s1YHS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zdi-disclosures@trendmicro.com,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/60] udmabuf: add back sanity check
Date:   Mon, 27 Jun 2022 13:21:35 +0200
Message-Id: <20220627111928.376754235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
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
index e553c6a937f6..c6e9b7bd7618 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -24,8 +24,11 @@ static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
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



