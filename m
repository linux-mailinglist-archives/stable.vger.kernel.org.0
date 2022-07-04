Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEA456543B
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiGDMAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiGDMAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:00:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3C4BC37
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00382B80EEC
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF5DC341C7;
        Mon,  4 Jul 2022 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656936007;
        bh=4djG1VYkhZ1OL/u1Hv6jqsm8CQZH3wKbTgsWX4rU0BM=;
        h=Subject:To:Cc:From:Date:From;
        b=veqVLtjh7Qi8hMHNtVgsG+s9YIj3YVcobH84fL38ntVQM7DRUzGgXBPlo0z+m0apE
         DDZhdxggbVKhhgF0/4RQrVCU79TgOLRydrJ9+2AmTHaQQtjBUKnHfQFh3htVNk4S9T
         G2Z3L9WzLF1SXS4G2gzuDdxBBRQGIC2DD2huzVoQ=
Subject: FAILED: patch "[PATCH] mptcp: introduce MAPPING_BAD_CSUM" failed to apply to 5.15-stable tree
To:     pabeni@redhat.com, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 14:00:05 +0200
Message-ID: <1656936005123206@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 31bf11de146c3f8892093ff39f8f9b3069d6a852 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 27 Jun 2022 18:02:36 -0700
Subject: [PATCH] mptcp: introduce MAPPING_BAD_CSUM

This allow moving a couple of conditional out of the fast path,
making the code more easy to follow and will simplify the next
patch.

Fixes: ae66fb2ba6c3 ("mptcp: Do TCP fallback on early DSS checksum failure")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 50ad19adc003..42a7c18a1c24 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -843,7 +843,8 @@ enum mapping_status {
 	MAPPING_INVALID,
 	MAPPING_EMPTY,
 	MAPPING_DATA_FIN,
-	MAPPING_DUMMY
+	MAPPING_DUMMY,
+	MAPPING_BAD_CSUM
 };
 
 static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
@@ -958,9 +959,7 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		if (subflow->mp_join || subflow->valid_csum_seen)
-			subflow->send_mp_fail = 1;
-		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
+		return MAPPING_BAD_CSUM;
 	}
 
 	subflow->valid_csum_seen = 1;
@@ -1182,10 +1181,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 
 		status = get_mapping_status(ssk, msk);
 		trace_subflow_check_data_avail(status, skb_peek(&ssk->sk_receive_queue));
-		if (unlikely(status == MAPPING_INVALID))
-			goto fallback;
-
-		if (unlikely(status == MAPPING_DUMMY))
+		if (unlikely(status == MAPPING_INVALID || status == MAPPING_DUMMY ||
+			     status == MAPPING_BAD_CSUM))
 			goto fallback;
 
 		if (status != MAPPING_OK)
@@ -1227,7 +1224,10 @@ static bool subflow_check_data_avail(struct sock *ssk)
 fallback:
 	if (!__mptcp_check_fallback(msk)) {
 		/* RFC 8684 section 3.7. */
-		if (subflow->send_mp_fail) {
+		if (status == MAPPING_BAD_CSUM &&
+		    (subflow->mp_join || subflow->valid_csum_seen)) {
+			subflow->send_mp_fail = 1;
+
 			if (!READ_ONCE(msk->allow_infinite_fallback)) {
 				ssk->sk_err = EBADMSG;
 				tcp_set_state(ssk, TCP_CLOSE);

