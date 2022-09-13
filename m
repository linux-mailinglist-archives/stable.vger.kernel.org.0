Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949F35B7223
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiIMOt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiIMOtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311B76FA25;
        Tue, 13 Sep 2022 07:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9839BB80F92;
        Tue, 13 Sep 2022 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF0CC433D6;
        Tue, 13 Sep 2022 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078595;
        bh=Myr/K1diHuAlbtpy15kf7/p4zZiJit0fn5QkUHtEsmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOJw9OSM9buA7Gs7jFiQFFxcK+13QnZX8eYsnFjq12HmeANANwp1oo7MI3ekbvZhb
         X4jfb3G4Z3ggWwypfgVX33lk/Xbf5xJoQ0n1AfQlV5MmdNWieDxtdf2Xfv9VyrR1ML
         s+41T00RxoHcAnRxRg/6nUIfxpk4S1GjO510RnN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 001/121] net: wwan: iosm: remove pointless null check
Date:   Tue, 13 Sep 2022 16:03:12 +0200
Message-Id: <20220913140357.388181954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Jakub Kicinski <kuba@kernel.org>

commit dbbc7d04c549a43ad343c69e17b27a57e2102041 upstream.

GCC 12 warns:

drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function ‘ipc_protocol_dl_td_process’:
drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: warning: the comparison will always evaluate as ‘true’ for the address of ‘cb’ will never be NULL [-Waddress]
  406 |         if (!IPC_CB(skb)) {
      |             ^

Indeed the check seems entirely pointless. Hopefully the other
validation checks will catch if the cb is bad, but it can't be
NULL.

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
Link: https://lore.kernel.org/r/20220519004342.2109832-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -372,8 +372,6 @@ bool ipc_protocol_dl_td_prepare(struct i
 struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 					   struct ipc_pipe *pipe)
 {
-	u32 tail =
-		le32_to_cpu(ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr]);
 	struct ipc_protocol_td *p_td;
 	struct sk_buff *skb;
 
@@ -401,14 +399,6 @@ struct sk_buff *ipc_protocol_dl_td_proce
 		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
 		skb = NULL;
 		goto ret;
-	}
-
-	if (!IPC_CB(skb)) {
-		dev_err(ipc_protocol->dev, "pipe# %d, tail: %d skb_cb is NULL",
-			pipe->pipe_nr, tail);
-		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
-		skb = NULL;
-		goto ret;
 	}
 
 	if (p_td->buffer.address != IPC_CB(skb)->mapping) {


