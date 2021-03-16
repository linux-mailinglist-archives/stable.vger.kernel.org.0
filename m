Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B932933E08F
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhCPVcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhCPVbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:31:48 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BFCC06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 14:31:48 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id k92so22722481qva.20
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 14:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9qIl2h84+tEpR/qPDqw7Ia65+Rx0tWJMRUJLpgSeqnM=;
        b=VKidfvf+MG8jEETiiE08axf+7iZQSbpLglqhROkebIZt0fikpDpV+kmPgHe73Lb49T
         F6Jt3upfNFYoCxTLLr1Z2K++BKVf9H7bLpTYOrOCm/U9fkU1VyayTnp28aq/OnASgofU
         Z6jsIV8CsPGH6Oo95QDA+JzG0J+v1sOJwO1sFf8/SskIpOSdb2U5uPvoBy0gKHGlRm9p
         jfsnW/ubAhcqY5QOmfnydoebGLjEyF8lN8awAq8SdqJwv7JQ+Q6N+dLLxyAfA/ov9cx0
         CfTsAP240chH8GQBxFrb83QwL8m9p3jUl09lRYdM759F98i+SG29MZHWRvyLszMsA9pN
         F2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9qIl2h84+tEpR/qPDqw7Ia65+Rx0tWJMRUJLpgSeqnM=;
        b=V8Kqm0xwKTQ0NK1PU+WeHnRw6Eyi48L1gEYjzwGgVWsk1a8Ntvv4kNNh+Fc2YCnH1g
         fZkerNy16xwboYv0DePUA7eCv1PdItwKbSbjrxs6JVXucu87r4kdcpFSmapoZqkVQlet
         ZaIt1CJ1L517L7poGhunFxienDZHfruOWV5zBfJMj6jGBzh/WC85OoBf9tXR+nUGEvuz
         0hqF/vdEXusCwwlxiy0GcHgCsnoA0VoUVIL1nIlV7XvkanXzU0VkoMku6Xi7BSoD487i
         y0rS4iqOcNoOGsqv8UsKMwHm/3X3YNZTpxOTLqI1AqEP72Kj9DbIQ1TEmo18wj1pUiLl
         OpgQ==
X-Gm-Message-State: AOAM531/sr4potLD/CYvhKaEEKD3p/Vr5O6wBb3DuOyUP/GgfF1oo6oL
        usH2mL/Q9y81apmSFVWwPCvMmUfPL9fYKHZiND8=
X-Google-Smtp-Source: ABdhPJxIW6jDWu6KdNEpIRhbBqjCtyfJcmFkSZFoI1+waUeR+OqLTQtQfV45DrCQ6Cik8oLM3S/lHWzj7Dwr7A4Wpz4=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:b408:7c5f:edf4:6c69])
 (user=ndesaulniers job=sendgmr) by 2002:a05:6214:2b06:: with SMTP id
 jx6mr1632764qvb.48.1615930306822; Tue, 16 Mar 2021 14:31:46 -0700 (PDT)
Date:   Tue, 16 Mar 2021 14:31:33 -0700
Message-Id: <20210316213136.1866983-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] scripts: stable: add script to validate backports
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Ard Biesheuvel <ard@kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A common recurring mistake made when backporting patches to stable is
forgetting to check for additional commits tagged with `Fixes:`. This
script validates that local commits have a `commit <sha40> upstream.`
line in their commit message, and whether any additional `Fixes:` shas
exist in the `master` branch but were not included. It can not know
about fixes yet to be discovered, or fixes sent to the mailing list but
not yet in mainline.

To save time, it avoids checking all of `master`, stopping early once
we've reached the commit time of the earliest backport. It takes 0.5s to
validate 2 patches to linux-5.4.y when master is v5.12-rc3 and 5s to
validate 27 patches to linux-4.19.y. It does not recheck dependencies of
found fixes; the user is expected to run this script to a fixed point.
It depnds on pygit2 python library for working with git, which can be
installed via:
$ pip3 install pygit2

It's expected to be run from a stable tree with commits applied.  For
example, consider 3cce9d44321e which is a fix for f77ac2e378be. Let's
say I cherry picked f77ac2e378be into linux-5.4.y but forgot
3cce9d44321e (true story). If I ran:

$ ./scripts/stable/check_backports.py
Checking 1 local commits for additional Fixes: in master
Please consider backporting 3cce9d44321e as a fix for f77ac2e378be

