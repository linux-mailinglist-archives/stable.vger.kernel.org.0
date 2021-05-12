Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C4937CDBE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245176AbhELQ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244113AbhELQmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3BE61D03;
        Wed, 12 May 2021 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835849;
        bh=XDVTLmYeupmXBH/ByHRh7rJqMjdBDHPCH0fJ7Ciwhxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAaxExN9j977ExPjHst7wC0YcJzFoP9NhdbJGjtgifCUVx13LZ7/yo8AsQnR745gO
         NHXBl4wdBQZsRTPYIfcMWvqC/h6THQvFSLJuooSBAxpxkVsSld5j4LSDfvE4GEtVA0
         6cx1A5g+0WbK/D/eOPgNFAdNXbVLkFlbfXGHLRqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 509/677] powerpc/perf: Fix PMU constraint check for EBB events
Date:   Wed, 12 May 2021 16:49:15 +0200
Message-Id: <20210512144854.296411888@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 10f8f96179ecc7f69c927f6d231f6d02736cea83 ]

The power PMU group constraints includes check for EBB events to make
sure all events in a group must agree on EBB. This will prevent
scheduling EBB and non-EBB events together. But in the existing check,
settings for constraint mask and value is interchanged. Patch fixes the
same.

Before the patch, PMU selftest "cpu_event_pinned_vs_ebb_test" fails with
below in dmesg logs. This happens because EBB event gets enabled along
with a non-EBB cpu event.

  [35600.453346] cpu_event_pinne[41326]: illegal instruction (4)
  at 10004a18 nip 10004a18 lr 100049f8 code 1 in
  cpu_event_pinned_vs_ebb_test[10000000+10000]

Test results after the patch:

  $ ./pmu/ebb/cpu_event_pinned_vs_ebb_test
  test: cpu_event_pinned_vs_ebb
  tags: git_version:v5.12-rc5-93-gf28c3125acd3-dirty
  Binding to cpu 8
  EBB Handler is at 0x100050c8
  read error on event 0x7fffe6bd4040!
  PM_RUN_INST_CMPL: result 9872 running/enabled 37930432
  success: cpu_event_pinned_vs_ebb

This bug was hidden by other logic until commit 1908dc911792 (perf:
Tweak perf_event_attr::exclusive semantics).

Fixes: 4df489991182 ("powerpc/perf: Add power8 EBB support")
Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
[mpe: Mention commit 1908dc911792]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1617725761-1464-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index e4f577da33d8..8b5eeb6fb2fb 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -447,8 +447,8 @@ ebb_bhrb:
 	 * EBB events are pinned & exclusive, so this should never actually
 	 * hit, but we leave it as a fallback in case.
 	 */
-	mask  |= CNST_EBB_VAL(ebb);
-	value |= CNST_EBB_MASK;
+	mask  |= CNST_EBB_MASK;
+	value |= CNST_EBB_VAL(ebb);
 
 	*maskp = mask;
 	*valp = value;
-- 
2.30.2



