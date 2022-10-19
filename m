Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03B1603CF5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiJSIzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiJSIyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8A52B1;
        Wed, 19 Oct 2022 01:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B3AE6182F;
        Wed, 19 Oct 2022 08:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6C5C433C1;
        Wed, 19 Oct 2022 08:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169394;
        bh=U6DIaa+5l2qaU6zxdowNtd6QAph7Rp5mOlckEM155/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqch9o4NRm6KEokI3y4RPgKlEhUJni/LemTje4jW5HrQl9jxbz71xPPHVRKao+Jv7
         WRGXxyPR2I57lGviaNTt7TkokABAWkYo17BUw7a4zUYCY6U29lEcyWOE39GQL61ONR
         3hsOHEWg5CAHbsc3nj9aGEEADMtLCoEvpKHySjJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 259/862] bpf: Only add BTF IDs for socket security hooks when CONFIG_SECURITY_NETWORK is on
Date:   Wed, 19 Oct 2022 10:25:46 +0200
Message-Id: <20221019083301.485339855@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit ef331a8d4c0061ea4d353cd0db1c9b33fd45f0f2 ]

When CONFIG_SECURITY_NETWORK is disabled, there will be build warnings
from resolve_btfids:

  WARN: resolve_btfids: unresolved symbol bpf_lsm_socket_socketpair
  ......
  WARN: resolve_btfids: unresolved symbol bpf_lsm_inet_conn_established

Fixing it by wrapping these BTF ID definitions by CONFIG_SECURITY_NETWORK.

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Fixes: 9113d7e48e91 ("bpf: expose bpf_{g,s}etsockopt to lsm cgroup")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20220901065126.3856297-1-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index fa71d58b7ded..832a0e48a2a1 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -41,17 +41,21 @@ BTF_SET_END(bpf_lsm_hooks)
  */
 BTF_SET_START(bpf_lsm_current_hooks)
 /* operate on freshly allocated sk without any cgroup association */
+#ifdef CONFIG_SECURITY_NETWORK
 BTF_ID(func, bpf_lsm_sk_alloc_security)
 BTF_ID(func, bpf_lsm_sk_free_security)
+#endif
 BTF_SET_END(bpf_lsm_current_hooks)
 
 /* List of LSM hooks that trigger while the socket is properly locked.
  */
 BTF_SET_START(bpf_lsm_locked_sockopt_hooks)
+#ifdef CONFIG_SECURITY_NETWORK
 BTF_ID(func, bpf_lsm_socket_sock_rcv_skb)
 BTF_ID(func, bpf_lsm_sock_graft)
 BTF_ID(func, bpf_lsm_inet_csk_clone)
 BTF_ID(func, bpf_lsm_inet_conn_established)
+#endif
 BTF_SET_END(bpf_lsm_locked_sockopt_hooks)
 
 /* List of LSM hooks that trigger while the socket is _not_ locked,
@@ -59,8 +63,10 @@ BTF_SET_END(bpf_lsm_locked_sockopt_hooks)
  * in the early init phase.
  */
 BTF_SET_START(bpf_lsm_unlocked_sockopt_hooks)
+#ifdef CONFIG_SECURITY_NETWORK
 BTF_ID(func, bpf_lsm_socket_post_create)
 BTF_ID(func, bpf_lsm_socket_socketpair)
+#endif
 BTF_SET_END(bpf_lsm_unlocked_sockopt_hooks)
 
 #ifdef CONFIG_CGROUP_BPF
-- 
2.35.1



