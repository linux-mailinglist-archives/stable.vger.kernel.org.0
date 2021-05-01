Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0EE37057F
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhEAEbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:08 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:40401 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhEAEbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843419; x=1651379419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q8KnDGCNyaKah2NYt0qV8VgMyEEJbRRR6DrI23f80eA=;
  b=gksP0CAjf60Cu6WzTxWY6pWTvPsO6RBRBqfyL5HHE3ELNhKYTiDo7hVJ
   Xc1yDX9LAXnjoVTwAkAZvNyzWs7WEMvn0qM00YNL4/aQU0Y0A5Vph0C0P
   hAP3C0W4+yZfIarLENKv8Ca/vTQN10R7xrHGAAEobcW2gj+MlCQcugojo
   s=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="110970697"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 01 May 2021 04:30:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id D187A140AD4;
        Sat,  1 May 2021 04:30:15 +0000 (UTC)
Received: from EX13D01UWB004.ant.amazon.com (10.43.161.157) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB004.ant.amazon.com (10.43.161.157) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 3D108DE2; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 00/15] fix backports, add CVE-2021-29155 fixes
Date:   Sat, 1 May 2021 04:29:59 +0000
Message-ID: <20210501043014.33300-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series contains backports for BPF commits for 4.14, except two commits
that are 4.14-only commits. One 4.14-only commit was already acked by
a BPF maintainer (see below). The other one is a selftest follow-up.

The backports were not complicated. But, copying to bpf@ and BPF
maintainers for a sanity check.

What the series does is:

* Fix errors in an older bpf 4.14 backport (this fix was sent in earlier
  to bpf@, and acked).
* Fix selftests after recent bpf backports to 4.14 (but before the
  fixes for CVE-2021-29155).
* Backport fixes for CVE-2021-29155, including selftests changes.
* Backport commits that disallow the mangling of valid pointers by root
  (one commit that came in shortly after 4.14, one follow-up fix). This
  also means that 5 verifier selftests that always failed on the 4.14
  branch are OK again.
* Backport selftest commits to adapt alignment selftests after the previous.

Verifier/alignment selftests are now clean on the 4.14 branch, which should
help prevent further backporting errors.

Listed by their mainline commit id (except when 4.14 only):

