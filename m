Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AF559459F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350042AbiHOWm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350537AbiHOWjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:39:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4834DB2A;
        Mon, 15 Aug 2022 12:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94650B80EAD;
        Mon, 15 Aug 2022 19:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB59C433C1;
        Mon, 15 Aug 2022 19:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593091;
        bh=NMcjJwEwPiqeIaDe8zmQomMLRLCK3nydvXSKtNTM+6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tm3yy2nEoA+inXMb+Z3N0Fi4RF6iTUwZx2yh0lTbrpGryqQglnizIEUf16D64B/JY
         PsnNxwT/6/qU36xAhaeMcrMhGvQt4y3j8Eg+hTbeHzGYdy2bqtQ6CaIsJeBnqRbhHR
         iSQtKsJzhuGq8vGOXRlUxyZSfET46yXV6bO4nR+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0862/1095] tty: n_gsm: fix resource allocation order in gsm_activate_mux()
Date:   Mon, 15 Aug 2022 20:04:21 +0200
Message-Id: <20220815180504.996320151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 7349660438603ed19282e75949561406531785a5 ]

Within gsm_activate_mux() all timers and locks are initiated before the
actual resource for the control channel is allocated. This can lead to race
conditions.

Allocate the control channel DLCI object first to avoid race conditions.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701122332.2039-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index ab7765afab86..17927163790e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2501,6 +2501,10 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	struct gsm_dlci *dlci;
 	int ret;
 
+	dlci = gsm_dlci_alloc(gsm, 0);
+	if (dlci == NULL)
+		return -ENOMEM;
+
 	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	INIT_WORK(&gsm->tx_work, gsmld_write_task);
@@ -2517,9 +2521,6 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	if (ret)
 		return ret;
 
-	dlci = gsm_dlci_alloc(gsm, 0);
-	if (dlci == NULL)
-		return -ENOMEM;
 	gsm->has_devices = true;
 	gsm->dead = false;		/* Tty opens are now permissible */
 	return 0;
-- 
2.35.1



