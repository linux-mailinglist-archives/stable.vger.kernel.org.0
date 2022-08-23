Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD89059D661
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241275AbiHWImp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiHWIlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:41:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461777A752;
        Tue, 23 Aug 2022 01:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 872ACCE1B37;
        Tue, 23 Aug 2022 08:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869E9C433D6;
        Tue, 23 Aug 2022 08:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242740;
        bh=25cqBIIziV/XcfFoMUqaT4vBZAn3Vln87Mt8tEYrRsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEVzZGKrOC1fPL1DJfZlhp58rgpZFnnrNsJZ0Qvm7ZtoZ8ojmaasTzKqqMonTl4/C
         oA9fZcqUTBRuiv3aRJflHFHeCgxTpwNXogXO99vxXPbhzfMCX6nGHoqbyQKq4LDIHK
         5VjubVuEhvgY7RTTkYbolULgs9kK3VNfKBTKOB98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Gorenko <sergeygo@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.19 185/365] IB/iser: Fix login with authentication
Date:   Tue, 23 Aug 2022 10:01:26 +0200
Message-Id: <20220823080125.955814036@linuxfoundation.org>
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

From: Sergey Gorenko <sergeygo@nvidia.com>

commit d6d142cb7f79bec6051c5ecf744b7a5309c5a0ee upstream.

The iSER Initiator uses two types of receive buffers:

  - one big login buffer posted by iser_post_recvl();
  - several small message buffers posted by iser_post_recvm().

The login buffer is used at the login phase and full feature phase in
the discovery session. It may take a few requests and responses to
complete the login phase. The message buffers are only used in the
normal operational session at the full feature phase.

After the commit referred in the fixes line, the login operation fails
if the authentication is enabled. That happens because the Initiator
posts a small receive buffer after the first response from Target. So,
the next send operation fails because Target's second response does not
fit into the small receive buffer.

This commit adds additional checks to prevent posting small receive
buffers until the full feature phase.

Fixes: 39b169ea0d36 ("IB/iser: Fix RNR errors")
Link: https://lore.kernel.org/r/20220805060135.18493-1-sergeygo@nvidia.com
Signed-off-by: Sergey Gorenko <sergeygo@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -537,6 +537,7 @@ void iser_login_rsp(struct ib_cq *cq, st
 	struct iscsi_hdr *hdr;
 	char *data;
 	int length;
+	bool full_feature_phase;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		iser_err_comp(wc, "login_rsp");
@@ -550,6 +551,9 @@ void iser_login_rsp(struct ib_cq *cq, st
 	hdr = desc->rsp + sizeof(struct iser_ctrl);
 	data = desc->rsp + ISER_HEADERS_LEN;
 	length = wc->byte_len - ISER_HEADERS_LEN;
+	full_feature_phase = ((hdr->flags & ISCSI_FULL_FEATURE_PHASE) ==
+			      ISCSI_FULL_FEATURE_PHASE) &&
+			     (hdr->flags & ISCSI_FLAG_CMD_FINAL);
 
 	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
 		 hdr->itt, length);
@@ -560,7 +564,8 @@ void iser_login_rsp(struct ib_cq *cq, st
 				      desc->rsp_dma, ISER_RX_LOGIN_SIZE,
 				      DMA_FROM_DEVICE);
 
-	if (iser_conn->iscsi_conn->session->discovery_sess)
+	if (!full_feature_phase ||
+	    iser_conn->iscsi_conn->session->discovery_sess)
 		return;
 
 	/* Post the first RX buffer that is skipped in iser_post_rx_bufs() */


