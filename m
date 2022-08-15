Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4058E594CC9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiHPAgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349222AbiHPAfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:35:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D6418A08D;
        Mon, 15 Aug 2022 13:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC04EB8114A;
        Mon, 15 Aug 2022 20:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48456C433D6;
        Mon, 15 Aug 2022 20:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595861;
        bh=gAhaqdi2MNJ7YsEZoDyKRrz/8+l523h+AKKJdZP7w0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3czMBjjK3Ee8eBFbnAqCN5WXu703zp7Upkf9ovZ0BR9XaffjDTbWurR3b7n2hcKU
         3P/0WNeerFCz0fI8sOUHBrGWet5r4wwPuol9ZhYdoUjSYVpjdv4MIfUSQFM7d80LXW
         mlZsWzKVbA3TFmPAOUmJe8vM55ForjVRP9IrWwIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0866/1157] tools/testing/selftests/vm/hugetlb-madvise.c: silence uninitialized variable warning
Date:   Mon, 15 Aug 2022 20:03:42 +0200
Message-Id: <20220815180514.107865945@linuxfoundation.org>
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

[ Upstream commit 3d5367a0426da61c7cb616cc85b6239467e261dd ]

This code just reads from memory without caring about the data itself.
However static checkers complain that "tmp" is never properly initialized.
Initialize it to zero and change the name to "dummy" to show that we
don't care about the value stored in it.

Link: https://lkml.kernel.org/r/YtZ8mKJmktA2GaHB@kili
Fixes: c4b6cb884011 ("selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/hugetlb-madvise.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/hugetlb-madvise.c b/tools/testing/selftests/vm/hugetlb-madvise.c
index 6c6af40f5747..3c9943131881 100644
--- a/tools/testing/selftests/vm/hugetlb-madvise.c
+++ b/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -89,10 +89,11 @@ void write_fault_pages(void *addr, unsigned long nr_pages)
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	unsigned long i, tmp;
+	unsigned long dummy = 0;
+	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++)
-		tmp += *((unsigned long *)(addr + (i * huge_page_size)));
+		dummy += *((unsigned long *)(addr + (i * huge_page_size)));
 }
 
 int main(int argc, char **argv)
-- 
2.35.1



