Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0850764
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfFXKGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730147AbfFXKGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:44 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 501B8208E3;
        Mon, 24 Jun 2019 10:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370803;
        bh=bxey2rwk++jtpJu495cC/IHaS19uDxvBIZR0mgEDZzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhXiPr0zaQTsM2NfiXoCJA2G/NAt4KnePT1Y2QyLYrE6zIFC6QiMQR1Wz61wKGbep
         ARrtJ9u2j6Yh6XB9cE2Qcr8cEeFJ/8kmZKAWq7vRVNWXmQmWLcAPtplZGdLTWw13u2
         u5CGK6M4O6ZfEeOEA24u3iAhM0RhJMst9pitwV64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Avin <hpa@zytor.com>
Subject: [PATCH 4.19 90/90] x86/resctrl: Dont stop walking closids when a locksetup group is found
Date:   Mon, 24 Jun 2019 17:57:20 +0800
Message-Id: <20190624092319.758717564@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 87d3aa28f345bea77c396855fa5d5fec4c24461f upstream.

When a new control group is created __init_one_rdt_domain() walks all
the other closids to calculate the sets of used and unused bits.

If it discovers a pseudo_locksetup group, it breaks out of the loop.  This
means any later closid doesn't get its used bits added to used_b.  These
bits will then get set in unused_b, and added to the new control group's
configuration, even if they were marked as exclusive for a later closid.

When encountering a pseudo_locksetup group, we should continue. This is
because "a resource group enters 'pseudo-locked' mode after the schemata is
written while the resource group is in 'pseudo-locksetup' mode." When we
find a pseudo_locksetup group, its configuration is expected to be
overwritten, we can skip it.

Fixes: dfe9674b04ff6 ("x86/intel_rdt: Enable entering of pseudo-locksetup mode")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H Peter Avin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190603172531.178830-1-james.morse@arm.com
[Dropped comment due to lack of space]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -2379,7 +2379,7 @@ static int rdtgroup_init_alloc(struct rd
 				if (closid_allocated(i) && i != closid) {
 					mode = rdtgroup_mode_by_closid(i);
 					if (mode == RDT_MODE_PSEUDO_LOCKSETUP)
-						break;
+						continue;
 					used_b |= *ctrl;
 					if (mode == RDT_MODE_SHAREABLE)
 						d->new_ctrl |= *ctrl;


