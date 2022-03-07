Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B076B4CF5EE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbiCGJal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiCGJ3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EA4344E0;
        Mon,  7 Mar 2022 01:27:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ED54B810B2;
        Mon,  7 Mar 2022 09:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A25C340E9;
        Mon,  7 Mar 2022 09:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645232;
        bh=37Czy/XIDuF5pub/L9jgRS+Unyz4h5tBEJDYZjBSadc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha/C4SCUE6hfj2dWOc9lrTCMvJMEdVzDyDKMDowJju6szQ9zbbQPzWTov+Bx6TMBG
         /RAXHwFpO9JGcGgeYdSe5drgbKXo6yqZ/Am5OrIaJmkEGfoFFGiS8dykG3eDitY5rX
         RFntxOLYAXWI07Gmt19Y/Kq/cvWyWbdNLWluQ3ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 28/64] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server
Date:   Mon,  7 Mar 2022 10:19:01 +0100
Message-Id: <20220307091639.943993080@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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
@@ -632,7 +632,8 @@ int smc_conn_create(struct smc_sock *smc
 		    !lgr->sync_err &&
 		    lgr->vlan_id == ini->vlan_id &&
 		    (role == SMC_CLNT ||
-		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
+		    (lgr->conns_num < SMC_RMBS_PER_LGR_MAX &&
+		      !bitmap_full(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX)))) {
 			/* link group found */
 			ini->cln_first_contact = SMC_REUSE_CONTACT;
 			conn->lgr = lgr;


