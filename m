Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C66CD6BF
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfJFRty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731216AbfJFRlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2BFD2053B;
        Sun,  6 Oct 2019 17:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383690;
        bh=szCeKCu1HOCfG8Xa5dhnSRI7Vdwm04GAxX3XtKErotk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TndFLd2zizJspZQXdgdRFSB1nN+obKjjIwBW/yn0MFgPlqm1VTWzUvPndHfFKCush
         11lRu56lFKhdDrHCXBhWGEs3Yvg7UQIXry2mTnnm4moEocXSa0sqeeNGHyND7+8Q3G
         RDILZBoHEU1Ri24sDrybAAplatkdq3Q4cdWF3WLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Desnes A. Nunes do Rosario" <desnesn@linux.ibm.com>,
        Gustavo Romero <gromero@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 059/166] selftests/powerpc: Retry on host facility unavailable
Date:   Sun,  6 Oct 2019 19:20:25 +0200
Message-Id: <20191006171218.126904185@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Romero <gromero@linux.vnet.ibm.com>

[ Upstream commit 6652bf6408895b09d31fd4128a1589a1a0672823 ]

TM test tm-unavailable must take into account aborts due to host aborting
a transactin because of a facility unavailable exception, just like it
already does for aborts on reschedules (TM_CAUSE_KVM_RESCHED).

Reported-by: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
Tested-by: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
Signed-off-by: Gustavo Romero <gromero@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1566341651-19747-1-git-send-email-gromero@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/tm/tm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/tm/tm.h b/tools/testing/selftests/powerpc/tm/tm.h
index 97f9f491c541a..c402464b038fc 100644
--- a/tools/testing/selftests/powerpc/tm/tm.h
+++ b/tools/testing/selftests/powerpc/tm/tm.h
@@ -55,7 +55,8 @@ static inline bool failure_is_unavailable(void)
 static inline bool failure_is_reschedule(void)
 {
 	if ((failure_code() & TM_CAUSE_RESCHED) == TM_CAUSE_RESCHED ||
-	    (failure_code() & TM_CAUSE_KVM_RESCHED) == TM_CAUSE_KVM_RESCHED)
+	    (failure_code() & TM_CAUSE_KVM_RESCHED) == TM_CAUSE_KVM_RESCHED ||
+	    (failure_code() & TM_CAUSE_KVM_FAC_UNAV) == TM_CAUSE_KVM_FAC_UNAV)
 		return true;
 
 	return false;
-- 
2.20.1



