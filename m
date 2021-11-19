Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629F8456DAF
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 11:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhKSKmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 05:42:51 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:30304 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhKSKmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 05:42:50 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2021 05:42:50 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637318014;
    s=strato-dkim-0002; d=goldelico.com;
    h=Message-Id:To:Cc:Subject:Date:From:Cc:Date:From:Subject:Sender;
    bh=4Wg+NXNW31gedVsJj0x/d7Mf2+YbOBa/c/3hL99tpsM=;
    b=FR6yZH1dQFQ6VYDmkvb2REWWs9kOQfLZRcaAjciOixU0G/tM2oiewkibZTiRFLNf6h
    BDT72l4Wg1D22BwPkpdhx9O+gmXyI44Y57KOoWo2vm4jZA8HFDdZFRSPkPzzeC1KkqBw
    GA3bRBv6EMvWiEqaKBsymEy+CrOGDA1YLc0EOYl+JCgnEF1NMWAwfG7nBZCZ0YJ2r86z
    z0va2Y2c6rfp5HwAc+KgkjV9eqaP8Srw1pWkE90fsi7ZadiU4pAmZ2T0/I+ij0pvnG9p
    A6z6mBY5DK48Oq64Ha/vPOkUVo0+9yKMyWE1U7Rkdcd1Y0R9d8DwL+axRf+k8BxVKPjp
    PWKA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NIGH/jrwDOoERs="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id Y02aa4xAJAXYcaW
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Fri, 19 Nov 2021 11:33:34 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Date:   Fri, 19 Nov 2021 11:33:33 +0100
Subject: Bug: arch/x86/kvm/x86.c:3241: Error: bad register name `%dil'
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        gregkh@linuxfoundation.org
To:     David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <903C3043-174A-4C67-9823-E433CD5DEA53@goldelico.com>
X-Mailer: Apple Mail (2.3445.104.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paolo and David,
I have a strange compile error which appeared in v5.15.3:

  CALL    scripts/checksyscalls.sh - due to target missing
  CALL    scripts/atomic/check-atomics.sh - due to target missing
  CHK     include/generated/compile.h - due to compile.h not in $(targets)
  CC      arch/x86/kvm/x86.o - due to target missing
arch/x86/kvm/x86.c: Assembler messages:
arch/x86/kvm/x86.c:3241: Error: bad register name `%dil'
scripts/Makefile.build:277: recipe for target 'arch/x86/kvm/x86.o' failed
make[3]: *** [arch/x86/kvm/x86.o] Error 1
scripts/Makefile.build:540: recipe for target 'arch/x86/kvm' failed
make[2]: *** [arch/x86/kvm] Error 2
Makefile:1868: recipe for target 'arch/x86' failed
make[1]: *** [arch/x86] Error 2
Makefile:350: recipe for target '__build_one_by_one' failed
make: *** [__build_one_by_one] Error 2

My (cross-)compiler is a gcc 6.3.0 for 32 bit x86.

It is neither with v5.15.2 nor v5.16-rc1 nor v5.14.20.

The code line 3241 is:

		asm volatile("1: xchgb %0, %2\n"
			     "xor %1, %1\n"
			     "2:\n"
			     _ASM_EXTABLE_UA(1b, 2b)
			     : "+r" (st_preempted),
			       "+&r" (err)
			     : "m" (st->preempted));

This seems to have been introduced by:

9d12bf19b278 KVM: x86: Fix recording of guest steal time / preempted status

but it is a backport of commit 7e2175ebd695f17860c5bd4ad7616cce12ed4591
which was also merged to 5.14.20.

So maybe the backport is incomplete or has some hidden dependency?
But only on the 5.15.y series?

BR and thanks,
Nikolaus Schaller



