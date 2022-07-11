Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF82656FD28
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiGKJvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiGKJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C61F23BDE;
        Mon, 11 Jul 2022 02:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC23ECE1257;
        Mon, 11 Jul 2022 09:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BF7C34115;
        Mon, 11 Jul 2022 09:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531491;
        bh=Ogtk9ds9PUoZv1yHNlKP+Gp/qGJsLeUWAZAHVWnzl1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSeXE8Mbi03DbJG58PrIk3rl6YxsVxa1JTXvzTCrpR3Vw7VpCInx416xpw0FM+Dn1
         LJA0yFf/NC+bnqJld3XN8i++G4nA7jmMOLrdq3nPDWi+9i4+sHdZ2i0Ng1MIGa8Vge
         ZteJFMHKy8fg2IqK4nJagkKuvtdt1u5fEyzM/DM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/230] tty: n_gsm: fix missing update of modem controls after DLCI open
Date:   Mon, 11 Jul 2022 11:06:19 +0200
Message-Id: <20220711090607.554714477@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

[ Upstream commit 48473802506d2d6151f59e0e764932b33b53cb3b ]

Currently the peer is not informed about the initial state of the modem
control lines after a new DLCI has been opened.
Fix this by sending the initial modem control line states after DLCI open.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220420101346.3315-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index d3d5308daf35..c52d5e0d5c6f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -371,6 +371,7 @@ static const u8 gsm_fcs8[256] = {
 #define GOOD_FCS	0xCF
 
 static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len);
+static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -1489,6 +1490,9 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 	dlci->state = DLCI_OPEN;
 	if (debug & 8)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
+	/* Send current modem state */
+	if (dlci->addr)
+		gsmtty_modem_update(dlci, 0);
 	wake_up(&dlci->gsm->event);
 }
 
-- 
2.35.1



