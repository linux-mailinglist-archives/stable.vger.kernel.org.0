Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C91FB712
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbgFPPnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731807AbgFPPnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8216E208D5;
        Tue, 16 Jun 2020 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322211;
        bh=him64+DPIChEX82ZwANJeJdiaQwo04Fo1rdBgwYSfcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJYjg66j7J5arRzP/BCzPRQ2IoETgJb5ktnLHz40lU3tdYxw5uAqB4QSa6a6hZtOc
         Y4IoZ8ZkTUlo1/ziWEBGD6crjWwlpnIHZiyI8PP3l6OW4RzZ8cHYZYmKmi58oc4l2c
         t8b615UckBfWQ8ZFg3gc6wCKruV4ziEdOHCZItVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.7 043/163] perf/x86/intel: Add more available bits for OFFCORE_RESPONSE of Intel Tremont
Date:   Tue, 16 Jun 2020 17:33:37 +0200
Message-Id: <20200616153108.927441902@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 0813c40556fce1eeefb996e020cc5339e0b84137 upstream.

The mask in the extra_regs for Intel Tremont need to be extended to
allow more defined bits.

"Outstanding Requests" (bit 63) is only available on MSR_OFFCORE_RSP0;

Fixes: 6daeb8737f8a ("perf/x86/intel: Add Tremont core PMU support")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200501125442.7030-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -1892,8 +1892,8 @@ static __initconst const u64 tnt_hw_cach
 
 static struct extra_reg intel_tnt_extra_regs[] __read_mostly = {
 	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
-	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffffff9fffull, RSP_0),
-	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xffffff9fffull, RSP_1),
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x800ff0ffffff9fffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xff0ffffff9fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 


