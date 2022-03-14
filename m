Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C664D8355
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiCNMNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbiCNMM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:12:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD89635DF9;
        Mon, 14 Mar 2022 05:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F2827CE1268;
        Mon, 14 Mar 2022 12:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B78AC340E9;
        Mon, 14 Mar 2022 12:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259853;
        bh=7qTVnw2yRQESL+5rhUTjec37rFEutZCM+G5pVePxMA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raQfnCQYENY4cVrI29KjXHG/3KzGL6LFqrPu0qGNnx1efCWT3vmG/mvHT2WXCRTX5
         zpuGviHz4SWparX1l6AqF/6PUkaKqeS28kHVm3sbKpvjmP9nHsgMa0XGjzGEtlu7dL
         Z5NosGQuJHx0h0momITckl3z/5I2VlXEbmuczp8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 5.15 104/110] x86/traps: Mark do_int3() NOKPROBE_SYMBOL
Date:   Mon, 14 Mar 2022 12:54:46 +0100
Message-Id: <20220314112745.928908458@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

commit a365a65f9ca1ceb9cf1ac29db4a4f51df7c507ad upstream.

Since kprobe_int3_handler() is called in do_int3(), probing do_int3()
can cause a breakpoint recursion and crash the kernel. Therefore,
do_int3() should be marked as NOKPROBE_SYMBOL.

Fixes: 21e28290b317 ("x86/traps: Split int3 handler up")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220310120915.63349-1-lihuafei1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -659,6 +659,7 @@ static bool do_int3(struct pt_regs *regs
 
 	return res == NOTIFY_STOP;
 }
+NOKPROBE_SYMBOL(do_int3);
 
 static void do_int3_user(struct pt_regs *regs)
 {


