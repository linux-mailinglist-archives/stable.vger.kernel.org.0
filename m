Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684A41214AB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbfLPSNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbfLPSNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7991207FF;
        Mon, 16 Dec 2019 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520013;
        bh=XhccZtZRkjxwIxKwlKZElL/mBn9ub7/v1FJHOoH0a2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTTwhHn1a6aDza6+APSlNrTSsaCqebGeCrI07fFdWi3L2owreoCL6Vt3S8t9PvYiE
         HX09MjGbkakB6Rxv9mPpkINRqMUwLdLTTNUxtWw5VjWKIEkVEyA7DzHGRGdeIKNXJ5
         /AhcpZ2bsKYh1XEYqc8U4+ZERzR8SHxSjBk7e0PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>
Subject: [PATCH 5.3 122/180] stm class: Lose the protocol driver when dropping its reference
Date:   Mon, 16 Dec 2019 18:49:22 +0100
Message-Id: <20191216174840.991978315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 0a8f72fafb3f72a08df4ee491fcbeaafd6de85fd upstream.

Commit c7fd62bc69d02 ("stm class: Introduce framing protocol drivers")
forgot to tear down the link between an stm device and its protocol
driver when policy is removed. This leads to an invalid pointer reference
if one tries to write to an stm device after the policy has been removed
and the protocol driver module unloaded, leading to the below splat:

> BUG: unable to handle page fault for address: ffffffffc0737068
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 3d780f067 P4D 3d780f067 PUD 3d7811067 PMD 492781067 PTE 0
> Oops: 0000 [#1] SMP NOPTI
> CPU: 1 PID: 26122 Comm: cat Not tainted 5.4.0-rc5+ #1
> RIP: 0010:stm_output_free+0x40/0xc0 [stm_core]
> Call Trace:
>  stm_char_release+0x3e/0x70 [stm_core]
>  __fput+0xc6/0x260
>  ____fput+0xe/0x10
>  task_work_run+0x9d/0xc0
>  exit_to_usermode_loop+0x103/0x110
>  do_syscall_64+0x19d/0x1e0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by tearing down the link from an stm device to its protocol
driver when the policy involving that driver is removed.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: c7fd62bc69d02 ("stm class: Introduce framing protocol drivers")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
CC: stable@vger.kernel.org # v4.20+
Link: https://lore.kernel.org/r/20191114064201.43089-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/stm/policy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hwtracing/stm/policy.c
+++ b/drivers/hwtracing/stm/policy.c
@@ -345,7 +345,11 @@ void stp_policy_unbind(struct stp_policy
 	stm->policy = NULL;
 	policy->stm = NULL;
 
+	/*
+	 * Drop the reference on the protocol driver and lose the link.
+	 */
 	stm_put_protocol(stm->pdrv);
+	stm->pdrv = NULL;
 	stm_put_device(stm);
 }
 


