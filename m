Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19C7527EF9
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 09:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiEPH6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 03:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbiEPH6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 03:58:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA5929807
        for <stable@vger.kernel.org>; Mon, 16 May 2022 00:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75341B80EB1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 07:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53E0C385AA;
        Mon, 16 May 2022 07:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652687891;
        bh=FAD8Xi/VFrmJumGuUa4df+Z1kr2m6zKsye1sjccKBF4=;
        h=Subject:To:Cc:From:Date:From;
        b=l+ISmvPHJpdgBPI0p699tw0T5Bp+M1XtmI031e8mKz0VrUjiJAI3gPla6aWoJOmSB
         JO7oIK18nqs5n+o9dwlOY6Yv/QGLeQcHvDiEMHBrZePVdwe5QR0yOsao+RNhMnEQRq
         eZ5LyugyinKTs/zuasO2iBtwBQQMPAI1zh5Sm7PA=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix mux activation issues in gsm_config()" failed to apply to 4.19-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 09:58:08 +0200
Message-ID: <165268788810876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From edd5f60c340086891fab094ad61270d6c80f9ca4 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Wed, 4 May 2022 10:17:32 +0200
Subject: [PATCH] tty: n_gsm: fix mux activation issues in gsm_config()

The current implementation activates the mux if it was restarted and opens
the control channel if the mux was previously closed and we are now acting
as initiator instead of responder, which is the default setting.
This has two issues.
1) No mux is activated if we keep all default values and only switch to
initiator. The control channel is not allocated but will be opened next
which results in a NULL pointer dereference.
2) Switching the configuration after it was once configured while keeping
the initiator value the same will not reopen the control channel if it was
closed due to parameter incompatibilities. The mux remains dead.

Fix 1) by always activating the mux if it is dead after configuration.
Fix 2) by always opening the control channel after mux activation.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220504081733.3494-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 9b0b435cf26e..bcb714031d69 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2352,6 +2352,7 @@ static void gsm_copy_config_values(struct gsm_mux *gsm,
 
 static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 {
+	int ret = 0;
 	int need_close = 0;
 	int need_restart = 0;
 
@@ -2419,10 +2420,13 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 	 * FIXME: We need to separate activation/deactivation from adding
 	 * and removing from the mux array
 	 */
-	if (need_restart)
-		gsm_activate_mux(gsm);
-	if (gsm->initiator && need_close)
-		gsm_dlci_begin_open(gsm->dlci[0]);
+	if (gsm->dead) {
+		ret = gsm_activate_mux(gsm);
+		if (ret)
+			return ret;
+		if (gsm->initiator)
+			gsm_dlci_begin_open(gsm->dlci[0]);
+	}
 	return 0;
 }
 

