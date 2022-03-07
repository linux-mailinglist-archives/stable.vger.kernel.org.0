Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBBE4D05EC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiCGSF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 13:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiCGSF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 13:05:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918F7667A;
        Mon,  7 Mar 2022 10:04:31 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227GoOOg028756;
        Mon, 7 Mar 2022 18:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=VaZ2XNfWa+sxnZt8BlXloidMA1oZxGb7o2hFwBgpKUc=;
 b=F9zpUBG1zFyDC6RjeUbG8ng0dfsP8L/8kxhBPtuZSy6Btk/LNS6LVWFxZC3SnSpMM33b
 iKBdXDRG197LOOfrGSo0NNG/9kqjVk95OShzgVbwmUAGLfCfhjuiE7qtbFNF40w9JA2w
 ZyPJZBY3cy2T0qnr9Dr8gms6uVkM0pJsqNUqtRXdWKulKS3p923XgwUlJTXHk8R2idT6
 ylOVUngMVyjohinXM/75KcWZL/3kjpTNBzYNshPNgvfhurYdk3StdPOznj+W/hkRJLop
 XZ2/B3gEQVPNg/x8bDg9eD14pLS5LqnSIpw01qo7pPZJxa8O+4BF89+L5iK4ECO9Urlj dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfscm7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 18:03:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227Hj8Gj132509;
        Mon, 7 Mar 2022 18:03:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ekyp1c1g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 18:03:55 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 227I3skO178106;
        Mon, 7 Mar 2022 18:03:54 GMT
Received: from localhost (dhcp-10-154-98-43.vpn.oracle.com [10.154.98.43])
        by aserp3020.oracle.com with ESMTP id 3ekyp1c1fn-1;
        Mon, 07 Mar 2022 18:03:54 +0000
Received: by localhost (Postfix, from userid 1000)
        id 75DF3BD0049; Mon,  7 Mar 2022 12:03:52 -0600 (CST)
From:   Alex Thorlton <alex.thorlton@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Alex Thorlton <alex.thorlton@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/paravirt: Apply paravirt instructions in consistent order during boot/module load
Date:   Mon,  7 Mar 2022 12:03:38 -0600
Message-Id: <20220307180338.7608-1-alex.thorlton@oracle.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: vZ0joBF1F-hkBOpzxKQljlYQ0FcJewlK
X-Proofpoint-ORIG-GUID: vZ0joBF1F-hkBOpzxKQljlYQ0FcJewlK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 4e6292114c74 ("x86/paravirt: Add new features for paravirt
patching") changed the order in which altinstructions and paravirt
instructions are patched at boot time.  However, no analogous change was
made in module_finalize, where we apply altinstructions and
parainstructions during module load.

As a result, any code that generates "stacked up" altinstructions and
parainstructions (i.e. local_irq_save/restore) will produce different
results when used in built-in kernel code vs. kernel modules.  This also
makes it possible to inadvertently replace altinstructions in the booted
kernel with their parainstruction counterparts when using
livepatch/kpatch.

To fix this, re-order the processing in module_finalize, so that we do
things in this order:

 1. apply_paravirt
 2. apply_retpolines
 3. apply_alternatives
 4. alternatives_smp_module_add

This is the same ordering that is used at boot time in
alternative_instructions.

Fixes: 4e6292114c74 ("x86/paravirt: Add new features for paravirt patchin=
g")
Signed-off-by: Alex Thorlton <alex.thorlton@oracle.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 5.13+
---
 arch/x86/kernel/module.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 95fa745e310a5..4edc9c87ad0bc 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -273,6 +273,10 @@ int module_finalize(const Elf_Ehdr *hdr,
 			retpolines =3D s;
 	}
=20
+	if (para) {
+		void *pseg =3D (void *)para->sh_addr;
+		apply_paravirt(pseg, pseg + para->sh_size);
+	}
 	if (retpolines) {
 		void *rseg =3D (void *)retpolines->sh_addr;
 		apply_retpolines(rseg, rseg + retpolines->sh_size);
@@ -290,11 +294,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 					    tseg, tseg + text->sh_size);
 	}
=20
-	if (para) {
-		void *pseg =3D (void *)para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-
 	/* make jump label nops */
 	jump_label_apply_nops(me);
=20
--=20
2.33.1

