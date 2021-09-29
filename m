Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED241BE95
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 07:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244204AbhI2FPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 01:15:31 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55324 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242399AbhI2FPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 01:15:31 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uq-sHgx_1632892429;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0Uq-sHgx_1632892429)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 13:13:49 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 0/2] Fix wild/dangling pointer in x86 ptp_kvm
Date:   Wed, 29 Sep 2021 13:13:47 +0800
Message-Id: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When I was doing PTP_SYS_OFFSET_PRECISE ioctl in VM which has 128 vCPUs,
I got error returned occasionally. Then I checked the routine of
"getcrosststamp". I found in kvm_arch_ptp_get_crosststamp() of x86,
pvclock vcpu time info was got from hv_clock arrary which has only 64
elements. Hence this ioctl is executed on vCPU > 64, a wild/dangling
pointer will be got, which had casued the error.
To confirm this finding, I wrote a simple PTP_SYS_OFFSET_PRECISE ioctl
test and used "taskset -c n" to run the test, when it was executed on
vCPUs >= 64 it returned error.
This patchset exposes this_cpu_pvti() to get per cpu pvclock vcpu time
info of vCPUs >= 64 insdead of getting them from hv_clock arrary.

Zelin Deng (2):
  x86/kvmclock: Move this_cpu_pvti into kvmclock.h
  ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm

 arch/x86/include/asm/kvmclock.h | 14 ++++++++++++++
 arch/x86/kernel/kvmclock.c      | 13 ++-----------
 drivers/ptp/ptp_kvm_x86.c       |  9 ++-------
 3 files changed, 18 insertions(+), 18 deletions(-)

-- 
1.8.3.1

