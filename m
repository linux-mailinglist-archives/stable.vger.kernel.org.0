Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE8965BC05
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbjACISW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbjACISD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88EDEB2
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B428B80E58
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973B2C433D2;
        Tue,  3 Jan 2023 08:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733850;
        bh=pcQt+vW2aT7KZ3Obs4fTbKbS5fFF+YhbcdETUQBBgQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+FJhk/nFUmmnciyhK5B7A0wUQMJClPHjPh4RWyS+jXVLiTRnyCn7iTbvCvxxb1OJ
         mI7n+mu4V6jlktwJHLXRpV+CZLPh8daxQxsVGgwY4sChtWNNKEeQsqCnpOojHhgM9X
         64IGwG6dZFA4MMWXD2F4RIKJJLQuS+yzRdcqxBh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 43/63] alpha: fix TIF_NOTIFY_SIGNAL handling
Date:   Tue,  3 Jan 2023 09:14:13 +0100
Message-Id: <20230103081311.175366973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e2c7554cc6d85f95e3c6635f270ec839ab9fe05e ]

it needs to be added to _TIF_WORK_MASK, or we might not reach
do_work_pending() in the first place...

Fixes: 5a9a8897c253a "alpha: add support for TIF_NOTIFY_SIGNAL"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -77,7 +77,7 @@ register struct thread_info *__current_t
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
-				 _TIF_NOTIFY_RESUME)
+				 _TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL)
 
 /* Work to do on any return to userspace.  */
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\


