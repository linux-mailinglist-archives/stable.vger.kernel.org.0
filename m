Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA828594DA9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243196AbiHPArH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245174AbiHPAp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AF4AE9C9;
        Mon, 15 Aug 2022 13:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 964C9B80EA9;
        Mon, 15 Aug 2022 20:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F46C433C1;
        Mon, 15 Aug 2022 20:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596117;
        bh=IJlcHDJ/ZiqP3zdKtkNzDljdasU4Uw8/bQxQij0eZvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qws2ZiwmjsPrrYYlMM4Utw3Cf2zvVqGMwqq+VekRJmcMaqmd/VEAGr0y+IhIxjpml
         mkT/1X8Lavcaec1WLmfx9z/77jxiOUNHFyEp8U3Lzm1RXgS8IveIwNZntLgxDYiEKO
         Hv7pBkzG8FZCUIU2cszB3LkdmIl57b9Q4nW3VqOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0933/1157] tty: n_gsm: fix resource allocation order in gsm_activate_mux()
Date:   Mon, 15 Aug 2022 20:04:49 +0200
Message-Id: <20220815180516.811535190@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 79869f2b570c..ba399a660573 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2497,6 +2497,10 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	struct gsm_dlci *dlci;
 	int ret;
 
+	dlci = gsm_dlci_alloc(gsm, 0);
+	if (dlci == NULL)
+		return -ENOMEM;
+
 	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	INIT_WORK(&gsm->tx_work, gsmld_write_task);
@@ -2513,9 +2517,6 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
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



