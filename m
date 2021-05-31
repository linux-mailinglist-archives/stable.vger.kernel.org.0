Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1613967D1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhEaS1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:27:49 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:15273 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhEaS1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485560; x=1654021560;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zgue9LdRFIrhSzSfpiimjBB+WSTbFvB1kk0jQ6j5iOs=;
  b=jpD1wDFEUUShmgOTkBM1CeBuC/6Eqes9cTRMOucSJp1qfVbgdqWzIDBP
   qApv1YDqbU9Lhx4HxFmflqMR19n6xSelQn0xkM3/q0UuKutgwEl1oJSlX
   tNDr1yS2RbVYh2WFtK03npcMvrlzYo+9835vu747jfko6ZBBycBIKDuPj
   w=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="137675706"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 31 May 2021 18:25:59 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 05C81A06B0;
        Mon, 31 May 2021 18:25:58 +0000 (UTC)
Received: from EX13D04UEA002.ant.amazon.com (10.43.61.61) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D04UEA002.ant.amazon.com (10.43.61.61) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:57 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:57
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 873B4149E; Mon, 31 May 2021 18:25:56 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 00/16] CVE fixes and selftests cleanup
Date:   Mon, 31 May 2021 18:25:39 +0000
Message-ID: <20210531182556.25277-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that these are being included in 4.19, I am resending this
4.14 series. It was originally sent here:

https://lore.kernel.org/bpf/20210501043014.33300-5-fllinden@amazon.com/T/

v2:
  * The backport repairs in that original series were already included in
    4.14, so they are no longer needed.

  * Add additional commit for CVE-2021-31829.

  * Added cherry-picks for CVE-2021-33200.

==

This series contains backports for BPF commits for 4.14, fixing
some CVEs and making the verifier selftests clean (666 passed,
0 failures).

What the series does is:

* Fix selftests after recent bpf backports to 4.14 (but before the
  fixes for CVE-2021-29155).
* Backport fixes for CVE-2021-29155, including selftests changes.
* Backport commits that disallow the mangling of valid pointers by root
  (one commit that came in shortly after 4.14, one follow-up fix). This
  also means that 5 verifier selftests that always failed on the 4.14
  branch are OK again.
* Backport selftest commits to adapt alignment selftests after the previous.
* Cherry-pick commit for CVE-2021-31829
* Cherry-pick commits for CVE-2021-33200

Verifier/alignment selftests are now clean on the 4.14 branch.

Listed by their mainline commit id, with comments on changes made
for backporting:

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

These next commits are to pull in a few commits that get the number
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

The next commit is to fix CVE-2021-31829. One of two commits that fixes
this was already applied (b9b34ddbe207 ("bpf: Fix masking negation logic
upon negative dst register"), but we still need this one.

801c6058d14a ("bpf: Fix leakage of uninitialized bpf stack under
speculation")
	* Minor fixup: e6ac593372aa ("bpf: Rename fixup_bpf_calls and
	  add some comments") renamed fixup_bpf_calls, which did not happen
	  on the 4.14 branch.

The last ones are for CVE-2021-33200, and were all clean cherry-picks.
This also has a selftests change in mainline, but the test it changes
isn't present in 4.14.

3d0220f6861d ("bpf: Wrap aux data inside bpf_sanitize_info container")
bb01a1bba579 ("bpf: Fix mask direction swap upon off reg sign change")
a7036191277f ("bpf: No need to simulate speculative domain for
immediates")

====

Alexei Starovoitov (4):
  bpf: do not allow root to mangle valid pointers
  bpf/verifier: disallow pointer subtraction
  selftests/bpf: fix test_align
  selftests/bpf: make 'dubious pointer arithmetic' test useful

Daniel Borkmann (12):
  bpf: Move off_reg into sanitize_ptr_alu
  bpf: Ensure off_reg has no mixed signed bounds for all types
  bpf: Rework ptr_limit into alu_limit and add common error path
  bpf: Improve verifier error messages for users
  bpf: Refactor and streamline bounds check into helper
  bpf: Move sanitize_val_alu out of op switch
  bpf: Tighten speculative pointer arithmetic mask
  bpf: Update selftests to reflect new error states
  bpf: Fix leakage of uninitialized bpf stack under speculation
  bpf: Wrap aux data inside bpf_sanitize_info container
  bpf: Fix mask direction swap upon off reg sign change
  bpf: No need to simulate speculative domain for immediates

Piotr Krysiuk (1):
  bpf, selftests: Fix up some test_verifier cases for unprivileged

 include/linux/bpf_verifier.h                |   5 +-
 kernel/bpf/verifier.c                       | 369 ++++++++++++--------
 tools/testing/selftests/bpf/test_align.c    |  26 +-
 tools/testing/selftests/bpf/test_verifier.c | 114 +++---
 4 files changed, 299 insertions(+), 215 deletions(-)