So then I could cherry pick 3cce9d44321e as well:
$ git cherry-pick -sx 3cce9d44321e
$ ./scripts/stable/check_backports.py
...
Exception: Missing 'commit <sha40> upstream.' line

Oops, let me fixup the commit message and retry.
$ git commit --amend
<fix commit message>
$ ./scripts/stable/check_backports.py
Checking 2 local commits for additional Fixes: in master
$ echo $?
0

This allows for client side validation by the backports author, and
server side validation by the stable kernel maintainers.

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 MAINTAINERS                       |  1 +
 scripts/stable/check_backports.py | 92 +++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)
 create mode 100755 scripts/stable/check_backports.py

diff --git a/MAINTAINERS b/MAINTAINERS
index aa84121c5611..a8639e9277c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16960,6 +16960,7 @@ M:	Sasha Levin <sashal@kernel.org>
 L:	stable@vger.kernel.org
 S:	Supported
 F:	Documentation/process/stable-kernel-rules.rst
+F:	scripts/stable/
 
 STAGING - ATOMISP DRIVER
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
diff --git a/scripts/stable/check_backports.py b/scripts/stable/check_backports.py
new file mode 100755
index 000000000000..529294e247ca
--- /dev/null
+++ b/scripts/stable/check_backports.py
@@ -0,0 +1,92 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 Google, Inc.
+
+import os
+import re
+import sys
+
+import pygit2 as pg
+
+
+def get_head_branch(repo):
+    # Walk the branches to find which is HEAD.
+    for branch_name in repo.branches:
+        branch = repo.branches[branch_name]
+        if branch.is_head():
+            return branch
+
+
+def get_local_commits(repo):
+    head_branch = get_head_branch(repo)
+    # Walk the HEAD ref until we hit the first commit from the upstream.
+    walker = repo.walk(repo.head.target)
+    upstream_branch = head_branch.upstream
+    upstream_commit, _ = repo.resolve_refish(upstream_branch.name)
+    walker.hide(upstream_commit.id)
+    commits = [commit for commit in walker]
+    if not len(commits):
+        raise Exception("No local commits")
+    return commits
+
+
+def get_upstream_shas(commits):
+    upstream_shas = []
+    prog = re.compile('commit ([0-9a-f]{40}) upstream.')
+    # For each line of each commit message, record the
+    # "commit <sha40> upstream." line.
+    for commit in commits:
+        found_upstream_line = False
+        for line in commit.message.splitlines():
+            result = prog.search(line)
+            if result:
+                upstream_shas.append(result.group(1)[:12])
+                found_upstream_line = True
+                break
+        if not found_upstream_line:
+            raise Exception("Missing 'commit <sha40> upstream.' line")
+    return upstream_shas
+
+
+def get_oldest_commit_time(repo, shas):
+    commit_times = [repo.resolve_refish(sha)[0].commit_time for sha in shas]
+    return sorted(commit_times)[0]
+
+
+def get_fixes_for(shas):
+    shas = set(shas)
+    prog = re.compile("Fixes: ([0-9a-f]{12,40})")
+    # Walk commits in the master branch.
+    master_commit, master_ref = repo.resolve_refish("master")
+    walker = repo.walk(master_ref.target)
+    oldest_commit_time = get_oldest_commit_time(repo, shas)
+    fixes = []
+    for commit in walker:
+        # It's not possible for a Fixes: to be committed before a fixed tag, so
+        # don't iterate all of git history.
+        if commit.commit_time < oldest_commit_time:
+            break
+        for line in reversed(commit.message.splitlines()):
+            result = prog.search(line)
+            if not result:
+                continue
+            fixes_sha = result.group(1)[:12]
+            if fixes_sha in shas and commit.id.hex[:12] not in shas:
+                fixes.append((commit.id.hex[:12], fixes_sha))
+    return fixes
+
+
+def report(fixes):
+    if len(fixes):
+        for fix, broke in fixes:
+            print("Please consider backporting %s as a fix for %s" % (fix, broke))
+        sys.exit(1)
+
+
+if __name__ == "__main__":
+    repo = pg.Repository(os.getcwd())
+    commits = get_local_commits(repo)
+    print("Checking %d local commits for additional Fixes: in master" % (len(commits)))
+    upstream_shas = get_upstream_shas(commits)
+    fixes = get_fixes_for(upstream_shas)
+    report(fixes)
-- 
2.31.0.rc2.261.g7f71774620-goog

