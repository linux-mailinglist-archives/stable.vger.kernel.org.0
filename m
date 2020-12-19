Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A672DEF8E
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgLSNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbgLSNED (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:04:03 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 33/34] x86/resctrl: Remove unused struct mbm_state::chunks_bw
Date:   Sat, 19 Dec 2020 14:03:30 +0100
Message-Id: <20201219125343.026886172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit abe8f12b44250d02937665033a8b750c1bfeb26e upstream

Nothing reads struct mbm_states's chunks_bw value, its a copy of
chunks. Remove it.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lkml.kernel.org/r/20200708163929.2783-2-james.morse@arm.com
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/internal.h |    2 --
 arch/x86/kernel/cpu/resctrl/monitor.c  |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -276,7 +276,6 @@ struct rftype {
  * struct mbm_state - status for each MBM counter in each domain
  * @chunks:	Total data moved (multiply by rdt_group.mon_scale to get bytes)
  * @prev_msr	Value of IA32_QM_CTR for this RMID last time we read it
- * @chunks_bw	Total local data moved. Used for bandwidth calculation
  * @prev_bw_msr:Value of previous IA32_QM_CTR for bandwidth counting
  * @prev_bw	The most recent bandwidth in MBps
  * @delta_bw	Difference between the current and previous bandwidth
@@ -285,7 +284,6 @@ struct rftype {
 struct mbm_state {
 	u64	chunks;
 	u64	prev_msr;
-	u64	chunks_bw;
 	u64	prev_bw_msr;
 	u32	prev_bw;
 	u32	delta_bw;
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -280,8 +280,7 @@ static void mbm_bw_count(u32 rmid, struc
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
-	m->chunks_bw += chunks;
-	m->chunks = m->chunks_bw;
+	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)


