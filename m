Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2885E4C747A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbiB1RpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbiB1Rnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171C9BAF3;
        Mon, 28 Feb 2022 09:35:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99619614CD;
        Mon, 28 Feb 2022 17:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5210C340E7;
        Mon, 28 Feb 2022 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069743;
        bh=W+oyjTCIxWodUCtLNaLKp1/WhBPmLkZ4yWLomJTkxbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1MoFrqmeI/sVDkE2Cl0IFXtRVc/xhO2+qzILeg4n6QTGuxNKlS8y7sKeLSe58QEN
         njAGe1Rv3UkrRhtnvAfxOeM8eSZOPFs9Umhtmu53pTY9XzwlAuTW2xlconsjBwBxFV
         yaAWrY7QRKCYVI9ONcsA6qTxJG5U4hvm4h3f4270=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 76/80] tty: n_gsm: fix NULL pointer access due to DLCI release
Date:   Mon, 28 Feb 2022 18:24:57 +0100
Message-Id: <20220228172320.940705546@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: daniel.starke@siemens.com <daniel.starke@siemens.com>

commit 96b169f05cdcc844b400695184d77e42071d14f2 upstream.

The here fixed commit made the tty hangup asynchronous to avoid a circular
locking warning. I could not reproduce this warning. Furthermore, due to
the asynchronous hangup the function call now gets queued up while the
underlying tty is being freed. Depending on the timing this results in a
NULL pointer access in the global work queue scheduler. To be precise in
process_one_work(). Therefore, the previous commit made the issue worse
which it tried to fix.

This patch fixes this by falling back to the old behavior which uses a
blocking tty hangup call before freeing up the associated tty.

Fixes: 7030082a7415 ("tty: n_gsm: avoid recursive locking with async port hangup")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220218073123.2121-4-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1719,7 +1719,12 @@ static void gsm_dlci_release(struct gsm_
 		gsm_destroy_network(dlci);
 		mutex_unlock(&dlci->mutex);
 
-		tty_hangup(tty);
+		/* We cannot use tty_hangup() because in tty_kref_put() the tty
+		 * driver assumes that the hangup queue is free and reuses it to
+		 * queue release_one_tty() -> NULL pointer panic in
+		 * process_one_work().
+		 */
+		tty_vhangup(tty);
 
 		tty_port_tty_set(&dlci->port, NULL);
 		tty_kref_put(tty);


