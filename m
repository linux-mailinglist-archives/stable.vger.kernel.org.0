Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65F572166
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 23:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbfGWVTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 17:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbfGWVTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 17:19:40 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F4E2253D;
        Tue, 23 Jul 2019 21:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563916779;
        bh=7i55eQm5ppbZ8F/bqH5nwGAs8UFVW2Fzfhb5gsAfGm4=;
        h=Date:From:To:Subject:From;
        b=krbiT8iPKjRsAGoSBOZOJpgRaTk2EH4pGOeXwPzy+lhlFNQaddJYCq5YGxuS/M94f
         ZrKmu/TVWU4H8l1q8YyrToG7mlX40a+HsPihqKajeDkvcSOHsERK8ySShcRxdVjsW6
         CIwzEFYJNdmbclOakOMOpDzPZTIki+8IS+qCVe4o=
Date:   Tue, 23 Jul 2019 14:19:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        hannes@cmpxchg.org, guro@fb.com, chris@chrisdown.name
Subject:  + cgroup-kselftest-relax-fs_spec-checks.patch added to -mm
 tree
Message-ID: <20190723211939.U3PHi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: cgroup: kselftest: relax fs_spec checks
has been added to the -mm tree.  Its filename is
     cgroup-kselftest-relax-fs_spec-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cgroup-kselftest-relax-fs_spec-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cgroup-kselftest-relax-fs_spec-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: cgroup: kselftest: relax fs_spec checks

On my laptop most memcg kselftests were being skipped because it claimed
cgroup v2 hierarchy wasn't mounted, but this isn't correct.  Instead, it
seems current systemd HEAD mounts it with the name "cgroup2" instead of
"cgroup":

    % grep cgroup /proc/mounts
    cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0

I can't think of a reason to need to check fs_spec explicitly
since it's arbitrary, so we can just rely on fs_vfstype.

After these changes, `make TARGETS=cgroup kselftest` actually runs the
cgroup v2 tests in more cases.

Link: http://lkml.kernel.org/r/20190723210737.GA487@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/cgroup_util.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c~cgroup-kselftest-relax-fs_spec-checks
+++ a/tools/testing/selftests/cgroup/cgroup_util.c
@@ -191,8 +191,7 @@ int cg_find_unified_root(char *root, siz
 		strtok(NULL, delim);
 		strtok(NULL, delim);
 
-		if (strcmp(fs, "cgroup") == 0 &&
-		    strcmp(type, "cgroup2") == 0) {
+		if (strcmp(type, "cgroup2") == 0) {
 			strncpy(root, mount, len);
 			return 0;
 		}
_

Patches currently in -mm which might be from chris@chrisdown.name are

cgroup-kselftest-relax-fs_spec-checks.patch
mm-throttle-allocators-when-failing-reclaim-over-memoryhigh.patch
mm-proportional-memorylowmin-reclaim.patch
mm-make-memoryemin-the-baseline-for-utilisation-determination.patch
mm-make-memoryemin-the-baseline-for-utilisation-determination-fix.patch

