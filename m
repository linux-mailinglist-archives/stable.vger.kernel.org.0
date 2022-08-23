Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC65259D44C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbiHWIL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242254AbiHWIK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D482DDD;
        Tue, 23 Aug 2022 01:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A20AB81C22;
        Tue, 23 Aug 2022 08:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B890C433D7;
        Tue, 23 Aug 2022 08:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242093;
        bh=qCWJLLimkWOnuEsGie3QDabtJTu5m+R5KpFDeCyqPBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSPwfftVO8z67GgUd9Tdp2jOe5/cuAwFkVGYGqTdj71m3gm7QHHVTGsU9KOuNbQpi
         fE/HfkSh9bRVf9Bg7P1/D4e4F+Zmb8ZHrmfpWNKJ8FCC1KYIVLEsnC8rtPlt7EcbQZ
         raNgDh1C1iuRjIzTsuvOvA4CL/RWI4Ujixi+kvDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.19 057/365] mptcp, btf: Add struct mptcp_sock definition when CONFIG_MPTCP is disabled
Date:   Tue, 23 Aug 2022 09:59:18 +0200
Message-Id: <20220823080120.567931174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit f1d41f7720c89705c20e4335a807b1c518c2e7be upstream.

The btf_sock_ids array needs struct mptcp_sock BTF ID for the
bpf_skc_to_mptcp_sock helper.

When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
defined and resolve_btfids will complain with:

  [...]
  BTFIDS  vmlinux
  WARN: resolve_btfids: unresolved symbol mptcp_sock
  [...]

Add an empty definition for struct mptcp_sock when CONFIG_MPTCP
is disabled.

Fixes: 3bc253c2e652 ("bpf: Add bpf_skc_to_mptcp_sock_proto")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220802163324.1873044-1-jolsa@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mptcp.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -290,4 +290,8 @@ struct mptcp_sock *bpf_mptcp_sock_from_s
 static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk) { return NULL; }
 #endif
 
+#if !IS_ENABLED(CONFIG_MPTCP)
+struct mptcp_sock { };
+#endif
+
 #endif /* __NET_MPTCP_H */


