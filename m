Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09792451468
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349219AbhKOUF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344355AbhKOTYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3F563663;
        Mon, 15 Nov 2021 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002582;
        bh=MWEt8njDj2KMAbvYCho8AJeqLwWCgG28hhha+AQLu2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sL5S1rsHywjrpjd4YeP3soW0g4xGBqB1KMc30zBfVEGbdRVmOA5VIyr5PScyVBpBR
         o/eHzPeD3LNXixRBMIPf/NlHhm9GnknwFMO5cP1UDfO8sCFvkePiBp3HGrsz6sWS3U
         DUNEGpdFhanluxF5spFoxgE1DurHmbsKoB91Fmo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 621/917] powerpc: fix unbalanced node refcount in check_kvm_guest()
Date:   Mon, 15 Nov 2021 18:01:56 +0100
Message-Id: <20211115165449.853472793@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 56537faf8821e361d739fc5ff58c9c40f54a1d4c ]

When check_kvm_guest() succeeds in looking up a /hypervisor OF node, it
returns without performing a matching put for the lookup, leaving the
node's reference count elevated.

Add the necessary call to of_node_put(), rearranging the code slightly to
avoid repetition or goto.

Fixes: 107c55005fbd ("powerpc/pseries: Add KVM guest doorbell restrictions")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210928124550.132020-1-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/firmware.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index c7022c41cc314..20328f72f9f2b 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -31,11 +31,10 @@ int __init check_kvm_guest(void)
 	if (!hyper_node)
 		return 0;
 
-	if (!of_device_is_compatible(hyper_node, "linux,kvm"))
-		return 0;
-
-	static_branch_enable(&kvm_guest);
+	if (of_device_is_compatible(hyper_node, "linux,kvm"))
+		static_branch_enable(&kvm_guest);
 
+	of_node_put(hyper_node);
 	return 0;
 }
 core_initcall(check_kvm_guest); // before kvm_guest_init()
-- 
2.33.0



