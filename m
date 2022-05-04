Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2159F51A760
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354945AbiEDRDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354451AbiEDRA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDD24C79B;
        Wed,  4 May 2022 09:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FFAD617BE;
        Wed,  4 May 2022 16:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A229AC385A5;
        Wed,  4 May 2022 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683134;
        bh=BME9CcRKN5HaiyAH0M+P+DN+4uP3raAhX29wVJvqTdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVPJQYA5j2O7vf1VRj304hYiWfGpLcuJYXUyQ+jrMO/QAAfWSfDk9d4fWgMdjYdBo
         2fYFhX4RoyOpY91imPz1m9gts3tUHJVQPYJaOy64KCfnKjjVIydHHbAOhmD9dAgbHq
         zZBS7WyyBVHoyz00vXejPjjgle3L93XGmw3uJYlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 117/129] tty: n_gsm: fix mux cleanup after unregister tty device
Date:   Wed,  4 May 2022 18:45:09 +0200
Message-Id: <20220504153030.637535756@linuxfoundation.org>
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

commit 284260f278b706364fb4c88a7b56ba5298d5973c upstream.

Internally, we manage the alive state of the mux channels and mux itself
with the field member 'dead'. This makes it possible to notify the user
if the accessed underlying link is already gone. On the other hand,
however, removing the virtual ttys before terminating the channels may
result in peer messages being received without any internal target. Move
the mux cleanup procedure from gsmld_detach_gsm() to gsmld_close() to fix
this by keeping the virtual ttys open until the mux has been cleaned up.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-4-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2410,7 +2410,6 @@ static void gsmld_detach_gsm(struct tty_
 	WARN_ON(tty != gsm->tty);
 	for (i = 1; i < NUM_DLCI; i++)
 		tty_unregister_device(gsm_tty_driver, base + i);
-	gsm_cleanup_mux(gsm, false);
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
 }
@@ -2478,6 +2477,12 @@ static void gsmld_close(struct tty_struc
 {
 	struct gsm_mux *gsm = tty->disc_data;
 
+	/* The ldisc locks and closes the port before calling our close. This
+	 * means we have no way to do a proper disconnect. We will not bother
+	 * to do one.
+	 */
+	gsm_cleanup_mux(gsm, false);
+
 	gsmld_detach_gsm(tty, gsm);
 
 	gsmld_flush_buffer(tty);


