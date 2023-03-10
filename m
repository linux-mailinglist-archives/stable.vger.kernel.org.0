Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34B66B48FF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjCJPIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjCJPIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:08:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DC31368BC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479D861A21
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D0C4339C;
        Fri, 10 Mar 2023 15:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460440;
        bh=bNR5ZyNz0Vp5MWpNriy0iF66G2Q6Kr5txrlY6B2O3/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrJIYm2Khqg0XYk4nBv5dUqH+/FBVusWenm7FsifhgHEEK5OzN78v5NRivHrA6wYa
         M96tD9xB5yJt4lkxA5Ud5e0LTvL9qQIfH80FbWqLDvP7+VGnY65lw6Ml/kERE5NmJP
         tEkViivCg6YvQLpLDE9fetoS4i64jjILQVRF4dIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 335/529] s390/kprobes: fix current_kprobe never cleared after kprobes reenter
Date:   Fri, 10 Mar 2023 14:37:58 +0100
Message-Id: <20230310133820.542304744@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit cd57953936f2213dfaccce10d20f396956222c7d upstream.

Recent test_kprobe_missed kprobes kunit test uncovers the following
problem. Once kprobe is triggered from another kprobe (kprobe reenter),
all future kprobes on this cpu are considered as kprobe reenter, thus
pre_handler and post_handler are not being called and kprobes are counted
as "missed".

Commit b9599798f953 ("[S390] kprobes: activation and deactivation")
introduced a simpler scheme for kprobes (de)activation and status
tracking by using push_kprobe/pop_kprobe, which supposed to work for
both initial kprobe entry as well as kprobe reentry and helps to avoid
handling those two cases differently. The problem is that a sequence of
calls in case of kprobes reenter:
push_kprobe() <- NULL (current_kprobe)
push_kprobe() <- kprobe1 (current_kprobe)
pop_kprobe() -> kprobe1 (current_kprobe)
pop_kprobe() -> kprobe1 (current_kprobe)
leaves "kprobe1" as "current_kprobe" on this cpu, instead of setting it
to NULL. In fact push_kprobe/pop_kprobe can only store a single state
(there is just one prev_kprobe in kprobe_ctlblk). Which is a hack but
sufficient, there is no need to have another prev_kprobe just to store
NULL. To make a simple and backportable fix simply reset "prev_kprobe"
when kprobe is poped from this "stack". No need to worry about
"kprobe_status" in this case, because its value is only checked when
current_kprobe != NULL.

Cc: stable@vger.kernel.org
Fixes: b9599798f953 ("[S390] kprobes: activation and deactivation")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/kprobes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -241,6 +241,7 @@ static void pop_kprobe(struct kprobe_ctl
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->prev_kprobe.kp = NULL;
 }
 NOKPROBE_SYMBOL(pop_kprobe);
 


