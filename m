Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA443EB895
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhHMPOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241764AbhHMPNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A66FA610EA;
        Fri, 13 Aug 2021 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867573;
        bh=jc3D3ISIm4zf6pUe0gjOoGa/I+ad7JKjF8jb11HloX4=;
        h=From:To:Cc:Subject:Date:From;
        b=mdansC365Fi+39Lwcp/v5BVFRZvfi6NrCvsmgtG+oZs6Wcj9yIhKXLIiSq0Lx5PYL
         RC1kwtfkzCdr1Hd4mIQiLdNM3CXkQvR+A9b9X7jXLF6nxmhUV/YbZ6R70PTReHfTqV
         Rs4nx5ollCFRDz1zaWTGBxCHHldIxFepqU24YdGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/11] 4.19.204-rc1 review
Date:   Fri, 13 Aug 2021 17:07:07 +0200
Message-Id: <20210813150520.072304554@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.204-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.204-rc1
X-KernelTest-Deadline: 2021-08-15T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.204 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.204-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.204-rc1

YueHaibing <yuehaibing@huawei.com>
    net: xilinx_emaclite: Do not print real IOMEM pointer

Miklos Szeredi <mszeredi@redhat.com>
    ovl: prevent private clone if bind mount is not allowed

Pali Rohár <pali@kernel.org>
    ppp: Fix generating ppp unit id when ifname is not specified

Longfang Liu <liulongfang@huawei.com>
    USB:ehci:fix Kunpeng920 ehci hardware problem

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Daniel Borkmann <daniel@iogearbox.net>
    bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage under speculation on mispredicted branches

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not mark insn as seen under speculative path verification

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Inherit expanded/patched seen count from old aux data

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Reject string operand in the histogram expression

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB


-------------

Diffstat:

 Documentation/virtual/kvm/mmu.txt             |  4 +-
 Makefile                                      |  4 +-
 arch/x86/kvm/paging_tmpl.h                    | 14 ++++--
 arch/x86/kvm/svm.c                            |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  5 +-
 drivers/net/ppp/ppp_generic.c                 | 19 ++++++--
 drivers/usb/host/ehci-pci.c                   |  3 ++
 fs/namespace.c                                | 42 +++++++++++------
 kernel/bpf/verifier.c                         | 68 +++++++++++++++++++++++----
 kernel/trace/trace_events_hist.c              | 14 ++++++
 tools/testing/selftests/bpf/test_verifier.c   |  2 +
 11 files changed, 138 insertions(+), 39 deletions(-)


