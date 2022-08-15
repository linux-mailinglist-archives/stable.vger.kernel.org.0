Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6421D594CDC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244912AbiHPAgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350614AbiHPAgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2989718A09B;
        Mon, 15 Aug 2022 13:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AE71B80EA8;
        Mon, 15 Aug 2022 20:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66116C433D6;
        Mon, 15 Aug 2022 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595864;
        bh=YSo1sfXbLmU7/IvZ22ZT7QbZpq+Sscru+IpxsROtCVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngHfxaXSKtmmt1CYpw8lNgw4RM21vJmhntO9go+L2Jr2POQHyRaDQ8CHd/i48jnvR
         CZCgNRU8YFYhmRj0w2iEW7vjApFDn9nRLYR3v/x+rhh186l6T/2YWL9VQF5skTySYT
         awZDgH1od+sx5bM/rwFRkByoyb2dBcXalIh4m2dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mina Almasry <almasrymina@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0867/1157] selftest/vm: uninitialized variable in main()
Date:   Mon, 15 Aug 2022 20:03:43 +0200
Message-Id: <20220815180514.155562107@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 360b420dbded8ad5b70a41de98e77354dd9e7d36 ]

Initialize "length" to zero by default.

Link: https://lkml.kernel.org/r/YtZzjvHXVXMXxpXO@kili
Fixes: ff712a627f72 ("selftests/vm: cleanup hugetlb file after mremap test")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/hugepage-mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/hugepage-mremap.c b/tools/testing/selftests/vm/hugepage-mremap.c
index 585978f181ed..e63a0214f639 100644
--- a/tools/testing/selftests/vm/hugepage-mremap.c
+++ b/tools/testing/selftests/vm/hugepage-mremap.c
@@ -107,7 +107,7 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
-	size_t length;
+	size_t length = 0;
 
 	if (argc != 2 && argc != 3) {
 		printf("Usage: %s [length_in_MB] <hugetlb_file>\n", argv[0]);
-- 
2.35.1



