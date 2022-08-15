Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93D5594379
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348004AbiHOWUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350832AbiHOWSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF8141D1B;
        Mon, 15 Aug 2022 12:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3E72B80EA7;
        Mon, 15 Aug 2022 19:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397F4C433C1;
        Mon, 15 Aug 2022 19:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592561;
        bh=dN16VvJHR/zUhnh0L+qtYA5bmwA3MJYkt+qkY5TKb3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x16JCQbGd4kzJ5pLX1dDkUBc+MlwhlEHDjkX8ahkgVeEohinCXx0E//GdRxeLIJ1j
         c0b9j4PJAo7pYYUnVsuGyhBCHWnJcOqZdX5qS3FuntRAvp5ktq+pxm38QQ551I/hM9
         RZGY8t0UNtLsL4HUG5j4NOv33lh59uXCWjf8U07Q=
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
Subject: [PATCH 5.18 0808/1095] selftest/vm: uninitialized variable in main()
Date:   Mon, 15 Aug 2022 20:03:27 +0200
Message-Id: <20220815180502.695764789@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 1d689084a54b..22546f279534 100644
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



