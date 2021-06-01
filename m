Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B867397224
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 13:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhFALOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 07:14:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6112 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhFALOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 07:14:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvTw31zfwzYmbf;
        Tue,  1 Jun 2021 19:10:11 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 19:12:54 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 19:12:54 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <maz@kernel.org>, <alexandru.elisei@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: [PATCH stable-5.12.y backport 0/2] KVM: arm64: Commit exception state on exit to userspace
Date:   Tue, 1 Jun 2021 19:12:36 +0800
Message-ID: <20210601111238.1059-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As promised on the list [0], this series aims to backport 3 upstream
commits [1,2,3] into 5.12-stable tree.

Patch #1 is already in the queue and therefore not included. Patch #2 can
be applied now by manually adding the __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc
macro (please review). Patch #3 can be applied cleanly then (after #2).

I've slightly tested it on my 920 (boot test and the whole kvm-unit-tests),
on top of the latest linux-stable-rc/linux-5.12.y. Please consider taking
them for 5.12-stable.

[0] https://lore.kernel.org/r/0d9f123c-e9f7-7481-143d-efd488873082@huawei.com
[1] https://git.kernel.org/torvalds/c/f5e30680616a
[2] https://git.kernel.org/torvalds/c/26778aaa134a
[3] https://git.kernel.org/torvalds/c/e3e880bb1518

Marc Zyngier (1):
  KVM: arm64: Commit pending PC adjustemnts before returning to
    userspace

Zenghui Yu (1):
  KVM: arm64: Resolve all pending PC updates before immediate exit

 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/arm.c               | 20 +++++++++++++++++---
 arch/arm64/kvm/hyp/exception.c     |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
 4 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.19.1

