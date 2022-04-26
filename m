Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FCD50F5EA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiDZIyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347684AbiDZIvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005FCD399F;
        Tue, 26 Apr 2022 01:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2617B81CFA;
        Tue, 26 Apr 2022 08:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CEBC385A0;
        Tue, 26 Apr 2022 08:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962445;
        bh=wa6DKY7ihCAiI4ORJ4Lemo2W/kJEgxqyoapglfQxiiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajQpFr4QiCMxUyQLMdVrQtgkaYRX/UQZN2Oz2Yf2e/gC1rkxB4Vcmula6ZgGIponB
         yLf0EI83n0KI2cR6gBE+Bv+hAM9CNztAbkx/5YtxaqFeEUMDwSMfTSXizlRSUDVqWX
         lLKVVuf0JxE47VS+yF9WcNSz7PYrTsocxQUfv2Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Max Filippov <jcmvbkbc@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 5.15 099/124] xtensa: patch_text: Fixup last cpu should be master
Date:   Tue, 26 Apr 2022 10:21:40 +0200
Message-Id: <20220426081750.114127201@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit ee69d4be8fd064cd08270b4808d2dfece3614ee0 upstream.

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Fixes: 64711f9a47d4 ("xtensa: implement jump_label support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Message-Id: <20220407073323.743224-4-guoren@kernel.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/jump_label.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -40,7 +40,7 @@ static int patch_text_stop_machine(void
 {
 	struct patch *patch = data;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		local_patch_text(patch->addr, patch->data, patch->sz);
 		atomic_inc(&patch->cpu_count);
 	} else {


