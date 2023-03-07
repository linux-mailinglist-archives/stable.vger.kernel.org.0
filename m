Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF32E6AF380
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjCGTFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbjCGTF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:05:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689CB0BBD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FB4CB819D2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF80C4339C;
        Tue,  7 Mar 2023 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215036;
        bh=MSHJ2ofSUkFY7rUsCgjKuHzWOjgataKmbZaX+Vb3/eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZqsZ5CXKcuZUVtuzOQDlIeAaByWT6CFxwhVkaNYSwB6dfTbojjn66opsmP8e+ACd
         5d7CLaUbypXygv+6Cbmp/spRYNbsOmLOcD4VkMBhgnHdpyt/AM2bYNdBchSrVRegz3
         AnYPWSVD6krC3vb5m9oQTTbgZj0tjMt21uLgC2rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/567] s390/mem_detect: fix detect_memory() error handling
Date:   Tue,  7 Mar 2023 17:57:47 +0100
Message-Id: <20230307165911.564969643@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 3400c35a4090704e6c465449616ab7e67a9209e7 ]

Currently if for some reason sclp_early_read_info() fails,
sclp_early_get_memsize() will not set max_physmem_end and it
will stay uninitialized. Any garbage value other than 0 will lead
to detect_memory() taking wrong path or returning a garbage value
as max_physmem_end. To avoid that simply initialize max_physmem_end.

Fixes: 73045a08cf55 ("s390: unify identity mapping limits handling")
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/mem_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 2f949cd9076b8..17a32707d17e0 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -165,7 +165,7 @@ static void search_mem_end(void)
 
 unsigned long detect_memory(void)
 {
-	unsigned long max_physmem_end;
+	unsigned long max_physmem_end = 0;
 
 	sclp_early_get_memsize(&max_physmem_end);
 
-- 
2.39.2



