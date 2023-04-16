Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E546E3AC3
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjDPRmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjDPRmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35EB3AA7;
        Sun, 16 Apr 2023 10:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4110B61C60;
        Sun, 16 Apr 2023 17:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9800FC433EF;
        Sun, 16 Apr 2023 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666926;
        bh=D4qhR4GbiXGiOxFvy28qVgkD4TVHqbstGsuB71+EBp4=;
        h=Date:To:From:Subject:From;
        b=EvorFA6Y8WeOTqpvzVs8EEsqi5jQPWiMcd1TjIfSBr2Qx/3goT53fgsT5Cv+X83B5
         c9QDxdjPPi97Daci3riRCjOsiD1Y2W/MMlj27/F0FBc2zGdp0IEZ3Kx457D1CgvSJW
         +xH0WOLq8oVUu/raaQnCWa528FfKiEK3kG9lRJxo=
Date:   Sun, 16 Apr 2023 10:42:06 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stable@vger.kernel.org, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, axelrasmussen@google.com, 0x7f454c46@gmail.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-userfaultfd-dont-fail-on-unrecognized-features.patch removed from -mm tree
Message-Id: <20230416174206.9800FC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: Revert "userfaultfd: don't fail on unrecognized features"
has been removed from the -mm tree.  Its filename was
     revert-userfaultfd-dont-fail-on-unrecognized-features.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: Revert "userfaultfd: don't fail on unrecognized features"
Date: Wed, 12 Apr 2023 12:38:52 -0400

This is a proposal to revert commit 914eedcb9ba0ff53c33808.

I found this when writing a simple UFFDIO_API test to be the first unit
test in this set.  Two things breaks with the commit:

  - UFFDIO_API check was lost and missing.  According to man page, the
  kernel should reject ioctl(UFFDIO_API) if uffdio_api.api != 0xaa.  This
  check is needed if the api version will be extended in the future, or
  user app won't be able to identify which is a new kernel.

  - Feature flags checks were removed, which means UFFDIO_API with a
  feature that does not exist will also succeed.  According to the man
  page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
  unknown features passed in.

Link: https://lore.kernel.org/r/20220722201513.1624158-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20230412163922.327282-2-peterx@redhat.com
Fixes: 914eedcb9ba0 ("userfaultfd: don't fail on unrecognized features")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/userfaultfd.c~revert-userfaultfd-dont-fail-on-unrecognized-features
+++ a/fs/userfaultfd.c
@@ -1955,8 +1955,10 @@ static int userfaultfd_api(struct userfa
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	/* Ignore unsupported features (userspace built against newer kernel) */
-	features = uffdio_api.features & UFFD_API_FEATURES;
+	features = uffdio_api.features;
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
 		goto err_out;
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch

