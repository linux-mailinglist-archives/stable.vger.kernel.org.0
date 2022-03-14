Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA704D812E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiCNLjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbiCNLh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:37:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E498742A27;
        Mon, 14 Mar 2022 04:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B434CE108C;
        Mon, 14 Mar 2022 11:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB2FC340EC;
        Mon, 14 Mar 2022 11:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257795;
        bh=MvYMT4b+70eWMffJm65qmhDlhkcPj5Zm+k3nFgv9U04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amGZywsZvMrnDgplRulfroLaV7WWqOEK+oWiGvRvSZmlDXE+kz1vCDpr0APWoqqDL
         IwuPbNzreoOidLgeDFWxovFzFKLDeMrrh20QnUhKpDUgq++eTT7S6F7r4HtohDeeH6
         N1t3UA+D1XqUzseMOyhthPSSO1kezGuHugqrxSgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/23] selftests/memfd: clean up mapping in mfd_fail_write
Date:   Mon, 14 Mar 2022 12:34:28 +0100
Message-Id: <20220314112731.500185438@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.050583127@linuxfoundation.org>
References: <20220314112731.050583127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit fda153c89af344d21df281009a9d046cf587ea0f ]

Running the memfd script ./run_hugetlbfs_test.sh will often end in error
as follows:

    memfd-hugetlb: CREATE
    memfd-hugetlb: BASIC
    memfd-hugetlb: SEAL-WRITE
    memfd-hugetlb: SEAL-FUTURE-WRITE
    memfd-hugetlb: SEAL-SHRINK
    fallocate(ALLOC) failed: No space left on device
    ./run_hugetlbfs_test.sh: line 60: 166855 Aborted                 (core dumped) ./memfd_test hugetlbfs
    opening: ./mnt/memfd
    fuse: DONE

If no hugetlb pages have been preallocated, run_hugetlbfs_test.sh will
allocate 'just enough' pages to run the test.  In the SEAL-FUTURE-WRITE
test the mfd_fail_write routine maps the file, but does not unmap.  As a
result, two hugetlb pages remain reserved for the mapping.  When the
fallocate call in the SEAL-SHRINK test attempts allocate all hugetlb
pages, it is short by the two reserved pages.

Fix by making sure to unmap in mfd_fail_write.

Link: https://lkml.kernel.org/r/20220219004340.56478-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 845e5f67b6f0..cf4c5276eb06 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -416,6 +416,7 @@ static void mfd_fail_write(int fd)
 			printf("mmap()+mprotect() didn't fail as expected\n");
 			abort();
 		}
+		munmap(p, mfd_def_size);
 	}
 
 	/* verify PUNCH_HOLE fails */
-- 
2.34.1



