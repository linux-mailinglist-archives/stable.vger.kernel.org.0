Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8856FD1F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiGKJvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiGKJuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB73823BEF;
        Mon, 11 Jul 2022 02:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF45B80E7E;
        Mon, 11 Jul 2022 09:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4040C34115;
        Mon, 11 Jul 2022 09:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531477;
        bh=RWogilwkxJcP15SAbJz7VzfvXOwDkcVEDfMpxC6e0J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oatoPEn5pqNo8sFlsAOQ7sprBjGuW9Zss7KvK1YypjNj4jXOQ7gpB1IlltdGyOly
         rS1yq4ZoFEj+DE4yJrtuM2E+Uss3KnvRc+nA3Kq9B0OZ1FmQwWUNpFO5hi3k4Y7Cfh
         us3ZZMYfue+HHmyxx8rH+8xEYsdaSnEp0eGx3DjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/230] tty: n_gsm: Modify CR,PF bit when config requester
Date:   Mon, 11 Jul 2022 11:06:14 +0200
Message-Id: <20220711090607.412980854@linuxfoundation.org>
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

From: Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>

[ Upstream commit cc0f42122a7e7a5ede9c5f2a41199128b8449eda ]

When n_gsm config "initiator=0",as requester,gsmld receives dlci SABM/DISC
control command frame,but send UA frame is error.

Example:
Gsmld receive dlc0 SABM frame "f9 03 3f 01 1c f9",now it sends UA
frame "f9 01 63 01 a3 f9",CR and PF bit are 0,but it should be set
1 from requster to initiator.

Kernel test log as follows:

Before modify

[  271.732031] c1 gsmld_receive: 00000000: f9 03 3f 01 1c f9
[  271.741719] c1 <-- 0) C: SABM(P)
[  271.749483] c1 gsmld_output: 00000000: f9 01 63 01 a3 f9
[  271.758337] c1 --> 0) R: UA(F)

After modify

[  261.233188] c0 gsmld_receive: 00000000: f9 03 3f 01 1c f9
[  261.242767] c0 <-- 0) C: SABM(P)
[  261.250497] c0 gsmld_output: 00000000: f9 03 73 01 d7 f9
[  261.259759] c0 --> 0) C: UA(P)

Signed-off-by: Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>
Link: https://lore.kernel.org/r/1629461872-26965-3-git-send-email-zhenguo6858@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 6734ef22c304..91ce8e6e889a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -625,7 +625,7 @@ static void gsm_send(struct gsm_mux *gsm, int addr, int cr, int control)
 
 static inline void gsm_response(struct gsm_mux *gsm, int addr, int control)
 {
-	gsm_send(gsm, addr, 0, control);
+	gsm_send(gsm, addr, 1, control);
 }
 
 /**
@@ -1818,9 +1818,9 @@ static void gsm_queue(struct gsm_mux *gsm)
 		if (dlci == NULL)
 			return;
 		if (dlci->dead)
-			gsm_response(gsm, address, DM);
+			gsm_response(gsm, address, DM|PF);
 		else {
-			gsm_response(gsm, address, UA);
+			gsm_response(gsm, address, UA|PF);
 			gsm_dlci_open(dlci);
 		}
 		break;
@@ -1828,11 +1828,11 @@ static void gsm_queue(struct gsm_mux *gsm)
 		if (cr == 0)
 			goto invalid;
 		if (dlci == NULL || dlci->state == DLCI_CLOSED) {
-			gsm_response(gsm, address, DM);
+			gsm_response(gsm, address, DM|PF);
 			return;
 		}
 		/* Real close complete */
-		gsm_response(gsm, address, UA);
+		gsm_response(gsm, address, UA|PF);
 		gsm_dlci_close(dlci);
 		break;
 	case UA|PF:
-- 
2.35.1