<4.14 only> ("bpf: Fix backport of "bpf: restrict unknown scalars of mixed signed bounds for unprivileged")
	This was sent in by Sam to bpf@ earlier, and acked by Yonghong Song,
	https://lore.kernel.org/bpf/20210419235641.5442-1-samjonas@amazon.com/T/#u

	I am including it so that it is 'formally' submitted it
	to -stable.

<4.14 only> ("bpf: fix up selftests after backports were fixed")
	This is a follow-up to the previous by me, to fix selftests. It's
	from 80c9b2fae87b ("bpf: add various test cases to selftests"), but
	since that one was already partially added to the 4.14 branch
	in 03f11a51a196 ("bpf: Fix selftests are changes for CVE 2019-7308"),
	it's not a "backport" as such. To avoid confusion, I created a
	separate commit for it, referencing the original commit
	in the message. I examined each individual changed test, and
	went through the history to see that the error message was indeed
	as expected.


0a13e3537ea6 ("bpf, selftests: Fix up some test_verifier cases for unprivileged")
	After some recent backports of bpf fixes to 4.14 (separate from this
	series), there are some selftests that need to be modified. This
	backported commit does that. No major conflicts/issues. For 4.14,
	some tests do not exist yet, so they were skipped.



The next ones  are a backport of the BPF verifier fixes for CVE-2021-29155.
Original series was part of the pull request here: https://lore.kernel.org/bpf/20210416223700.15611-1-daniel@iogearbox.net/T/


960114839252 ("bpf: Use correct permission flag for mixed signed bounds arithmetic")
	* Not applicable for 4.14, as it does not have
	  2c78ee898d8f ("bpf: Implement CAP_BPF").

6f55b2f2a117 ("bpf: Move off_reg into sanitize_ptr_alu")
	* Minor contextual conflict: verbose() does not have the env
	  argument in 4.14.

24c109bb1537 ("bpf: Ensure off_reg has no mixed signed bounds for all types")
	* This deletes a switch() case in adjust_ptr_min_max_vals, since
	  it moves the check in it to retrieve_ptr_limit. For 4.14, that
	  switch() statement was still 2 if() statements, since it does not
	  have aad2eeaf4697 ("bpf: Simplify ptr_min_max_vals adjustment").

	  The equivalent change for 4.14 is to delete the PTR_TO_MAP_VALUE
	  if().

b658bbb844e2 ("bpf: Rework ptr_limit into alu_limit and add common error path")
	* Clean cherry-pick.

a6aaece00a57 ("bpf: Improve verifier error messages for users")
	* Simple contextual conflict in adjust_scalar_min_max_vals().
	  because of a var declaration that was added by this post-5.4 commit:
	  3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking").
	* Additional simple contextual conflict: verbose() does not have
	  the env argument in 4.14.

073815b756c5 ("bpf: Refactor and streamline bounds check into helper")
	* This factors out the bounds check in adjust_ptr_min_max_vals
	  in to a separate function. In 4.14, the bounds check block
	  in question looks a little different, because:
		* 4.14 still uses allow_ptr_leaks, not bypass_spec_v1.
		* 01f810ace9ed ("bpf: Allow variable-offset stack access")
		  changed the call to check_stack_access to a new function,
		  check_stack_access_for_ptr_arithmetic(), and moved/changed
		  an error message.
	* Since this commit just factors out some code from
	  adjust_ptr_min_max_vals() in to a new function, do the same
  	  with the corresponding block in 4.14 that doesn't have the
	  changes listed above from post-4.14 commits.
	
f528819334 ("bpf: Move sanitize_val_alu out of op switch")
	* Resolved contextual conflict from post-4.14 commit
	  3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking"),
	  that added a comment on top of the switch referenced in the commit
	  message.

7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask")
	* Resolved contextual conflict post-4.14 commit:
	  3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
	  added a call to a new function just above the switch statement in
	  adjust_ptr_min_max_vals. This doesn't affect the lines that were
	  actually changed.
	* Resolved contextual conflict:
	  01f810ace9ed ("bpf: Allow variable-offset stack access") added
	  a comment to the PTR_TO_STACK case in retrieve_ptr_limit. This
	  comment is not present in 4.14, but the code is the same.

d7a509135175 ("bpf: Update selftests to reflect new error states")
	* Post-4.14, the verifier tests were split in to different
	  files, in 4.14 they are still all in test_verifier.c.
	* The bounds.c tests have undergone several changes since 4.14,
	  related to commits that were not backported (like e.g. the
	  ALU32 changes). The error message will remain the same on 4.14.
	* 4f7b3e82589e ("bpf: improve verifier branch analysis") changed
	  the error message for the "bounds checks mixing signed and
	  unsigned, variant 14" test. Since 4.14 does not have that commit,
	  this test will still produce the original error message ("R0
	  invalid mem access 'inv'").

The rest of the commits are to pull in a few commits that get the number
of verifier/align selftest errors on the 4.14 branch down to 0. This is
mainly about the first one:

82abbf8d2fc4 ("bpf: do not allow root to mangle valid pointers")
	* This commit has a follow-up that must be added as well,
	  see the next commit.
	* As the commit message states, this mostly disallows
	  pointer mangling that was allowed by
	  f1174f77b50c ("bpf/verifier: rework value tracking").
	  Allowing root to mangle valid pointers also results
	  in the unexpected successful loading of some selftests,
	  so backporting this fixes that.
	* Resolved contextual conflict: 4.14 does not have the
	  env argument to verbose

dd066823db2a ("bpf/verifier: disallow pointer subtraction")
	* Fixes the above.
	* Minor contextual conflict: mark_reg_unknown does not
	  have an env argument on 4.14.

2b36047e7889 ("selftests/bpf: fix test_align")
	* Selftest follow-up to
	  82abbf8d2fc4 ("bpf: do not allow root to mangle valid pointers")
	* Clean cherry-pick.

31e95b61e172 ("selftests/bpf: make 'dubious pointer arithmetic' test useful")
	* Selftest follow-up to the above.
	* Conflict: 4.14 does not have 'liveness' of registers in the
	  output, so adjust the expected output to match.



=====

Alexei Starovoitov (4):
  bpf: do not allow root to mangle valid pointers
  bpf/verifier: disallow pointer subtraction
  selftests/bpf: fix test_align
  selftests/bpf: make 'dubious pointer arithmetic' test useful

Daniel Borkmann (8):
  bpf: Move off_reg into sanitize_ptr_alu
  bpf: Ensure off_reg has no mixed signed bounds for all types
  bpf: Rework ptr_limit into alu_limit and add common error path
  bpf: Improve verifier error messages for users
  bpf: Refactor and streamline bounds check into helper
  bpf: Move sanitize_val_alu out of op switch
  bpf: Tighten speculative pointer arithmetic mask
  bpf: Update selftests to reflect new error states

Frank van der Linden (1):
  bpf: fix up selftests after backports were fixed

Piotr Krysiuk (1):
  bpf, selftests: Fix up some test_verifier cases for unprivileged

Samuel Mendoza-Jonas (1):
  bpf: Fix backport of "bpf: restrict unknown scalars of mixed signed
    bounds for unprivileged"

 kernel/bpf/verifier.c                       | 330 ++++++++++++--------
 tools/testing/selftests/bpf/test_align.c    |  26 +-
 tools/testing/selftests/bpf/test_verifier.c | 104 +++---
 3 files changed, 269 insertions(+), 191 deletions(-)

-- 
2.23.3

