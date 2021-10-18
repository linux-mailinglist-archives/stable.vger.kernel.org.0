Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0DD431E04
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhJRN5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234191AbhJRNzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C10619FA;
        Mon, 18 Oct 2021 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564389;
        bh=Zl0baRCnKsAHiJrz1tKd7AQ0J4hd5iCqHZMVx0C6zQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1Ql0HjkHAKSkDmC2v5M8nodPqOYAVsOm4fEf7U+FqBsDlrzHRvBg3li84gDIFPUC
         aaCGAa7Tq4+JW0BpculG3NQmJjt8LrLdMZMVT2jEp4XIJoEyAHklT+VF1UV3fS5vjO
         aNeZV20DjJ2TkqYNQ7sUPm8EF0nGMGChFskhInIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.14 037/151] x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails
Date:   Mon, 18 Oct 2021 15:23:36 +0200
Message-Id: <20211018132341.898620240@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 64e87d4bd3201bf8a4685083ee4daf5c0d001452 upstream.

domain_add_cpu() is called whenever a CPU is brought online. The
earlier call to domain_setup_ctrlval() allocates the control value
arrays.

If domain_setup_mon_state() fails, the control value arrays are not
freed.

Add the missing kfree() calls.

Fixes: 1bd2a63b4f0de ("x86/intel_rdt/mba_sc: Add initialization support")
Fixes: edf6fa1c4a951 ("x86/intel_rdt/cqm: Add RMID (Resource monitoring ID) management")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210917165958.28313-1-james.morse@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -590,6 +590,8 @@ static void domain_add_cpu(int cpu, stru
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(d->ctrl_val);
+		kfree(d->mbps_val);
 		kfree(d);
 		return;
 	}


