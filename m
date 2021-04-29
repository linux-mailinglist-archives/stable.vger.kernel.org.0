Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1A36F26B
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhD2WJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:34365 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhD2WJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734122; x=1651270122;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6x0SPSCEr/f131JyzJyPkVBXVVcIa5vjOG3O9JgFU0E=;
  b=FrT4tGyTNkg2NAwICReoIEQEExyF69xco9Bgk+QAlK9342JMmRY2aBQ0
   p97M21AwNMXXUZ9k4g+9HKyU399FhvaJYhGhdU3Bz1+p9PTo373yJUpi7
   KOPJtzQ7SPTi7HryhiIaw4p1dJjkkyWSaGsodEn2vgf0HolSr66xK+fnL
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="122750292"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 29 Apr 2021 22:08:41 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id DC7D4C01A0;
        Thu, 29 Apr 2021 22:08:40 +0000 (UTC)
Received: from EX13D31UWC001.ant.amazon.com (10.43.162.152) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D31UWC001.ant.amazon.com (10.43.162.152) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:39 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:40 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id CF67C98E; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Date:   Thu, 29 Apr 2021 22:08:31 +0000
Message-ID: <20210429220839.15667-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the BPF verifier fixes for CVE-2021-29155. Original
series was part of the pull request here: https://lore.kernel.org/bpf/20210416223700.15611-1-daniel@iogearbox.net/T/

This wasn't a complicated backport, but copying bpf@ to see if
there are any concerns.

5.4 verifier selftests are clean with this backport:
	Summary: 1566 PASSED, 0 SKIPPED, 0 FAILED

The individual commits:

960114839252 ("bpf: Use correct permission flag for mixed signed bounds arithmetic")
	* Not applicable to 5.4, as 5.4 does not have
	  2c78ee898d8f ("bpf: Implement CAP_BPF").

6f55b2f2a117 ("bpf: Move off_reg into sanitize_ptr_alu")
	* Clean cherry-pick.

24c109bb1537 ("bpf: Ensure off_reg has no mixed signed bounds for all types")
	* Conflict: allow_ptr_leaks was replaced by bypass_spec_v1 in the
	  deleted PTR_TO_MAP_VALUE switch case by
	  2c78ee898d8f ("bpf: Implement CAP_BPF"). Resolution is easy,
	  the case statement gets deleted either way.

b658bbb844e2 ("bpf: Rework ptr_limit into alu_limit and add common error path")
	* Clean cherry-pick.

a6aaece00a57 ("bpf: Improve verifier error messages for users")
	* Resolved simple contextual conflict in adjust_scalar_min_max_vals().
	  because of a var declaration that was added by this post-5.4 commit:
	  3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking").

073815b756c5 ("bpf: Refactor and streamline bounds check into helper")
	* Conflict: another allow_ptr_leaks that was replaced with
	  bypass_spec_v1 after 2c78ee898d8f.
	* Conflict: Post-5.4 commit
	  01f810ace9ed ("bpf: Allow variable-offset stack access")
	  changed the call to check_stack_access to a new function,
	  check_stack_access_for_ptr_arithmetic(), and moved/changed an
	  error message.
	* Since this commit just factors out some code from
	  adjust_ptr_min_max_vals() in to a new function, do the same
  	  with the corresponding block in 5.4 that doesn't have the
	  changes listed above from post-5.4 commits.
	
f528819334 ("bpf: Move sanitize_val_alu out of op switch")
	* Contextual conflict from post-5.4 commit
	  3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking"),
	  that added a comment on top of the switch referenced in the commit
	  message.

7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask")
	* Contextual conflict post-5.4 commit:
	  3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
	  added a call to a new function just above the switch statement in
	  adjust_ptr_min_max_vals. This doesn't affect the lines that were
	  actually changed.

d7a509135175 ("bpf: Update selftests to reflect new error states")
	* The bounds.c tests have undergone several changes since 5.4, related
	  to commits that were not backported (like e.g. the ALU32 changes).
	  The error messages for those tests will remain the same on 5.4.

=====

Daniel Borkmann (8):
  bpf: Move off_reg into sanitize_ptr_alu
  bpf: Ensure off_reg has no mixed signed bounds for all types
  bpf: Rework ptr_limit into alu_limit and add common error path
  bpf: Improve verifier error messages for users
  bpf: Refactor and streamline bounds check into helper
  bpf: Move sanitize_val_alu out of op switch
  bpf: Tighten speculative pointer arithmetic mask
  bpf: Update selftests to reflect new error states

 kernel/bpf/verifier.c                         | 233 ++++++++++++------
 .../selftests/bpf/verifier/bounds_deduction.c |  21 +-
 .../bpf/verifier/bounds_mix_sign_unsign.c     |  13 -
 tools/testing/selftests/bpf/verifier/unpriv.c |   2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c  |   6 +-
 5 files changed, 173 insertions(+), 102 deletions(-)

-- 
2.23.3

