Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA627C99D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgI2MM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06DBB23F2B;
        Tue, 29 Sep 2020 11:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379289;
        bh=40VmAwP/yTt5HZ9+MDjxbKXNx1hzfy9nGDD8SwFa9Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRJk0/91TPZIB5eAXyyrDgt3YcJc9wD0MNUzPbKbBbOmivs3a/MZ0QXbUhSy47KaL
         wFWDjg3Dyw1u0paaZkFJYH5XYe7+KXTtnRbj+lc6nBx9xuNFDFWfGQi+7mSTDWCF14
         vn21XZgNw9IDm6a+Yyx2qbDiZMsfAWcB/Fkkvdl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/388] powerpc/eeh: Only dump stack once if an MMIO loop is detected
Date:   Tue, 29 Sep 2020 12:57:08 +0200
Message-Id: <20200929110015.171352390@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 4e0942c0302b5ad76b228b1a7b8c09f658a1d58a ]

Many drivers don't check for errors when they get a 0xFFs response from an
MMIO load. As a result after an EEH event occurs a driver can get stuck in
a polling loop unless it some kind of internal timeout logic.

Currently EEH tries to detect and report stuck drivers by dumping a stack
trace after eeh_dev_check_failure() is called EEH_MAX_FAILS times on an
already frozen PE. The value of EEH_MAX_FAILS was chosen so that a dump
would occur every few seconds if the driver was spinning in a loop. This
results in a lot of spurious stack traces in the kernel log.

Fix this by limiting it to printing one stack trace for each PE freeze. If
the driver is truely stuck the kernel's hung task detector is better suited
to reporting the probelm anyway.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Sam Bobroff <sbobroff@linux.ibm.com>
Tested-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191016012536.22588-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index bc8a551013be9..c35069294ecfb 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -503,7 +503,7 @@ int eeh_dev_check_failure(struct eeh_dev *edev)
 	rc = 1;
 	if (pe->state & EEH_PE_ISOLATED) {
 		pe->check_count++;
-		if (pe->check_count % EEH_MAX_FAILS == 0) {
+		if (pe->check_count == EEH_MAX_FAILS) {
 			dn = pci_device_to_OF_node(dev);
 			if (dn)
 				location = of_get_property(dn, "ibm,loc-code",
-- 
2.25.1



