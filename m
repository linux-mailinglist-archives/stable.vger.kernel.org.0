Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18CD5217B6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiEJN2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243667AbiEJN1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:27:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF393239DB6;
        Tue, 10 May 2022 06:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FE8B81CF8;
        Tue, 10 May 2022 13:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9344AC385A6;
        Tue, 10 May 2022 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188814;
        bh=yu9sE/T90FsB+AVfl0at0UisupwhGrSZoDwZSWb/y0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xO1DxS/wzSzvOmnjBbDivZBAbS9+UdD7PysHoxE9CDoPek0REG9Kr5kGGh5A/ILdz
         ANaSCglxN/PtVlpXfAjHsVRxdRHbivlA9g1jWwMebcKTMCIdUoW6Kr6I+vPlvmItx3
         7U4lHwNLMEkwzKLS/RsTabORltt86NCT4Ajo+Pf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 4.19 53/88] tty: n_gsm: fix missing explicit ldisc flush
Date:   Tue, 10 May 2022 15:07:38 +0200
Message-Id: <20220510130735.286583909@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
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
@@ -2099,6 +2099,7 @@ static void gsm_cleanup_mux(struct gsm_m
 			gsm_dlci_release(gsm->dlci[i]);
 	mutex_unlock(&gsm->mutex);
 	/* Now wipe the queues */
+	tty_ldisc_flush(gsm->tty);
 	list_for_each_entry_safe(txq, ntxq, &gsm->tx_list, list)
 		kfree(txq);
 	INIT_LIST_HEAD(&gsm->tx_list);


