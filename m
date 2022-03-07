Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3C4CF963
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240050AbiCGKEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbiCGKBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7237D6B09C;
        Mon,  7 Mar 2022 01:50:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E3E6066C;
        Mon,  7 Mar 2022 09:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EBC340F4;
        Mon,  7 Mar 2022 09:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646654;
        bh=2N6PMCCEjRAG0HCGUdg+U4i9gnmlB9Vm1Tah9PDMevc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxF+dFfu+uX9GfuioVmVIyyHGU30e8+MGHPGB+qkuiZI8QC758SOkUhnbeyHyQ+Gq
         NbS8L93Rts3xzq0eRxo4m5t0e2SCuCHtJZ8/IISJ4Mih2ZbNNT9HiX4tmwVr7UOfRg
         87DhdS14p5frFvgvDeK2YCQLVOChiLFEb60Ogrrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Etienne Dechamps <etienne@edechamps.fr>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.16 049/186] ucounts: Fix systemd LimitNPROC with private users regression
Date:   Mon,  7 Mar 2022 10:18:07 +0100
Message-Id: <20220307091655.466186753@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 0ac983f512033cb7b5e210c9589768ad25b1e36b upstream.

Long story short recursively enforcing RLIMIT_NPROC when it is not
enforced on the process that creates a new user namespace, causes
currently working code to fail.  There is no reason to enforce
RLIMIT_NPROC recursively when we don't enforce it normally so update
the code to detect this case.

I would like to simply use capable(CAP_SYS_RESOURCE) to detect when
RLIMIT_NPROC is not enforced upon the caller.  Unfortunately because
RLIMIT_NPROC is charged and checked for enforcement based upon the
real uid, using capable() which is euid based is inconsistent with reality.
Come as close as possible to testing for capable(CAP_SYS_RESOURCE) by
testing for when the real uid would match the conditions when
CAP_SYS_RESOURCE would be present if the real uid was the effective
uid.

Reported-by: Etienne Dechamps <etienne@edechamps.fr>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215596
Link: https://lkml.kernel.org/r/e9589141-cfeb-90cd-2d0e-83a62787239a@edechamps.fr
Link: https://lkml.kernel.org/r/87sfs8jmpz.fsf_-_@email.froward.int.ebiederm.org
Cc: stable@vger.kernel.org
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/user_namespace.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -58,6 +58,18 @@ static void set_cred_user_ns(struct cred
 	cred->user_ns = user_ns;
 }
 
+static unsigned long enforced_nproc_rlimit(void)
+{
+	unsigned long limit = RLIM_INFINITY;
+
+	/* Is RLIMIT_NPROC currently enforced? */
+	if (!uid_eq(current_uid(), GLOBAL_ROOT_UID) ||
+	    (current_user_ns() != &init_user_ns))
+		limit = rlimit(RLIMIT_NPROC);
+
+	return limit;
+}
+
 /*
  * Create a new user namespace, deriving the creator from the user in the
  * passed credentials, and replacing that user with the new root user for the
@@ -122,7 +134,7 @@ int create_user_ns(struct cred *new)
 	for (i = 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++) {
 		ns->ucount_max[i] = INT_MAX;
 	}
-	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC));
+	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_NPROC, enforced_nproc_rlimit());
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MSGQUEUE, rlimit(RLIMIT_MSGQUEUE));
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_SIGPENDING, rlimit(RLIMIT_SIGPENDING));
 	set_rlimit_ucount_max(ns, UCOUNT_RLIMIT_MEMLOCK, rlimit(RLIMIT_MEMLOCK));


