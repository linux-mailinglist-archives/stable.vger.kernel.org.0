Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486A251A707
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354684AbiEDRBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355641AbiEDRAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E644BB96;
        Wed,  4 May 2022 09:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A228D617A6;
        Wed,  4 May 2022 16:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F17C385A4;
        Wed,  4 May 2022 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683118;
        bh=bk8oiHo7fAjLCDCB+GgK+zQPJnwtXBeitJ/3OLXIcW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLFPcbfLakokdhPhOs2vV855XKojdSES34R3eUiYJf6DGsUeaVprX4uHutIntmmCf
         oXc2vMrTy4vsDxFd3OMkf+TJW8HTFEc5PMyF2mh0Zn7e7js95bz1K19MfQPenazrCi
         rquMDkZ0QATMjx8AW+B0JvjUm5rXzsHBrlSxntao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 122/129] tty: n_gsm: fix wrong DLCI release order
Date:   Wed,  4 May 2022 18:45:14 +0200
Message-Id: <20220504153031.140574826@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

commit deefc58bafb4841df7f0a0d85d89a1c819db9743 upstream.

The current DLCI release order starts with the control channel followed by
the user channels. Reverse this order to keep the control channel open
until all user channels have been released.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-9-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2073,8 +2073,8 @@ static void gsm_cleanup_mux(struct gsm_m
 	/* Finish outstanding timers, making sure they are done */
 	del_timer_sync(&gsm->t2_timer);
 
-	/* Free up any link layer users */
-	for (i = 0; i < NUM_DLCI; i++)
+	/* Free up any link layer users and finally the control channel */
+	for (i = NUM_DLCI - 1; i >= 0; i--)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
 	mutex_unlock(&gsm->mutex);


