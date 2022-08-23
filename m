Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DC659E31A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353428AbiHWKNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353574AbiHWKLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC269CDC;
        Tue, 23 Aug 2022 01:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A646153F;
        Tue, 23 Aug 2022 08:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E98C433D6;
        Tue, 23 Aug 2022 08:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245041;
        bh=lY8Vu6e1a86oTT8LLYHfgkFVDDyf4+IO166QYIoKdS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Am/b8KOjI2gKTCsOy4hiqOBN3oYXCUAFZ/MSc6J68ejPL8mCWII3h3MVWbJhgwQM0
         VdRt9wxepU5P2LG1riDiq6hToigPJv2gXT8Sn1hAlyRy1Wi1XZJV5QjdNmGbdv+yGz
         tiPJ7B07oFFgP1NwLDStOR5srB0Dv4/jji7mJBrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chen Guokai <chenguokai17@mails.ucas.ac.cn>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Liao Chang <liaochang1@huawei.com>,
        Guo Ren <guoren@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/244] csky/kprobe: reclaim insn_slot on kprobe unregistration
Date:   Tue, 23 Aug 2022 10:25:55 +0200
Message-Id: <20220823080105.970987809@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit a2310c74d418deca0f1d749c45f1f43162510f51 ]

On kprobe registration kernel allocate one insn_slot for new kprobe,
but it forget to reclaim the insn_slot on unregistration, leading to a
potential leakage.

Reported-by: Chen Guokai <chenguokai17@mails.ucas.ac.cn>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/kernel/probes/kprobes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/csky/kernel/probes/kprobes.c b/arch/csky/kernel/probes/kprobes.c
index 4045894d9280..584ed9f36290 100644
--- a/arch/csky/kernel/probes/kprobes.c
+++ b/arch/csky/kernel/probes/kprobes.c
@@ -124,6 +124,10 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
+	if (p->ainsn.api.insn) {
+		free_insn_slot(p->ainsn.api.insn, 0);
+		p->ainsn.api.insn = NULL;
+	}
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-- 
2.35.1



