Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5849399
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfFQV1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbfFQV1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:27:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 955E2208E4;
        Mon, 17 Jun 2019 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806851;
        bh=FSFXtZJkL9X7zdl8EW5+2gIrlqAmjxup/ATjnuMEnyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEjzN2LrCXkfVCHwyTgniEHXoKU+d4nQHH8Nnjzlo/FyhP0RrRxApEfVCVUXin6NL
         pGNFrp+waxchbl2ezaGCYVW9h5gDvD0C/KCq6nitKGaT9JJ+sAMVx41tgHuBpe/KTv
         d1vy6kn7ll2EskRcUEMReDdQXIDDEhNjqHX/OnNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4.19 72/75] x86/resctrl: Prevent NULL pointer dereference when local MBM is disabled
Date:   Mon, 17 Jun 2019 23:10:23 +0200
Message-Id: <20190617210756.057833262@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

commit c7563e62a6d720aa3b068e26ddffab5f0df29263 upstream.

Booting with kernel parameter "rdt=cmt,mbmtotal,memlocal,l3cat,mba" and
executing "mount -t resctrl resctrl -o mba_MBps /sys/fs/resctrl" results in
a NULL pointer dereference on systems which do not have local MBM support
enabled..

BUG: kernel NULL pointer dereference, address: 0000000000000020
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 0 PID: 722 Comm: kworker/0:3 Not tainted 5.2.0-0.rc3.git0.1.el7_UNSUPPORTED.x86_64 #2
Workqueue: events mbm_handle_overflow
RIP: 0010:mbm_handle_overflow+0x150/0x2b0

Only enter the bandwith update loop if the system has local MBM enabled.

Fixes: de73f38f7680 ("x86/intel_rdt/mba_sc: Feedback loop to dynamically update mem bandwidth")
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190610171544.13474-1-prarit@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel_rdt_monitor.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -371,6 +371,9 @@ static void update_mba_bw(struct rdtgrou
 	struct list_head *head;
 	struct rdtgroup *entry;
 
+	if (!is_mbm_local_enabled())
+		return;
+
 	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA];
 	closid = rgrp->closid;
 	rmid = rgrp->mon.rmid;


