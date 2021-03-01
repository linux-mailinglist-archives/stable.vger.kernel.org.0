Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE49328E85
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbhCATd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241536AbhCAT0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A63665177;
        Mon,  1 Mar 2021 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618466;
        bh=ZxYl6ktqcOjs+mbTKfyHdPzK2plTyuCgvD4A8+rngdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNXzJpR5dl5m+2MrXfss63YItihzAfa5t8MMZmPOg/zWs/I52xmdDALPzuVDoKZNd
         IYXyHH7MS+7U7eOOn2H1t/P25uXKaidHbwcol8igaGFGqIwz3o9xQ95EwE/lbbBMvR
         YL6DGj03ePdIykHj7GBqO+9G7E1WerXzt2j4Tk70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/663] x86/MSR: Filter MSR writes through X86_IOC_WRMSR_REGS ioctl too
Date:   Mon,  1 Mar 2021 17:05:15 +0100
Message-Id: <20210301161145.048760354@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

[ Upstream commit 02a16aa13574c8526beadfc9ae8cc9b66315fa2d ]

Commit

  a7e1f67ed29f ("x86/msr: Filter MSR writes")

introduced a module parameter to disable writing to the MSR device file
and tainted the kernel upon writing. As MSR registers can be written by
the X86_IOC_WRMSR_REGS ioctl too, the same filtering and tainting should
be applied to the ioctl as well.

 [ bp: Massage commit message and space out statements. ]

Fixes: a7e1f67ed29f ("x86/msr: Filter MSR writes")
Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210127122456.13939-1-misono.tomohiro@jp.fujitsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/msr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c0d4098106589..79f900ffde4c5 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -184,6 +184,13 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 		err = security_locked_down(LOCKDOWN_MSR);
 		if (err)
 			break;
+
+		err = filter_write(regs[1]);
+		if (err)
+			return err;
+
+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+
 		err = wrmsr_safe_regs_on_cpu(cpu, regs);
 		if (err)
 			break;
-- 
2.27.0



