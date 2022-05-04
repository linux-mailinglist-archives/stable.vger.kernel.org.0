Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E19F51A668
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354115AbiEDQzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354476AbiEDQy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF964969D;
        Wed,  4 May 2022 09:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3540B8279F;
        Wed,  4 May 2022 16:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6204EC385A4;
        Wed,  4 May 2022 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682976;
        bh=JRE8OAckK6Z2/pZaQdU2BPmNB27yYOJnPnYlHynw71Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRkvf9/F2iISU9yWuPr5OAAi3oBmFaweWKZ/s/CpUjPW2/sGE9Hn0OCbAFuwJaRft
         KyRdRFbkzuLxzfAFuAHdG273HyKrVzNXQk+DxGEx8qkgh4OE9+D1MUhRHhRARSFabO
         MUXHCHnWcn+j2MFMegr9WpJ5G2XKVCR5rI/C47a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.4 79/84] tty: n_gsm: fix missing explicit ldisc flush
Date:   Wed,  4 May 2022 18:45:00 +0200
Message-Id: <20220504152933.753555817@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit 17eac652028501df7ea296b1d9b9c134db262b7d upstream.

In gsm_cleanup_mux() the muxer is closed down and all queues are removed.
However, removing the queues is done without explicit control of the
underlying buffers. Flush those before freeing up our queues to ensure
that all outgoing queues are cleared consistently. Otherwise, a new mux
connection establishment attempt may time out while the underlying tty is
still busy sending out the remaining data from the previous connection.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-10-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2101,6 +2101,7 @@ static void gsm_cleanup_mux(struct gsm_m
 			gsm_dlci_release(gsm->dlci[i]);
 	mutex_unlock(&gsm->mutex);
 	/* Now wipe the queues */
+	tty_ldisc_flush(gsm->tty);
 	list_for_each_entry_safe(txq, ntxq, &gsm->tx_list, list)
 		kfree(txq);
 	INIT_LIST_HEAD(&gsm->tx_list);


