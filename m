Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B800265D1F3
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 12:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbjADL7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 06:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbjADL7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 06:59:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493391EC5E;
        Wed,  4 Jan 2023 03:59:00 -0800 (PST)
Date:   Wed, 04 Jan 2023 11:58:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1672833538;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=+n2ZcuHyYQSIvPOuKhwvmkaHaWyKOGj/JfAklwx+MxU=;
        b=Xbz8Grh+urUwKujbRtQx5LM4M/FBOoc4fw9A5cav8F0RZU5/NOLvMbS+XZhAG8XxqsCTmv
        yEj6lx1A1U9YmrOlDRr152+RG9UpEAm+BeZEuA2Csrp+NnthIHHA5hPQBUz8fi62jn2yMi
        zqjBM6Si57Rs98yuFNdoXA4Tg7uWeB2r3biYG8jU3CF9BxKX3ggl3UpAGRIOo8oJGxYOcb
        RERO6kLlQhVqdUGxunhGGIrx356+N5W23QbNWA6dvBHXZ7XsvR30H2ZbSXKMEatpkSXftD
        nUbVyTNGAqA9n6aVILjyXX5JKZkPZkCvwe3YA8rW0A+KPTcCdNLc7/PhKNA5Lw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1672833538;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=+n2ZcuHyYQSIvPOuKhwvmkaHaWyKOGj/JfAklwx+MxU=;
        b=JAHylUUA7jd66QVeVdn/gYui89nlgS18uubG3jOSVL4goX9RqpNispLQiMeFHrbvDI8RfP
        fVtVzuBEiOxZ/jBQ==
From:   "tip-bot2 for Rodrigo Branco" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/bugs: Flush IBP in ib_prctl_set()
Cc:     Rodrigo Branco <bsdaemon@google.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <167283353750.4906.14334038214138785293.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a664ec9158eeddd75121d39c9a0758016097fa96
Gitweb:        https://git.kernel.org/tip/a664ec9158eeddd75121d39c9a0758016097fa96
Author:        Rodrigo Branco <bsdaemon@google.com>
AuthorDate:    Tue, 03 Jan 2023 14:17:51 -06:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 04 Jan 2023 11:25:32 +01:00

x86/bugs: Flush IBP in ib_prctl_set()

We missed the window between the TIF flag update and the next reschedule.

Signed-off-by: Rodrigo Branco <bsdaemon@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d970ddb..bca0bd8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1981,6 +1981,8 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
+		if (task == current)
+			indirect_branch_prediction_barrier();
 		break;
 	default:
 		return -ERANGE;
