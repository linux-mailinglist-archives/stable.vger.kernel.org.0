Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D634F28BC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbiDEIVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiDEIKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:10:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F756D385;
        Tue,  5 Apr 2022 01:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09D3FB81B16;
        Tue,  5 Apr 2022 08:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1E8C385A0;
        Tue,  5 Apr 2022 08:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145761;
        bh=otEFXiGvC1E/tcTu5TxydBsjeGhkNXXcQ5nD1iAGmUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyYuM5GuueFmpHRlyRzmjNPcvUuyRsxdSzJrGlWj6x1JSZ1a2ZgmbmM+ZFvpObyAW
         W/3e+pDKjTUJ0IyNRCzgFzFzxlBhytwEOrOx8y01IKU+odto2qt7ef3ylrdn97qln7
         7mP90jvBUD5ol3KPYZKoRhUoEHw38IKX4RLu0wWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0521/1126] selftests/bpf: Use "__se_" prefix on architectures without syscall wrapper
Date:   Tue,  5 Apr 2022 09:21:08 +0200
Message-Id: <20220405070422.922227647@linuxfoundation.org>
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

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 046b841ea7c528931e7d2e74d5e668aa6c94c1fc ]

On architectures that don't use a syscall wrapper, sys_* function names
are set as an alias of __se_sys_* functions. Due to this, there is no
BTF associated with sys_* function names. This results in some of the
test progs failing to load. Set the SYS_PREFIX to "__se_" to fix this
issue.

Fixes: 38261f369fb905 ("selftests/bpf: Fix probe_user test failure with clang build kernel")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/013d632aacd3e41290445c0025db6a7055ec6e18.1643973917.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
index 0b78bc9b1b4c..5bb11fe595a4 100644
--- a/tools/testing/selftests/bpf/progs/bpf_misc.h
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -13,7 +13,7 @@
 #define SYS_PREFIX "__arm64_"
 #else
 #define SYSCALL_WRAPPER 0
-#define SYS_PREFIX ""
+#define SYS_PREFIX "__se_"
 #endif
 
 #endif
-- 
2.34.1



