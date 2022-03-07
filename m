Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F74CF5D6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbiCGJbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbiCGJ2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2285AEE7;
        Mon,  7 Mar 2022 01:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9ED361150;
        Mon,  7 Mar 2022 09:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3082C340E9;
        Mon,  7 Mar 2022 09:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645124;
        bh=fWF0zr88aLR5/eYRbmN2pjGVjZ4Y0TtYS7lCtnAOpzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHt3otFs078D0Iu6xiXns1Fc+TUSmRldOOpQEJ8UNo8C86ExjDV/BwCeQ73KdiZTu
         Yv21mjqruBRmOrpNZdPgX+y/2qleKLUGCMR1GrGzAVaW+umEGVlc7ILOyLMjaN82/s
         cQ+Jb/+qeErgOwAQH0uAhVlHggo+8fG+IX60v7FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 28/51] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server
Date:   Mon,  7 Mar 2022 10:19:03 +0100
Message-Id: <20220307091637.792801662@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

commit 4940a1fdf31c39f0806ac831cde333134862030b upstream.

The problem of SMC_CLC_DECL_ERR_REGRMB on the server is very clear.
Based on the fact that whether a new SMC connection can be accepted or
not depends on not only the limit of conn nums, but also the available
entries of rtoken. Since the rtoken release is trigger by peer, while
the conn nums is decrease by local, tons of thing can happen in this
time difference.

This only thing that needs to be mentioned is that now all connection
creations are completely protected by smc_server_lgr_pending lock, it's
enough to check only the available entries in rtokens_used_mask.

Fixes: cd6851f30386 ("smc: remote memory buffers (RMBs)")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -609,7 +609,8 @@ int smc_conn_create(struct smc_sock *smc
 		    !lgr->sync_err &&
 		    lgr->vlan_id == vlan_id &&
 		    (role == SMC_CLNT ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
+		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
 			/* link group found */
 			local_contact = SMC_REUSE_CONTACT;
 			conn->lgr = lgr;


