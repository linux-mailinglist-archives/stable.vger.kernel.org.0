Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAB383A09
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfHFUHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:07:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90FD920717;
        Tue,  6 Aug 2019 20:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565122062;
        bh=VnMHcDacKACEPRu6AMaF7XFeS1PjnEm5LeR28LrPZl0=;
        h=Date:From:To:Subject:From;
        b=fduitHuztc9jDa/CpOcsPyOCvzaeZAuly9Ty5Ing0pb/qlmx3/pyELHgqQDXnJxiF
         BW9vcy1A/x31cIFp6aa6W4yC3RZ/wNME8ZTAQG40IACFTM9B46bBUnJOD/47FNUoqo
         KzYJFsQqWg7B1BabnPEytYBKDN1tZF1WO82tlWQk=
Date:   Tue, 06 Aug 2019 13:07:42 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org
Subject:  [merged] cgroup-kselftest-relax-fs_spec-checks.patch
 removed from -mm tree
Message-ID: <20190806200742.3XViKrTYY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: cgroup: kselftest: relax fs_spec checks
has been removed from the -mm tree.  Its filename was
     cgroup-kselftest-relax-fs_spec-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-throttle-allocators-when-failing-reclaim-over-memoryhigh.patch
mm-throttle-allocators-when-failing-reclaim-over-memoryhigh-fix-fix-fix-fix.patch
mm-proportional-memorylowmin-reclaim.patch
mm-make-memoryemin-the-baseline-for-utilisation-determination.patch
mm-make-memoryemin-the-baseline-for-utilisation-determination-fix.patch

