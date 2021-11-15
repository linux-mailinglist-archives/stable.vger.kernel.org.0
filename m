Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81324524FD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357914AbhKPBqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241194AbhKOSWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CBC632C1;
        Mon, 15 Nov 2021 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998786;
        bh=SBw0YKJ8/cX4kD5Vo0UlxXf4k5APsmZEWybsDj1Rp4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFx/LGDA4ZiWuZune+lTNGA7DgomPCud7k3W9nq0AWwv8JQrx6326GDJ0f1k9nS3P
         hbsiujXMo4rXiMc0d6tCnLK2jdKqDiwCZlINTivlUj5yozeOTlJglRnw36zA10WseO
         AiDiLoRzRTNDF3/B5tfNP1AEllDQUlUvq2ZzVmK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kele Huang <huangkele@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 060/849] ptp: fix error print of ptp_kvm on X86_64 platform
Date:   Mon, 15 Nov 2021 17:52:23 +0100
Message-Id: <20211115165422.059668933@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kele Huang <huangkele@bytedance.com>

[ Upstream commit c2402d43d183b11445aed921e7bebcd47ef222f1 ]

Commit a86ed2cfa13c5 ("ptp: Don't print an error if ptp_kvm is not supported")
fixes the error message print on ARM platform by only concerning about
the case that the error returned from kvm_arch_ptp_init() is not -EOPNOTSUPP.
Although the ARM platform returns -EOPNOTSUPP if ptp_kvm is not supported
while X86_64 platform returns -KVM_EOPNOTSUPP, both error codes share the
same value 95.

Actually kvm_arch_ptp_init() on X86_64 platform can return three kinds of
errors (-KVM_ENOSYS, -KVM_EOPNOTSUPP and -KVM_EFAULT). The problem is that
-KVM_EOPNOTSUPP is masked out and -KVM_EFAULT is ignored among them.
This patch fixes this by returning them to ptp_kvm_init() respectively.

Signed-off-by: Kele Huang <huangkele@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_kvm_x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index d0096cd7096a8..4991054a21350 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -31,10 +31,10 @@ int kvm_arch_ptp_init(void)
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
 			     KVM_CLOCK_PAIRING_WALLCLOCK);
-	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
+	if (ret == -KVM_ENOSYS)
 		return -ENODEV;
 
-	return 0;
+	return ret;
 }
 
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
-- 
2.33.0



