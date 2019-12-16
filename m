Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495A0121833
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbfLPSAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbfLPSAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:00:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B645C207FF;
        Mon, 16 Dec 2019 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519241;
        bh=eW4+B0zty61phdLibfIAHIR2sQEhGPCdQmYBS6sUS7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLKow97vCWe7NIpdaqvO+scUvLpexjTgjFT72hiGGXeXGEQhi3nvXkCbiTaDYHhkA
         9v+8cySmP+YYB2G99pQRs/BgDjDOSC8RMapHEaCPmgOQhy9Ga1QTlYzeXtNruYPZpO
         OOABPuY91n0YukjqfuOYrDsMUQceaEJuKPdkUkJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 253/267] x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models
Date:   Mon, 16 Dec 2019 18:49:39 +0100
Message-Id: <20191216174916.513541198@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <Shirish.S@amd.com>

[ Upstream commit c95b323dcd3598dd7ef5005d6723c1ba3b801093 ]

MC4_MISC thresholding is not supported on all family 0x15 processors,
hence skip the x86_model check when applying the quirk.

 [ bp: massage commit message. ]

Signed-off-by: Shirish S <shirish.s@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1547106849-3476-2-git-send-email-shirish.s@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 4f3be91f0b0bc..dcc11303885b7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1661,11 +1661,10 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 			mce_flags.overflow_recov = 1;
 
 		/*
-		 * Turn off MC4_MISC thresholding banks on those models since
+		 * Turn off MC4_MISC thresholding banks on all models since
 		 * they're not supported there.
 		 */
-		if (c->x86 == 0x15 &&
-		    (c->x86_model >= 0x10 && c->x86_model <= 0x1f)) {
+		if (c->x86 == 0x15) {
 			int i;
 			u64 hwcr;
 			bool need_toggle;
-- 
2.20.1



