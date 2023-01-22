Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2176E676F0D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjAVPRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjAVPRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:17:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F4222DA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0F6760C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D66FC433EF;
        Sun, 22 Jan 2023 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400629;
        bh=eTjgamK+yx3q1F5he2qH1mGtxQr3KywMO2f6moXsJ94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nD68L9sTfrvRkLw7JGjnk71KyBT+K2ChLJkZ9Z8q/cGwT3Ztk60xMQiJnxJabOUzv
         LzfGXu3ajHUNNBvNGsopW5CSue153dUt6Qg4A9ZijnMnbgJJ7lYilvGQs+AQYtdGOn
         +EClO89TjcW/S5w6odEHU7P69IoTh8uTG7j9F+Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [PATCH 5.15 049/117] prlimit: do_prlimit needs to have a speculation check
Date:   Sun, 22 Jan 2023 16:03:59 +0100
Message-Id: <20230122150234.788511541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 739790605705ddcf18f21782b9c99ad7d53a8c11 upstream.

do_prlimit() adds the user-controlled resource value to a pointer that
will subsequently be dereferenced.  In order to help prevent this
codepath from being used as a spectre "gadget" a barrier needs to be
added after checking the range.

Reported-by: Jordy Zomer <jordyzomer@google.com>
Tested-by: Jordy Zomer <jordyzomer@google.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1575,6 +1575,8 @@ int do_prlimit(struct task_struct *tsk,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;


