Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9A4F2607
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiDEHxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbiDEHxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767DFC36;
        Tue,  5 Apr 2022 00:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76C07B81B18;
        Tue,  5 Apr 2022 07:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9585C340EE;
        Tue,  5 Apr 2022 07:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144932;
        bh=eHC9hM/jmV7ih56Vke9QDbcNIvYXsGeLVS2lbiILUgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zG7S4YKBUxgc6sp0XIx7MwIcNtVtbiZg5XTMJIrOn4Z7GljaqR1Xfv+jKXmLS4hir
         Or7DLWgC7NBa9/s+LT6vOJp4icSvBOc1OSH1mQY8uTj6DICCKDkkK5U0n7mVHR8W+1
         kNpn2V3WeT5QggQBT/gsY0FYV/F3rT25lcYKHfh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0216/1126] selftests/sgx: Fix NULL-pointer-dereference upon early test failure
Date:   Tue,  5 Apr 2022 09:16:03 +0200
Message-Id: <20220405070413.949749123@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 2d03861e0d1d1ee81efc59338101cdd86a7474f6 ]

== Background ==

The SGX selftests track parts of the enclave binaries in an array:
encl->segment_tbl[]. That array is dynamically allocated early
(but not first) in the test's lifetime. The array is referenced
at the end of the test in encl_delete().

== Problem ==

encl->segment_tbl[] can be NULL if the test fails before its
allocation. That leads to a NULL-pointer-dereference in encl_delete().
This is triggered during early failures of the selftest like if the
enclave binary ("test_encl.elf") is deleted.

== Solution ==

Ensure encl->segment_tbl[] is valid before attempting to access
its members. The offset with which it is accessed, encl->nr_segments,
is initialized before encl->segment_tbl[] and thus considered valid
to use after the encl->segment_tbl[] check succeeds.

Fixes: 3200505d4de6 ("selftests/sgx: Create a heap for the test enclave")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lkml.kernel.org/r/90a31dfd640ea756fa324712e7cbab4a90fa7518.1644355600.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/load.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 9d4322c946e2..006b464c8fc9 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -21,7 +21,7 @@
 
 void encl_delete(struct encl *encl)
 {
-	struct encl_segment *heap_seg = &encl->segment_tbl[encl->nr_segments - 1];
+	struct encl_segment *heap_seg;
 
 	if (encl->encl_base)
 		munmap((void *)encl->encl_base, encl->encl_size);
@@ -32,10 +32,11 @@ void encl_delete(struct encl *encl)
 	if (encl->fd)
 		close(encl->fd);
 
-	munmap(heap_seg->src, heap_seg->size);
-
-	if (encl->segment_tbl)
+	if (encl->segment_tbl) {
+		heap_seg = &encl->segment_tbl[encl->nr_segments - 1];
+		munmap(heap_seg->src, heap_seg->size);
 		free(encl->segment_tbl);
+	}
 
 	memset(encl, 0, sizeof(*encl));
 }
-- 
2.34.1



