Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADB66AE9AB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjCGR05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCGR0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8649E651
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E67614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7656C4339B;
        Tue,  7 Mar 2023 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209670;
        bh=GiCPWMe4xXupYTgTSSO/0RLhn1eGPKQB16OF+yg0fkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPWLsiApa5sbQlb3GdB6NkGK8kc0xgMQjBuBrJIEOaqlzwngQkiXWgdm9VuuGPD4F
         sNJzaR+zCnJaTSFlushaVEcXD3DmB84TX4bwvpQVRvJt4ltNN7DqSOsEeI1+Uf00xH
         9FBP/8eErZxNl1vXz7/HeV5NRAUztMo0L5thtkLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0262/1001] s390/mem_detect: rely on diag260() if sclp_early_get_memsize() fails
Date:   Tue,  7 Mar 2023 17:50:34 +0100
Message-Id: <20230307170033.095051226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit eb33f9eb304a4c18beb5ba6362eaa5c4beaf40d8 ]

In case sclp_early_get_memsize() fails but diag260() succeeds make sure
some sane value is returned. This error scenario is highly unlikely,
but this change makes system able to boot in such case.

Suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 22476f47b6b7 ("s390/boot: fix mem_detect extended area allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/mem_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 0a5821ef4f1fd..41792a3a5e364 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -176,7 +176,7 @@ unsigned long detect_memory(void)
 
 	if (!diag260()) {
 		mem_detect.info_source = MEM_DETECT_DIAG260;
-		return max_physmem_end;
+		return max_physmem_end ?: get_mem_detect_end();
 	}
 
 	if (max_physmem_end) {
-- 
2.39.2



