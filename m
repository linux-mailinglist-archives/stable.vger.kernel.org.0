Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350D3621D5B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 21:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKHUCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 15:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiKHUCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 15:02:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740BE67F50;
        Tue,  8 Nov 2022 12:02:47 -0800 (PST)
Date:   Tue, 08 Nov 2022 20:02:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667937765;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m957AOZ+7PMI2g5Y+f/g1wqY8SUIj2ZsgN/I1eKfwXQ=;
        b=um3sksbWXHoJWNzO5Daa81xllF9fasZRzia2DOk4unBQLZfKahorHCk58KRrHGKvu/6icQ
        FAOPfJebZTrn7Dd1lJs+ODz2UmqM8hH553rX8j13SrUrArgNnpseBepurE4Fg599m7uRgl
        Svdh/d7Y8C7IGE1g0ZQIYZ/VcYmpIzzWjHLbc/aaCOYuFik1r0mcv5C31yNXikVsozP8Jv
        OEs7TulGj8LG6apLvVtKP8+jHCXYX/gzCX/MhWny1Uc9N38TMFUCBcOVaSxeF9mKYHLBHC
        BDsoMgRweIJY01b6Lwsic6gx+s1Xz310sJp24TYPLzzvtMbgHUGYdZD0IY8Q/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667937765;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m957AOZ+7PMI2g5Y+f/g1wqY8SUIj2ZsgN/I1eKfwXQ=;
        b=Z0T8LI2LLBegBX93t7VPAeh8mmaBSJpZTreLIVLvRoG18gD5SmP4SXT/EDiB4rxG6jRpFQ
        SK2gEb8U8chZShAA==
From:   tip-bot2 for Borys =?utf-8?q?Pop=C5=82awski?= 
        <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sgx: Add overflow check in sgx_validate_offset_length()
Cc:     borysp@invisiblethingslab.com, Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v5.11+@tip-bot2.tec.linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com>
References: <0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com>
MIME-Version: 1.0
Message-ID: <166793776319.4906.4394830802759229298.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     f0861f49bd946ff94fce4f82509c45e167f63690
Gitweb:        https://git.kernel.org/tip/f0861f49bd946ff94fce4f82509c45e167f=
63690
Author:        Borys Pop=C5=82awski <borysp@invisiblethingslab.com>
AuthorDate:    Wed, 05 Oct 2022 00:59:03 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 08 Nov 2022 20:34:05 +01:00

x86/sgx: Add overflow check in sgx_validate_offset_length()

sgx_validate_offset_length() function verifies "offset" and "length"
arguments provided by userspace, but was missing an overflow check on
their addition. Add it.

Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Signed-off-by: Borys Pop=C5=82awski <borysp@invisiblethingslab.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisibl=
ethingslab.com
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ebe79d6..da8b8ea 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -356,6 +356,9 @@ static int sgx_validate_offset_length(struct sgx_encl *en=
cl,
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
=20
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >=3D encl->size)
 		return -EINVAL;
=20
