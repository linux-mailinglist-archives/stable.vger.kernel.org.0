Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8B75185AF
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiECNnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiECNnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1EE2AE25
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4801CB81EAE
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E610BC385A4;
        Tue,  3 May 2022 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585174;
        bh=m3XxN3fF6lbeIMt0Xph+YGqb7JH5QXuEMPK8Qnrj/98=;
        h=Subject:To:Cc:From:Date:From;
        b=wxvvt97d1GS3PZDmCxD0ROELMEfjTYozpEVEU8DhtdvaSyEqBOU2OvjaPP7Kmkqo6
         +r6m0KKS3N5z2Q1zsA8AEyFBW32acp69QcJoFakX5tZYJVOF+Y7+LiHpmwMtaKe3+y
         RU08IZS5HlepXxzxA5+NWr59BmTq2Hq4CONLc9GI=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix missing update of modem controls after DLCI" failed to apply to 4.19-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 15:39:31 +0200
Message-ID: <165158517190255@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 48473802506d2d6151f59e0e764932b33b53cb3b Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Wed, 20 Apr 2022 03:13:44 -0700
Subject: [PATCH] tty: n_gsm: fix missing update of modem controls after DLCI
 open

Currently the peer is not informed about the initial state of the modem
control lines after a new DLCI has been opened.
Fix this by sending the initial modem control line states after DLCI open.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220420101346.3315-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index e440c7f6d20e..979dc9151383 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -370,6 +370,7 @@ static const u8 gsm_fcs8[256] = {
 #define GOOD_FCS	0xCF
 
 static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len);
+static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -1483,6 +1484,9 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
 	/* Register gsmtty driver,report gsmtty dev add uevent for user */
 	tty_register_device(gsm_tty_driver, dlci->addr, NULL);
+	/* Send current modem state */
+	if (dlci->addr)
+		gsmtty_modem_update(dlci, 0);
 	wake_up(&dlci->gsm->event);
 }
 

