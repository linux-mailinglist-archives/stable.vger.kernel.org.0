Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600CDFA3F8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfKMB5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbfKMB5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982C22053B;
        Wed, 13 Nov 2019 01:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610230;
        bh=zyZYw0nM4RFgVaebb4BmvAOIVPjPO6GvSiUzaPlDJ34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1BV8oqWAP3kftW0z88ncgtAs3knJw1fwosIgBm7uws9vIGbqVku1csQ88YtDBDU2
         awhKH6mSuYVC/qJhTiNoHHMhGhwt/sv2JwrUWu2q3o8un1lhyw1sFRgRMhs1+c2pdQ
         NofbLlwn4G9fLH9LEHKqG3twOB/qfx4xHhMNYKfY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 032/115] powerpc/pseries: Fix how we iterate over the DTL entries
Date:   Tue, 12 Nov 2019 20:54:59 -0500
Message-Id: <20191113015622.11592-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 9258227e9dd1da8feddb07ad9702845546a581c9 ]

When CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set, we look up dtl_idx in
the lppaca to determine the number of entries in the buffer. Since
lppaca is in big endian, we need to do an endian conversion before using
this in our calculation to determine the number of entries in the
buffer. Without this, we do not iterate over the existing entries in the
DTL buffer properly.

Fixes: 7c105b63bd98 ("powerpc: Add CONFIG_CPU_LITTLE_ENDIAN kernel config option.")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/dtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index c762689e0eb33..ef6595153642e 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -184,7 +184,7 @@ static void dtl_stop(struct dtl *dtl)
 
 static u64 dtl_current_index(struct dtl *dtl)
 {
-	return lppaca_of(dtl->cpu).dtl_idx;
+	return be64_to_cpu(lppaca_of(dtl->cpu).dtl_idx);
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
-- 
2.20.1

