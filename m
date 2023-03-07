Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC996AE9A7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCGR0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjCGR0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8409CFFE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6981B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A77C4339C;
        Tue,  7 Mar 2023 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209660;
        bh=SRxSxwdC2UK5K5lirdJ2KMLSUYI6E2JgaV5+Ezi6DKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egRdMMg2ul9XPwUUP7xPK0iwo9/8GNe2WhZ+Q5Ii0AG83f5Le0voJsLWOLvN/RlTt
         h71VErWHj7qn5DPmfSmWnw9B8pYSsFlAQt4loGuEs053Ytzji42MH2FC6nHunaJ/uB
         zl+Ri7w33z5WVJ8fJCH/dDnhwHGYiuIjjSUQdwQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0259/1001] s390/mem_detect: fix detect_memory() error handling
Date:   Tue,  7 Mar 2023 17:50:31 +0100
Message-Id: <20230307170032.972900826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 7fa1a32ea0f3f..0a5821ef4f1fd 100644
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



