Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC804C969C
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiCAUZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbiCAUXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:23:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D87A2505;
        Tue,  1 Mar 2022 12:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 197F0CE1EA2;
        Tue,  1 Mar 2022 20:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE818C340EF;
        Tue,  1 Mar 2022 20:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646166044;
        bh=dPBOPuj9A9oPdCJrN4XT+8hW5Fqmx4w1Ksp9fQhsW6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnS5dT6XgCGni/k1ceu9OhDSrdRh5jOr+ihBxbtn4sOj1nj+735XO0dftooqjSzb3
         roUy0a8EWv12UA5dUx6kagx4qbF/0eQ3sQ5GnpweOWRLwxziXShKm9PncHP9XxOlzn
         1MHAC8jJ/EkWkOO/KJ9whK+p0/2EXvZPnKKONxQF3ve4FsY4D0XTJNfrEvW+lEZisC
         xe8QST1EaBHGLLg/L5AbOv6XbTMPT46ZY2zoZqJCuoG6Hg/aSHd5OA56rK0oFljkL+
         7TsT10FCgJ5HFMxEdRxAWZOzno7nP6aLWR/Ad4Od+pL3C9UQnvY35g5s3JWjfm/JcP
         whWrm6ChiBlOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, gthelen@google.com,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/11] selftests/memfd: clean up mapping in mfd_fail_write
Date:   Tue,  1 Mar 2022 15:19:44 -0500
Message-Id: <20220301201951.19066-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201951.19066-1-sashal@kernel.org>
References: <20220301201951.19066-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c67d32eeb668e..290cec2a6a338 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -421,6 +421,7 @@ static void mfd_fail_write(int fd)
 			printf("mmap()+mprotect() didn't fail as expected\n");
 			abort();
 		}
+		munmap(p, mfd_def_size);
 	}
 
 	/* verify PUNCH_HOLE fails */
-- 
2.34.1

