Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453A2565438
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiGDL7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiGDL7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:59:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C150BC37
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B890B80ED9
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F51BC3411E;
        Mon,  4 Jul 2022 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656935971;
        bh=oR5wV7qfIxDOa9YDt6pAJY6xYqduFv8iM06tNS/swlw=;
        h=Subject:To:Cc:From:Date:From;
        b=k3MtnQh0c2ZpDSneHBScwdCXObXqF1eBYF4FuTqeIuEawv3yri6DKmEkJDRJiFKJk
         swo4BdNZt7BLX5P0TMc2XEarwgOE6+rhmSlxpTa4rD75rGIMTggLiUDYsm6s1nYPgX
         yYzWaSkk4YmLZzu4pWN1r9LNjWA/oyS8Let2wiqI=
Subject: FAILED: patch "[PATCH] mptcp: fix error mibs accounting" failed to apply to 5.18-stable tree
To:     pabeni@redhat.com, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:59:29 +0200
Message-ID: <1656935969731@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0c1f78a49af721490a5ad70b73e8b4d382465dae Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 27 Jun 2022 18:02:35 -0700
Subject: [PATCH] mptcp: fix error mibs accounting

The current accounting for MP_FAIL and FASTCLOSE is not very
accurate: both can be increased even when the related option is
not really sent. Move the accounting into the correct place.

Fixes: eb7f33654dc1 ("mptcp: add the mibs for MP_FAIL")
Fixes: 1e75629cb964 ("mptcp: add the mibs for MP_FASTCLOSE")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index be3b918a6d15..2a6351d55a7d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -765,6 +765,7 @@ static noinline bool mptcp_established_options_rst(struct sock *sk, struct sk_bu
 	opts->suboptions |= OPTION_MPTCP_RST;
 	opts->reset_transient = subflow->reset_transient;
 	opts->reset_reason = subflow->reset_reason;
+	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPRSTTX);
 
 	return true;
 }
@@ -788,6 +789,7 @@ static bool mptcp_established_options_fastclose(struct sock *sk,
 	opts->rcvr_key = msk->remote_key;
 
 	pr_debug("FASTCLOSE key=%llu", opts->rcvr_key);
+	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFASTCLOSETX);
 	return true;
 }
 
@@ -809,6 +811,7 @@ static bool mptcp_established_options_mp_fail(struct sock *sk,
 	opts->fail_seq = subflow->map_seq;
 
 	pr_debug("MP_FAIL fail_seq=%llu", opts->fail_seq);
+	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFAILTX);
 
 	return true;
 }
@@ -833,13 +836,11 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 		    mptcp_established_options_mp_fail(sk, &opt_size, remaining, opts)) {
 			*size += opt_size;
 			remaining -= opt_size;
-			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFASTCLOSETX);
 		}
 		/* MP_RST can be used with MP_FASTCLOSE and MP_FAIL if there is room */
 		if (mptcp_established_options_rst(sk, skb, &opt_size, remaining, opts)) {
 			*size += opt_size;
 			remaining -= opt_size;
-			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPRSTTX);
 		}
 		return true;
 	}
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 59a85220edc9..91a62b598de4 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -310,7 +310,6 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 		pr_debug("send MP_FAIL response and infinite map");
 
 		subflow->send_mp_fail = 1;
-		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFAILTX);
 		subflow->send_infinite_map = 1;
 	} else if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_debug("MP_FAIL response received");
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8841e8cd9ad8..50ad19adc003 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -958,10 +958,8 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		if (subflow->mp_join || subflow->valid_csum_seen) {
+		if (subflow->mp_join || subflow->valid_csum_seen)
 			subflow->send_mp_fail = 1;
-			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
-		}
 		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
 	}
 

