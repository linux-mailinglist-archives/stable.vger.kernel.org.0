Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE13518593
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiECNh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiECNh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:37:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB533388F
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08B1C6176E
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D21FC385A9;
        Tue,  3 May 2022 13:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651584865;
        bh=IYEKYAPhIdA9xmaBUmxbqEZaUVlHvQCkmOTiYqGXsSw=;
        h=Subject:To:Cc:From:Date:From;
        b=eBxoIPB4l10tP0sP+pM75Q2396m2wt9mIr8YdgEtMiRQT+557FKKuUL+Xa3HXrESf
         AQpxDpWXPSqQ/FVyUaFL96Jao3NgmMDIadThtTfJ37CPuBST9S3zSjF5YMCVzn534T
         kxt2xhXT0VSUZxDHEjGZnb2VTElO11T7K0wyS9q4=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix wrong DLCI release order" failed to apply to 4.9-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 15:34:22 +0200
Message-ID: <165158486216126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From deefc58bafb4841df7f0a0d85d89a1c819db9743 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:14 -0700
Subject: [PATCH] tty: n_gsm: fix wrong DLCI release order

The current DLCI release order starts with the control channel followed by
the user channels. Reverse this order to keep the control channel open
until all user channels have been released.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-9-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index cc90b03ce005..6b953dfbb155 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2146,8 +2146,8 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	/* Finish outstanding timers, making sure they are done */
 	del_timer_sync(&gsm->t2_timer);
 
-	/* Free up any link layer users */
-	for (i = 0; i < NUM_DLCI; i++)
+	/* Free up any link layer users and finally the control channel */
+	for (i = NUM_DLCI - 1; i >= 0; i--)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
 	mutex_unlock(&gsm->mutex);

