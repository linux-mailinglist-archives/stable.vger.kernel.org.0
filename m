Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010E7594367
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349989AbiHOWiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350190AbiHOWfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5900371BF1;
        Mon, 15 Aug 2022 12:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CB52B8114D;
        Mon, 15 Aug 2022 19:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E22CC433D6;
        Mon, 15 Aug 2022 19:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592967;
        bh=MNK7u5dyCfo7vAH0daYRM5AOYYJy+wYIqzg5aLVcy9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOZmHCspgGrBey04IOvCquv4ytgK9e8vWLYBTP5qQ2JWxEhDxNcvMCfJHcz3xjASw
         c6AXFa0JNAFoADVH5urdlHfaXNJMFMzEC9617mpvapCRIebF1lo+6a7FA4NIeUIpCI
         ODDsIX+Oe/Vrh5Y4GT7WJZhk4YJLYmnSnmM0FFsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0873/1095] tty: n_gsm: fix flow control handling in tx path
Date:   Mon, 15 Aug 2022 20:04:32 +0200
Message-Id: <20220815180505.489476843@linuxfoundation.org>
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

[ Upstream commit 59ff0680ecbfec742b1e0381e7cc46b41eb06647 ]

The current implementation constipates all transmission paths during flow
control except for flow control frames. However, these may not be located
at the beginning of the transmission queue of the control channel.
Ensure that flow control frames in the transmission queue for the control
channel are always handled even if constipated by skipping through other
messages.

Fixes: 0af021678d5d ("tty: n_gsm: fix deadlock and link starvation in outgoing data path")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220707113223.3685-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 8b8c7312935f..7749de4f269a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -891,7 +891,7 @@ static int gsm_data_kick(struct gsm_mux *gsm)
 	/* Serialize control messages and control channel messages first */
 	list_for_each_entry_safe(msg, nmsg, &gsm->tx_ctrl_list, list) {
 		if (gsm->constipated && !gsm_is_flow_ctrl_msg(msg))
-			return -EAGAIN;
+			continue;
 		ret = gsm_send_packet(gsm, msg);
 		switch (ret) {
 		case -ENOSPC:
-- 
2.35.1



