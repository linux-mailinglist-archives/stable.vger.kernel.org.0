Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C946E51A807
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349090AbiEDRHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355598AbiEDREb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31A84EF52;
        Wed,  4 May 2022 09:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 659AE61899;
        Wed,  4 May 2022 16:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B658AC385A4;
        Wed,  4 May 2022 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683188;
        bh=NEBsSG0/XWJf6FprfNFMo2p3cGJLwBZ8OJmNqMRtIGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha7h/MMhWT/k7W9LcRI1xrrIvH6XeIepiF6lTTmnCGeoBGsvT3HKYkTYm8uhzJwoi
         Iyafm///AApkf3nnLr62/pCEt/OV1ZqnTXg5owavHZ8FH1v1jhLzE5c6LEA5i2ESDm
         Rjn/SXBXvnGBvCIZci1ANq2XGPQ48JG3toIaD7cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 5.15 041/177] riscv: patch_text: Fixup last cpu should be master
Date:   Wed,  4 May 2022 18:43:54 +0200
Message-Id: <20220504153056.592587620@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 8ec1442953c66a1d8462cccd8c20b7ba561f5915 upstream.

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 043cb41a85de ("riscv: introduce interfaces to patch kernel code")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/patch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -104,7 +104,7 @@ static int patch_text_cb(void *data)
 	struct patch_insn *patch = data;
 	int ret = 0;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		ret =
 		    patch_text_nosync(patch->addr, &patch->insn,
 					    GET_INSN_LENGTH(patch->insn));


