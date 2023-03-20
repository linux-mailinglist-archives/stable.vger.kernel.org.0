Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEFD6C1767
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjCTPNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjCTPNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:13:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41EF2331C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5D7AB80EBE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC80C433EF;
        Mon, 20 Mar 2023 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324887;
        bh=mbUuHXlDvT/eSDrFOBVzEyS8WN6S+LZCX8NNWtU5ONA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPNIY2Y3KD/1N3otq1LJvKADNJo7TElKlO2J51px+lK562+621v9FwWorF9CwzhWw
         fEzf6eZvfPwDrBrc4Qh2lI8xz0yFjbScik0jBbr6I+oKiUZAMTKWHvB7elm1DKafE7
         6knINb1JPKBTcavEs/xDSaW3Y311QW97EFBgyvyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 69/99] mptcp: avoid setting TCP_CLOSE state twice
Date:   Mon, 20 Mar 2023 15:54:47 +0100
Message-Id: <20230320145446.285075938@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 3ba14528684f528566fb7d956bfbfb958b591d86 upstream.

tcp_set_state() is called from tcp_done() already.

There is then no need to first set the state to TCP_CLOSE, then call
tcp_done().

Fixes: d582484726c4 ("mptcp: fix fallback for MP_JOIN subflows")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/362
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -275,7 +275,6 @@ void mptcp_subflow_reset(struct sock *ss
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
-	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&


