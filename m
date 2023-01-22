Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D7F676E1D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjAVPHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjAVPHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:07:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340A51E1C6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2AD3B80B16
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB75C433EF;
        Sun, 22 Jan 2023 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400024;
        bh=y82/TZn/ehNf9mqLC6ZgruS/1Qw+nmsoQqnSZICmtos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFkQitGwqUY1rvHwLgPoDwrzp2RlONtHkfpB8u+DcjonGZiwKsvnkWO1RhsEGhU6e
         q+T8VoI0+5//4rtLnAv8o3rIAmVJiMuXkzdQcNZsuFTfLaWglevP7ob0pgYRatlJBs
         K4gwb10KeMRRS0lVcHLKoXogSj48cWmdBcdhXc8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [PATCH 4.19 11/37] prlimit: do_prlimit needs to have a speculation check
Date:   Sun, 22 Jan 2023 16:04:08 +0100
Message-Id: <20230122150220.046810197@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
@@ -1530,6 +1530,8 @@ int do_prlimit(struct task_struct *tsk,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;


