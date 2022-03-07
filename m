Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B014CFA59
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiCGKPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbiCGKKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB0E2BB09;
        Mon,  7 Mar 2022 01:53:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1228260A28;
        Mon,  7 Mar 2022 09:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1048BC340F3;
        Mon,  7 Mar 2022 09:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646762;
        bh=UfCYSZXoVnRIB8H8VvbyXpKv1i03FqE5R0QtrAk+uj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evN6I1iFRADj9+NpO+OD7ewwE73FnQ4c35lbSfesV5JZOi1h00hH2WcsTfFQoHEQK
         NCud95bH5qSfgAUDaZkP8ORapWdIcLxTdHk7H55+RwIfJFBI/vQDK1MI4FlkNp9owz
         cX2kvRYWBLQ4xYU58xGpED99PQ6GyMCqacngI1DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 085/186] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server
Date:   Mon,  7 Mar 2022 10:18:43 +0100
Message-Id: <20220307091656.462621250@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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
@@ -1783,7 +1783,8 @@ int smc_conn_create(struct smc_sock *smc
 		    (ini->smcd_version == SMC_V2 ||
 		     lgr->vlan_id == ini->vlan_id) &&
 		    (role == SMC_CLNT || ini->is_smcd ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
+		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
 			/* link group found */
 			ini->first_contact_local = 0;
 			conn->lgr = lgr;


