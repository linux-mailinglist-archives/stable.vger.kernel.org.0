Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC34450F501
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbiDZIlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345804AbiDZIjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AD770911;
        Tue, 26 Apr 2022 01:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA40DB81CF9;
        Tue, 26 Apr 2022 08:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342C0C385A0;
        Tue, 26 Apr 2022 08:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961882;
        bh=wa6DKY7ihCAiI4ORJ4Lemo2W/kJEgxqyoapglfQxiiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTIhCndvvQ9lFjQdYDx/ZcDCTWzJZ93lSng+ASgD7p7SwgN/5Oh6e4Lqjsy+Mkhh9
         lTHsT/Y5yjfo+mAp8uKljrTzjGiGK9DyYUxFKXc+kKU2FwK9FefzAvx4gjRIodGec6
         bTogZk3jJD1BRAHOYZgPC8Ny7lld+LbMSauww53o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Max Filippov <jcmvbkbc@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 5.4 45/62] xtensa: patch_text: Fixup last cpu should be master
Date:   Tue, 26 Apr 2022 10:21:25 +0200
Message-Id: <20220426081738.514474363@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
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


