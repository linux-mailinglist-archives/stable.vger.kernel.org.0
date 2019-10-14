Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A0ED61D0
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 13:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbfJNL7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 07:59:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37270 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730846AbfJNL7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 07:59:07 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 646B9771B8439148885A;
        Mon, 14 Oct 2019 19:59:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 14 Oct 2019 19:58:59 +0800
From:   John Garry <john.garry@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <will@kernel.org>, <rjw@rjwysocki.net>,
        <lenb@kernel.org>, <sudeep.holla@arm.com>, <rrichter@marvell.com>,
        <jeremy.linton@arm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linuxarm@huawei.com>, <gregkh@linuxfoundation.org>,
        <guohanjun@huawei.com>, <wanghuiqiang@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH for-stable-5.3 0/3] ACPI, arm64: Backport for ACPI PPTT 6.3 thread flag
Date:   Mon, 14 Oct 2019 19:56:00 +0800
Message-ID: <1571054162-71090-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series is a backport of the ACPI PPTT 6.3 thread flag feature for
supporting arm64 systems.

The background is that some arm64 implementations are broken, in that they
incorrectly advertise that a CPU is mutli-threaded, when it is not - the
HiSilicon Taishanv110 rev 2, aka tsv110, being an example.

This leads to the system topology being incorrect. The reason being that
arm64 topology code uses a combination of ACPI PPTT (Processor Properties
Topology Table) and the system MPIDR (Multiprocessor Affinity Register) MT
bit to determine the topology.

Until ACPI 6.3, the PPTT did not have any method to determine whether
a CPU was multi-threaded, so only the MT bit is used - hence the
broken topology for some systems.

In ACPI 6.3, a PPTT thread flag was introduced, which - when supported -
would be used by the kernel to determine really if a CPU is multi-threaded
or not, so that we don't get incorrect topology.

RFC originally sent for 4.19: https://lkml.org/lkml/2019/10/10/724
Jeremy Linton (2):
  ACPI/PPTT: Add support for ACPI 6.3 thread flag
  arm64: topology: Use PPTT to determine if PE is a thread

 arch/arm64/kernel/topology.c | 19 ++++++++++---
 drivers/acpi/pptt.c          | 52 ++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h         |  5 ++++
 3 files changed, 72 insertions(+), 4 deletions(-)

-- 
2.17.1

