Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192EF528E8D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiEPTrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346230AbiEPTp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DC83EF20;
        Mon, 16 May 2022 12:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F6F061510;
        Mon, 16 May 2022 19:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A59C34100;
        Mon, 16 May 2022 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730203;
        bh=w3nI1hObtd0qtOIqxJWRG2ianj1jmQMnACDUd0X2K8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsSUQNbjh+RI6vwFa9V70IFjjWoWRBmeaajeHtdRn9P+z7izGu2pi4NsO1y62A359
         1IeJONT8rEYHJdqQe25RhAR5/ms8q9TrZVbE8Sdir0AcNh0J4BFRE9JvS9JJrha/FN
         JOME3Fz26fw/+drV0FM5wlLlwmv5qK7wf2eaLrEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.4 25/43] tty: n_gsm: fix mux activation issues in gsm_config()
Date:   Mon, 16 May 2022 21:36:36 +0200
Message-Id: <20220516193615.461685912@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Daniel Starke <daniel.starke@siemens.com>

commit edd5f60c340086891fab094ad61270d6c80f9ca4 upstream.

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
---
 drivers/tty/n_gsm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2259,6 +2259,7 @@ static void gsm_copy_config_values(struc
 
 static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 {
+	int ret = 0;
 	int need_close = 0;
 	int need_restart = 0;
 
@@ -2334,10 +2335,13 @@ static int gsm_config(struct gsm_mux *gs
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
 


