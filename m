Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E2B6356D8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbiKWJhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiKWJhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:37:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6617E10AD1F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:34:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CEBE1CE0E1D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F88FC433C1;
        Wed, 23 Nov 2022 09:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196054;
        bh=ojq5mGZOa0nVsbcCQV/i7xnHYx+OxPlNEmOqDXfXR28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4Bo2r9tkO1U02vCQCZ5DiWbzZtcWOd88UK41DILDOD9k+s2ba6G0noXd8j6MBNZ8
         xsZFqGv+bQdZfILVXXp8Pz3zHCfszlcgm2nN1N4Um5RmuqXGMwHsBN9Z1oTTSz99+i
         lCMagQXukhqh1Cop66MIeYRLV6x2dV9L/8LecFQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, mark.rutland@arm.com,
        Wang Wensheng <wangwensheng4@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 107/181] ftrace: Optimize the allocation for mcount entries
Date:   Wed, 23 Nov 2022 09:51:10 +0100
Message-Id: <20221123084606.953645143@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
@@ -3174,7 +3174,7 @@ static int ftrace_allocate_records(struc
 		/* if we can't allocate this size, try something smaller */
 		if (!order)
 			return -ENOMEM;
-		order >>= 1;
+		order--;
 		goto again;
 	}
 


