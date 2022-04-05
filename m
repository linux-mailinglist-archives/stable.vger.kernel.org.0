Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14C44F28C9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiDEIWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiDEINp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:13:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F419931B0;
        Tue,  5 Apr 2022 01:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E4DB617C6;
        Tue,  5 Apr 2022 08:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E28FC385A0;
        Tue,  5 Apr 2022 08:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145786;
        bh=qkqtXm8IoOk2/A/R9VmyLP1bMmjh7pxPM40i+Nn14P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXqCDdSszQzeFSYM4u4Kdwp1u909QZBh7RlVf1yYxrxFTIQPbXMe/76UvyuqvpRTI
         bsvQVDeOrBS5VR1pUVjLSmWKA+FJov9wCB8sHQyGblWj1Wej2sn+5UCq33+9AYK3LB
         ukpiZKVswJywKJJ4GEBb+IkFZsyY8In1CPru51hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0529/1126] libbpf: Fix riscv register names
Date:   Tue,  5 Apr 2022 09:21:16 +0200
Message-Id: <20220405070423.158319264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 5c101153bfd67387ba159b7864176217a40757da ]

riscv registers are accessed via struct user_regs_struct, not struct
pt_regs. The program counter member in this struct is called pc, not
epc. The frame pointer is called s0, not fp.

Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-6-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 90f56b0f585f..e1b505606882 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -206,10 +206,10 @@
 #define __PT_PARM4_REG a3
 #define __PT_PARM5_REG a4
 #define __PT_RET_REG ra
-#define __PT_FP_REG fp
+#define __PT_FP_REG s0
 #define __PT_RC_REG a5
 #define __PT_SP_REG sp
-#define __PT_IP_REG epc
+#define __PT_IP_REG pc
 
 #endif
 
-- 
2.34.1



