Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1119A635874
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbiKWJ5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiKWJ4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:56:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAEC116AB6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57AFC61B6F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336EDC433D6;
        Wed, 23 Nov 2022 09:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197097;
        bh=bkh8KexJ7FMiW24TXYuGzo2amSjnSY0TnQyHfUNygik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSZzVfveMHOTqobgAXVtOmMPOrbh5V8HKnW/sGPl6B/TqpLyazflPGt8owIzI6IWe
         GMtXXco3/EihYSstXoVSevgTnNHGTCa1U8XgJNpUpSCIka8QdU3KXMJE+m5a5SNc8R
         G0roSfpNcjdpw6Z+8ag9uKyA7noEOAYNE9BcvOhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, mark.rutland@arm.com,
        Wang Wensheng <wangwensheng4@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 197/314] ftrace: Optimize the allocation for mcount entries
Date:   Wed, 23 Nov 2022 09:50:42 +0100
Message-Id: <20221123084634.474911613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Wang Wensheng <wangwensheng4@huawei.com>

commit bcea02b096333dc74af987cb9685a4dbdd820840 upstream.

If we can't allocate this size, try something smaller with half of the
size. Its order should be decreased by one instead of divided by two.

Link: https://lkml.kernel.org/r/20221109094434.84046-3-wangwensheng4@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: a79008755497d ("ftrace: Allocate the mcount record pages as groups")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3193,7 +3193,7 @@ static int ftrace_allocate_records(struc
 		/* if we can't allocate this size, try something smaller */
 		if (!order)
 			return -ENOMEM;
-		order >>= 1;
+		order--;
 		goto again;
 	}
 


