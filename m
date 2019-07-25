Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7575392
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbfGYQJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:09:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:10970 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfGYQJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 12:09:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 09:09:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="189348518"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga001.fm.intel.com with ESMTP; 25 Jul 2019 09:09:39 -0700
Date:   Thu, 25 Jul 2019 09:09:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        wanpengli@tencent.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, jmattson@google.com
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725160939.GC18612@linux.intel.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 07:35:13PM +0530, Naresh Kamboju wrote:
> Paolo,
> 
> On Thu, 25 Jul 2019 at 19:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 25/07/19 13:34, Greg Kroah-Hartman wrote:
> > > Any chance you can run 'git bisect' to find the offending patch?  Or
> > > just try reverting a few, you can ignore the ppc ones, so that only
> > > leaves you 7 different commits.
> > >
> > > Does this same test pass in 5.3-rc1?
> 
> Yes. same test pass on 5.3-rc1
> kvm unit test always fetching master branch and at tip
> runs the latest test code on all branches
> mainline 5.3-rc1 and stable-rc-5.2 branch
> 
> >
> > Anders, are you running the same kvm-unit-tests commit that passed for
> > 5.2.2?  My suspicion is that your previous test didn't have this commit
> 
> No.
> I see two extra test code commits for 5.2.3
> Re-tested 5.2.2 with tip of kvm unit tests sources and vmx test FAILED [1].
> 
> Greg,
> This investigation confirms it is a new test code failure on stable-rc 5.2.3

No, it only confirms that kvm-unit-tests/master fails on 5.2.*.  To confirm
a new failure in 5.2.3 you would need to show a test that passes on 5.2.2
and fails on 5.2.3.

As Paolo suspected, kvm-unit-tests/master fails on 5.2.* and passes if
commit 95d6d2c ("nVMX: Test Host Segment Registers and Descriptor Tables on
vmentry of nested guests") is reverted (from kvm-unit-tests).

The failures are quite clearly in the new test(s).

  PASS: HOST_SEL_CS 8: vmlaunch succeeds
  FAIL: HOST_SEL_CS 9: vmlaunch fails
  FAIL: HOST_SEL_CS c: vmlaunch fails
  PASS: HOST_SEL_SS 10: vmlaunch succeeds
  FAIL: HOST_SEL_SS 11: vmlaunch fails
  FAIL: HOST_SEL_SS 14: vmlaunch fails
  PASS: HOST_SEL_DS 10: vmlaunch succeeds
  FAIL: HOST_SEL_DS 11: vmlaunch fails
  FAIL: HOST_SEL_DS 14: vmlaunch fails
  PASS: HOST_SEL_ES 10: vmlaunch succeeds
  FAIL: HOST_SEL_ES 11: vmlaunch fails
  FAIL: HOST_SEL_ES 14: vmlaunch fails
  PASS: HOST_SEL_FS 10: vmlaunch succeeds
  FAIL: HOST_SEL_FS 11: vmlaunch fails
  FAIL: HOST_SEL_FS 14: vmlaunch fails
  PASS: HOST_SEL_GS 10: vmlaunch succeeds
  FAIL: HOST_SEL_GS 11: vmlaunch fails
  FAIL: HOST_SEL_GS 14: vmlaunch fails
  PASS: HOST_SEL_TR 80: vmlaunch succeeds
  FAIL: HOST_SEL_TR 81: vmlaunch fails
  KVM: entry failed, hardware error 0x80000021
