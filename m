Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3E3C4BFA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbhGLHBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242516AbhGLHAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7F4D611C1;
        Mon, 12 Jul 2021 06:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073045;
        bh=qUmrSzCzwDef4DosGbT/vJixNaSG9wC+PfqjEDmmArg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nennxqIa/+FX9vdDcvJ+vZYtupA74/q9vejBsM/NimwqbHcKwAhDdYqGB1qzl/tz5
         XV9FmUdgYZTASFsog8UxOax4F/d9rbHxr/JPfLO73VImgFYJDvXhM/cCnGJS4Gof52
         lc1o0CMV8RdmmlSVvHXBk+fYlrU7WmcLULi5DBhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.12 107/700] perf/x86/intel: Add more events requires FRONTEND MSR on Sapphire Rapids
Date:   Mon, 12 Jul 2021 08:03:10 +0200
Message-Id: <20210712060939.936734356@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit d18216fafecf2a3a7c2b97086892269d6ab3cd5e upstream.

On Sapphire Rapids, there are two more events 0x40ad and 0x04c2 which
rely on the FRONTEND MSR. If the FRONTEND MSR is not set correctly, the
count value is not correct.

Update intel_spr_extra_regs[] to support them.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1624029174-122219-3-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -280,6 +280,8 @@ static struct extra_reg intel_spr_extra_
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
+	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END
 };
 


