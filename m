Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCEF23FAE0
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgHHXir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgHHXiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4ED20716;
        Sat,  8 Aug 2020 23:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929926;
        bh=BHwwznOHRXqH0/INcL7kGleLn2SPdbjSB+EJBL7s76U=;
        h=From:To:Cc:Subject:Date:From;
        b=PFrysYnySCAsw7G6JaZPiMTkc19x3VZgX+t6WfS0rMKoqxyuACuFYh9m1oQh1FbT+
         zvSdbVsXCatRs53d1LQoZy+ycar282rcav4FmdiA4AnRO2cbzp6DwqXideN8AjTRnA
         Ve+3KB0Pr5TlC0ZFx4FrLuB7ofvZqmOmRQGJwBWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/40] x86/mce/inject: Fix a wrong assignment of i_mce.status
Date:   Sat,  8 Aug 2020 19:38:05 -0400
Message-Id: <20200808233844.3618823-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit 5d7f7d1d5e01c22894dee7c9c9266500478dca99 ]

The original code is a nop as i_mce.status is or'ed with part of itself,
fix it.

Fixes: a1300e505297 ("x86/ras/mce_amd_inj: Trigger deferred and thresholding errors interrupts")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lkml.kernel.org/r/20200611023238.3830-1-zhenzhong.duan@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 1f30117b24ba7..eb2d41c1816d6 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -511,7 +511,7 @@ static void do_inject(void)
 	 */
 	if (inj_type == DFR_INT_INJ) {
 		i_mce.status |= MCI_STATUS_DEFERRED;
-		i_mce.status |= (i_mce.status & ~MCI_STATUS_UC);
+		i_mce.status &= ~MCI_STATUS_UC;
 	}
 
 	/*
-- 
2.25.1

