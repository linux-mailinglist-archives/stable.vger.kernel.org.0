Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CD954871D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbiFMKZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245075AbiFMKYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF453205E8;
        Mon, 13 Jun 2022 03:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E1EC60AE7;
        Mon, 13 Jun 2022 10:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDDAC34114;
        Mon, 13 Jun 2022 10:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115516;
        bh=yBMfBMsenoejD3SJApeyaIR+DRPPPmmkDIHXMUaPI6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp9CVqPx1gTO+K0GusWvdFE0t8gM6wu4C8XTmxcjVbYop/51YJL8df+eFMeNEafOa
         dPt/5+5/7/wOkSp4WBIzH4b3QcDwFrTfU88UofmWQPKqVNAJ8VdIoy82n9qGx6Oi2F
         J0KFEAek5FWBe7nhHol40xWqjQh7M4i6C0+YWv34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 094/167] um: chan_user: Fix winch_tramp() return value
Date:   Mon, 13 Jun 2022 12:09:28 +0200
Message-Id: <20220613094902.980862392@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 57ae0b67b747031bc41fb44643aa5344ab58607e upstream.

The previous fix here was only partially correct, it did
result in returning a proper error value in case of error,
but it also clobbered the pid that we need to return from
this function (not just zero for success).

As a result, it returned 0 here, but later this is treated
as a pid and used to kill the process, but since it's now
0 we kill(0, SIGKILL), which makes UML kill itself rather
than just the helper thread.

Fix that and make it more obvious by using a separate
variable for the pid.

Fixes: ccf1236ecac4 ("um: fix error return code in winch_tramp()")
Reported-and-tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/chan_user.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -220,7 +220,7 @@ static int winch_tramp(int fd, struct tt
 		       unsigned long *stack_out)
 {
 	struct winch_data data;
-	int fds[2], n, err;
+	int fds[2], n, err, pid;
 	char c;
 
 	err = os_pipe(fds, 1, 1);
@@ -238,8 +238,9 @@ static int winch_tramp(int fd, struct tt
 	 * problem with /dev/net/tun, which if held open by this
 	 * thread, prevents the TUN/TAP device from being reused.
 	 */
-	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
-	if (err < 0) {
+	pid = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
+	if (pid < 0) {
+		err = pid;
 		printk(UM_KERN_ERR "fork of winch_thread failed - errno = %d\n",
 		       -err);
 		goto out_close;
@@ -263,7 +264,7 @@ static int winch_tramp(int fd, struct tt
 		goto out_close;
 	}
 
-	return err;
+	return pid;
 
  out_close:
 	close(fds[1]);


