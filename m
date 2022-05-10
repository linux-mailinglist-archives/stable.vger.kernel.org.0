Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74D52169D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiEJNQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiEJNQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741573ED13;
        Tue, 10 May 2022 06:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3850D61574;
        Tue, 10 May 2022 13:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4855BC385C2;
        Tue, 10 May 2022 13:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188331;
        bh=JRE8OAckK6Z2/pZaQdU2BPmNB27yYOJnPnYlHynw71Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhjFuPD0LJiz8ipPJInDDSnvRb2fSJHo397HP6DgUFPYohMFCEX8BKZqNJQOLtEzU
         Z6EK4RmMy5ObeAhDy1jQ+7kwJdtoitDvJSXcTFlIs3D7mO/lzVNPufzAny1zoIG/RB
         fYlFLo8RBRSy/KtXlWwLx/Z8vpFtuYmRknzhZIaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 4.9 39/66] tty: n_gsm: fix missing explicit ldisc flush
Date:   Tue, 10 May 2022 15:07:29 +0200
Message-Id: <20220510130730.915130452@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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


