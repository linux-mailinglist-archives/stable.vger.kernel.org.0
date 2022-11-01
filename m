Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0961A615176
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 19:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiKASWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 14:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiKASWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 14:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687F215FEF;
        Tue,  1 Nov 2022 11:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0561F616FF;
        Tue,  1 Nov 2022 18:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84058C433C1;
        Tue,  1 Nov 2022 18:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667326960;
        bh=U3tL523QtKI2IYpopdarI0iX5eNFldaGyHhkDQX0mcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekCRXNAYBdWAzV+2TrxuK/HNlHn9Zt4yKT+Fao+l3mi6BbuUO7OgqqWNI9HJTmbg1
         3tzGZx5Vp/7iC+YisofYEun7RkE3uftH6nLiQ0+B8LT6n9yX08niVn7yAxRZl8xgXm
         st0mBRY5KJXd+vB0ksfpN5xpxIUJbFhG9TNR4Zcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.263
Date:   Tue,  1 Nov 2022 19:23:25 +0100
Message-Id: <166732697796238@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166732697773123@kroah.com>
References: <166732697773123@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 08c9d316e5c2..8a517dd456f4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 262
+SUBLEVEL = 263
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/include/linux/once.h b/include/linux/once.h
index bb58e1c3aa03..3a6671d961b9 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -64,7 +64,7 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE_SLOW(func, ...)						     \
 	({								     \
 		bool ___ret = false;					     \
-		static bool __section(".data.once") ___done = false;	     \
+		static bool __section(.data.once) ___done = false;	     \
 		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
 		if (static_branch_unlikely(&___once_key)) {		     \
 			___ret = __do_once_slow_start(&___done);	     \
