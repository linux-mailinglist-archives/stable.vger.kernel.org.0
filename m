Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9FB234ED
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389862AbfETMbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390461AbfETMbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:31:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EE8C20815;
        Mon, 20 May 2019 12:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355508;
        bh=fkRdBE7+wJgGRTAv29egV76taB++1geA7te/ppBXoiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHhAAF7Bff6Ck7wAPCTLVLo47hjHAt0nbk1cmw14FO6EdryXUR3LT1gAab3zeGwIT
         YqEyfeAjh4AmOgKgHrnZZz25APJJyy8nKinW7dMU5LUwO4yu4WinW7h4uiTPZlm58m
         SszIhSyksSrPbb3oUK1ousDXi9ii1c6rGHvbW25k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "clemej@gmail.com" <clemej@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Pu Wen <puwen@hygon.cn>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        Shirish S <Shirish.S@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        x86-ml <x86@kernel.org>
Subject: [PATCH 5.1 021/128] x86/MCE: Add an MCE-record filtering function
Date:   Mon, 20 May 2019 14:13:28 +0200
Message-Id: <20190520115250.956333908@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 45d4b7b9cb88526f6d5bd4c03efab88d75d10e4f upstream.

Some systems may report spurious MCA errors. In general, spurious MCA
errors may be disabled by clearing a particular bit in MCA_CTL. However,
clearing a bit in MCA_CTL may not be recommended for some errors, so the
only option is to ignore them.

An MCA error is printed and handled after it has been added to the MCE
event pool. So an MCA error can be ignored by not adding it to that pool
in the first place.

Add such a filtering function.

 [ bp: Move function prototype to the internal header and massage. ]

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "clemej@gmail.com" <clemej@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: "rafal@milecki.pl" <rafal@milecki.pl>
Cc: Shirish S <Shirish.S@amd.com>
Cc: <stable@vger.kernel.org> # 5.0.x
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190325163410.171021-1-Yazen.Ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/core.c     |    5 +++++
 arch/x86/kernel/cpu/mce/genpool.c  |    3 +++
 arch/x86/kernel/cpu/mce/internal.h |    3 +++
 3 files changed, 11 insertions(+)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1771,6 +1771,11 @@ static void __mcheck_cpu_init_timer(void
 	mce_start_timer(t);
 }
 
+bool filter_mce(struct mce *m)
+{
+	return false;
+}
+
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 {
--- a/arch/x86/kernel/cpu/mce/genpool.c
+++ b/arch/x86/kernel/cpu/mce/genpool.c
@@ -99,6 +99,9 @@ int mce_gen_pool_add(struct mce *mce)
 {
 	struct mce_evt_llist *node;
 
+	if (filter_mce(mce))
+		return -EINVAL;
+
 	if (!mce_evt_pool)
 		return -EINVAL;
 
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -173,4 +173,7 @@ struct mca_msr_regs {
 
 extern struct mca_msr_regs msr_ops;
 
+/* Decide whether to add MCE record to MCE event pool or filter it out. */
+extern bool filter_mce(struct mce *m);
+
 #endif /* __X86_MCE_INTERNAL_H__ */


