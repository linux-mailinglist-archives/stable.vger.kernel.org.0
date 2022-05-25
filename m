Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916BD533CEC
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 14:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiEYMqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 08:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiEYMqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 08:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5954E7DE2E;
        Wed, 25 May 2022 05:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95386176A;
        Wed, 25 May 2022 12:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F6EC385B8;
        Wed, 25 May 2022 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653482808;
        bh=wSk3APFXpFh2Q6as0TD8OOfLtsMiTGsUBLyuIMTdVvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6fyNWhNdYiNvwBrFh3f0gtQ+X4/p3yBL0uyFB/Fo5gi/J94uMlzv/Uv5koGHxvQd
         b4Zj2PcPgVI+rZbx60BC3ENLJwQ5JS+Mf6XcqqrJMcBTVzQRizAOGTZ7zVIdSjL80F
         k69S6wBJsCSos88fPndqzH/ye+Srz/Tyvb7ocbB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.43
Date:   Wed, 25 May 2022 14:46:39 +0200
Message-Id: <165348279994222@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1653482798149115@kroah.com>
References: <1653482798149115@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6ad7aabaa7d6..6192e6be49c3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 42
+SUBLEVEL = 43
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 72a259a74b57..e193b710b471 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -436,7 +436,8 @@ struct mptcp_subflow_context {
 		rx_eof : 1,
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
-		stale : 1;	    /* unable to snd/rcv data, do not use for xmit */
+		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
+		valid_csum_seen : 1;        /* at least one csum validated */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9c7deffe7cb6..5ef9013b94c7 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -913,11 +913,14 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		subflow->send_mp_fail = 1;
-		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
+		if (subflow->mp_join || subflow->valid_csum_seen) {
+			subflow->send_mp_fail = 1;
+			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
+		}
 		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
 	}
 
+	subflow->valid_csum_seen = 1;
 	return MAPPING_OK;
 }
 
@@ -1099,6 +1102,18 @@ static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ss
 	}
 }
 
+static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)
+{
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	if (subflow->mp_join)
+		return false;
+	else if (READ_ONCE(msk->csum_enabled))
+		return !subflow->valid_csum_seen;
+	else
+		return !subflow->fully_established;
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -1176,7 +1191,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		return true;
 	}
 
-	if (subflow->mp_join || subflow->fully_established) {
+	if (!subflow_can_fallback(subflow)) {
 		/* fatal protocol error, close the socket.
 		 * subflow_error_report() will introduce the appropriate barriers
 		 */
