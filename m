Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5F5BCD46
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409875AbfIXQom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409873AbfIXQol (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C6521783;
        Tue, 24 Sep 2019 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343480;
        bh=szCeKCu1HOCfG8Xa5dhnSRI7Vdwm04GAxX3XtKErotk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zf4+BgWA9pk7T5TImcaCy108DnTvGzqEnxHy8Rqp5dIT2hIkNpaczeSxhmPeLdCJE
         FAUwYq6FoKN8F1IIdaeHvgoumeANMB+0CoIXpdYY+2SrQZdthkeaV9VHay3BoboxqZ
         f2JMHAiBcLKRj/FMndMPhH3HDPhdR5Dtm3WdMXKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gustavo Romero <gromero@linux.vnet.ibm.com>,
        "Desnes A . Nunes do Rosario" <desnesn@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 63/87] selftests/powerpc: Retry on host facility unavailable
Date:   Tue, 24 Sep 2019 12:41:19 -0400
Message-Id: <20190924164144.25591-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

