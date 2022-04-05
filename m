Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBCC4F2AD8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiDEJfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiDEI5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:57:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C453322BCE;
        Tue,  5 Apr 2022 01:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37416B81BC5;
        Tue,  5 Apr 2022 08:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7778EC385A1;
        Tue,  5 Apr 2022 08:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148784;
        bh=otEFXiGvC1E/tcTu5TxydBsjeGhkNXXcQ5nD1iAGmUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVqF4MA81Vk7ttfytVWTgqImgjwkeXOU6D/FZRvo6eW1jN6I+HkpyhrqwcXkgZv3n
         AUbnCfvxLpkrGc3jr+URlKk3Xg2R4xHfIiH9KqPYxrA3rW9ClMDk/ySYqnUqwou3YH
         KkyrMB9kikRRFrv3hpg+CEFaorFbDQr7U8JrAApI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0481/1017] selftests/bpf: Use "__se_" prefix on architectures without syscall wrapper
Date:   Tue,  5 Apr 2022 09:23:14 +0200
Message-Id: <20220405070408.576924998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



