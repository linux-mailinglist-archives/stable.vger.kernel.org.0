Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5573B689594
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjBCKVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjBCKVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099759EE0F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B71D61EC2
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AE8C433D2;
        Fri,  3 Feb 2023 10:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419636;
        bh=N222DfvXFLwRZy4sMcoaZO7ceWeOYwBt2r1GWUGA3B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkrs1rU5ajJQ7FBepcZpfITennjk/dxwdVecTwvP/TJOg2ZeNa+PLNEVjAlks4J9U
         kh8CfHxztpLg1fiX0vM8rU5HbQ0CilKahp9Nq8fhyCeOZWhgYJCxnmRhOSvajjDMjb
         7sPqH49Q5TrK6m/Gt27LeTE2CSeFGIe6bonJq7TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 68/80] hexagon: Fix function name in die()
Date:   Fri,  3 Feb 2023 11:13:02 +0100
Message-Id: <20230203101018.127373300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 4f0712ccec09c071e221242a2db9a6779a55a949 upstream.

When building ARCH=hexagon defconfig:

arch/hexagon/kernel/traps.c:217:2: error: implicit declaration of
function 'make_dead_task' [-Werror,-Wimplicit-function-declaration]
        make_dead_task(err);
        ^

The function's name is make_task_dead(), change it so there is no more
build error.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-2-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -234,7 +234,7 @@ int die(const char *str, struct pt_regs
 		panic("Fatal exception");
 
 	oops_exit();
-	make_dead_task(err);
+	make_task_dead(err);
 	return 0;
 }
 


