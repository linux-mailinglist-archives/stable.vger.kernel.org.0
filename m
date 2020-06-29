Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B05420DA83
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbgF2T6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387607AbgF2TkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B1132489D;
        Mon, 29 Jun 2020 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444399;
        bh=FATNjAXvx8vrwrvho3+k3jo6fRNhCtd/10INbKd4NGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI9yQrSxzD+QUT6zfU1DF8IKZfFeio3q5raQh4iavfu+IY5rQWhJhqiN/Dl6sZW9V
         znhNGEa4YiF69nA+Qm9EpqwY0GewpkvC1Gz4ouXlFPRnBYE+rwJztSWX1FwudDuQNL
         s+wV18aTXYbAFXtMVB+zQA5oJQC+3UeI2N2/yWv4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/178] x86/resctrl: Fix a NULL vs IS_ERR() static checker warning in rdt_cdp_peer_get()
Date:   Mon, 29 Jun 2020 11:23:42 -0400
Message-Id: <20200629152523.2494198-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cc5277fe66cf3ad68f41f1c539b2ef0d5e432974 ]

The callers don't expect *d_cdp to be set to an error pointer, they only
check for NULL.  This leads to a static checker warning:

  arch/x86/kernel/cpu/resctrl/rdtgroup.c:2648 __init_one_rdt_domain()
  warn: 'd_cdp' could be an error pointer

This would not trigger a bug in this specific case because
__init_one_rdt_domain() calls it with a valid domain that would not have
a negative id and thus not trigger the return of the ERR_PTR(). If this
was a negative domain id then the call to rdt_find_domain() in
domain_add_cpu() would have returned the ERR_PTR() much earlier and the
creation of the domain with an invalid id would have been prevented.

Even though a bug is not triggered currently the right and safe thing to
do is to set the pointer to NULL because that is what can be checked for
when the caller is handling the CDP and non-CDP cases.

Fixes: 52eb74339a62 ("x86/resctrl: Fix rdt_find_domain() return value and checks")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lkml.kernel.org/r/20200602193611.GA190851@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 20856d80dce3b..54b711bc06073 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1027,6 +1027,7 @@ static int rdt_cdp_peer_get(struct rdt_resource *r, struct rdt_domain *d,
 	_d_cdp = rdt_find_domain(_r_cdp, d->id, NULL);
 	if (WARN_ON(IS_ERR_OR_NULL(_d_cdp))) {
 		_r_cdp = NULL;
+		_d_cdp = NULL;
 		ret = -EINVAL;
 	}
 
-- 
2.25.1

