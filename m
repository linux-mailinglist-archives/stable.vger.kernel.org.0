Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E1664A3E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbjAJSbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239431AbjAJSaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AC24914F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12CDB61864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129C4C433EF;
        Tue, 10 Jan 2023 18:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375140;
        bh=hel9XestH7ziVC6CN7Na4H9z/nBLtyRiShkyYzpyvf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hR1qDVeJ4Ldz+MHExY0WjG5hVrlz83bjJ59eG0RJst6JwIIAZXT2E4JcswupUx9gZ
         ZeUIhyL3wYypceA1HSUr1oeD7D9UGdNzcVMJjPs1r+kgZWh20MAl+2KQXA8tUD51ss
         mlIP/mljYIgfV66NAlmQY0eDOAUwl5ylqrzRU6C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.15 091/290] perf/core: Call LSM hook after copying perf_event_attr
Date:   Tue, 10 Jan 2023 19:03:03 +0100
Message-Id: <20230110180034.756358061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

commit 0a041ebca4956292cadfb14a63ace3a9c1dcb0a3 upstream.

It passes the attr struct to the security_perf_event_open() but it's
not initialized yet.

Fixes: da97e18458fb ("perf_event: Add support for LSM and SELinux checks")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221220223140.4020470-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12215,12 +12215,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
-	/* Do we allow access to perf_event_open(2) ? */
-	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
+	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
 
-	err = perf_copy_attr(attr_uptr, &attr);
+	/* Do we allow access to perf_event_open(2) ? */
+	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
 	if (err)
 		return err;
 


