Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3824760E3
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbhLOSkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 13:40:22 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:14366 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbhLOSkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 13:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639593604;
    s=strato-dkim-0002; d=goldelico.com;
    h=Message-Id:To:Cc:Subject:Date:From:Cc:Date:From:Subject:Sender;
    bh=dKbgH0vR+QJjU7spojHrVUphFvJo+KgTCqf0bJ8RLJU=;
    b=E40hQOpKqrStZROQs6g4HoYcO8ifEPYuGHf7WPaFRHh0/udaBcX9wDIzfwls00IgB+
    EycckmDDJu/XNdrS/vnEi4hl4qWIsrtfXaroFSKuoAYAEhHRMRzZkYaTGQyeLGvyKL/u
    VQaCGA45w9Jr/5JW8QJ/i6hR9yGzCIxP0Bi4FsthO5dMA4FGRAtOy4fqoMzAbbL+AdSI
    oHXTp6hiWpMISn4bXM/3AFwXpdRfcFFJKmfWuZN2P6CDg+Z4y9BBlVr3p/O3kVD0Bt51
    Qxiq9Ju9V3d/iA5ZchGcjCXnayIi+bZQx75CfEmxnJkrKjyh2nbY6oDq7g00qCOzxWFW
    f5kA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NIGH/jrwDSqhg=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.35.3 DYNA|AUTH)
    with ESMTPSA id 404833xBFIe3AFj
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Wed, 15 Dec 2021 19:40:03 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Date:   Wed, 15 Dec 2021 19:40:02 +0100
Subject: Bug with KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and
 CPTR_EL2 to 1
Cc:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        reg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <DB8835B4-8F04-4669-87EA-D348FA47A79D@goldelico.com>
X-Mailer: Apple Mail (2.3445.104.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

this seems to break build of 5.10.y (and maybe earlier) for me:

  CALL    scripts/checksyscalls.sh - due to target missing
  CALL    scripts/atomic/check-atomics.sh - due to target missing
  CHK     include/generated/compile.h
  AS      arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o - due to target =
missing
arch/arm64/kvm/hyp/nvhe/hyp-init.S: Assembler messages:
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: unexpected characters =
following instruction at operand 2 -- `mov x1,#((1U<<31)|(1<<23))'
arch/arm64/kvm/hyp/nvhe/Makefile:28: recipe for target =
'arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o' failed
make[5]: *** [arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o] Error 1
scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm/hyp/nvhe' =
failed
make[4]: *** [arch/arm64/kvm/hyp/nvhe] Error 2
scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm/hyp' =
failed
make[3]: *** [arch/arm64/kvm/hyp] Error 2
scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm' failed
make[2]: *** [arch/arm64/kvm] Error 2
Makefile:1822: recipe for target 'arch/arm64' failed
make[1]: *** [arch/arm64] Error 2
Makefile:336: recipe for target '__build_one_by_one' failed
make: *** [__build_one_by_one] Error 2

Looking at the problematic line 87 of hyp-init.S shows that
there is a macro expansion:

      mov     x1, #TCR_EL2_RES1

This macro was modified by the $subject patch
(commit c71b5f37b5ff1a673b2e4a91d1b34ea027546e23 in v5.10.y)
and reverting the patch makes the compile succeed.

Now: why does it build for me for v5.15.y and v5.16-rc5?
I think it is because my build system switches to gcc 6.3
instead of gcc 4.9 depending on scripts/min-tool-version.sh.

So I assume that the fix is not compatible with the minimum
requirement for 5.10.y of gcc 4.9 (or even less - I don't know exactly).
Earlier kernels may also be affected if $subject patch was also
backported there, but I have not tested.

This should somehow be fixed so that arch/arm64/include/asm/kvm_arm.h
can be included by older assemblers.

BR and thanks,
Nikolaus Schaller

