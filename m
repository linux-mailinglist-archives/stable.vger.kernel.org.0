Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDA34BDCC5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbiBUJia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:38:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351261AbiBUJgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FF62DD40;
        Mon, 21 Feb 2022 01:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40C58CE0E86;
        Mon, 21 Feb 2022 09:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27308C340E9;
        Mon, 21 Feb 2022 09:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434927;
        bh=mzGSdJmD5/dnOJXtGDmHaV67N64Mrzt+4+mNCYQzK/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ5rGSFDhkmGYv6ycbe3nglgJyQS5u7F+uOweZqOhiVriEb7Hc4TMGhkgktg7LCGo
         EkQyqZjIe1GzrNiNCnzFBNLU4OKybKFQKcel/yMrbWnsppHKPZEbPXav1i3fVCLCo3
         RrSOxBNqrMREX4CnZOcyFlJEDbU1/WxVrkApMP7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 179/196] ucounts: In set_cred_ucounts assume new->ucounts is non-NULL
Date:   Mon, 21 Feb 2022 09:50:11 +0100
Message-Id: <20220221084936.939443320@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 99c31f9feda41d0f10d030dc04ba106c93295aa2 upstream.

Any cred that is destined for use by commit_creds must have a non-NULL
cred->ucounts field.  Only curing credential construction is a NULL
cred->ucounts valid.  Only abort_creds, put_cred, and put_cred_rcu
needs to deal with a cred with a NULL ucount.  As set_cred_ucounts is
non of those case don't confuse people by handling something that can
not happen.

Link: https://lkml.kernel.org/r/871r4irzds.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -676,15 +676,14 @@ int set_cred_ucounts(struct cred *new)
 	 * This optimization is needed because alloc_ucounts() uses locks
 	 * for table lookups.
 	 */
-	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
+	if (old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
 		return 0;
 
 	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->euid)))
 		return -EAGAIN;
 
 	new->ucounts = new_ucounts;
-	if (old_ucounts)
-		put_ucounts(old_ucounts);
+	put_ucounts(old_ucounts);
 
 	return 0;
 }


