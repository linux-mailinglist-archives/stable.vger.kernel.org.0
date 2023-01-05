Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E0065EC08
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbjAENFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbjAENFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:05:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2B55A8A5
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:05:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4815C61A10
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5206DC433EF;
        Thu,  5 Jan 2023 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923907;
        bh=p/1uJGOGE19VT9SLHfEt29Aw3tB60D+JXrU/d5EKrdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeZFu+fyJlaeycxtxEV5kzEKmujz9s64OPw6N981wtzlJ0FCUlU1AjQOi1hJ+Op8N
         duXIkQ5ZAcEnO8jJmEoEnNroQhzJgNmBgNZ5Tt7T+ARuOND1C2yHkYxvUY1w502cWz
         JAChz9m/KN1MfUMc7JtsxoLrdw5tEQO3Oq6Gzw5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 172/251] nfc: pn533: Clear nfc_target before being used
Date:   Thu,  5 Jan 2023 13:55:09 +0100
Message-Id: <20230105125342.690699692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

[ Upstream commit 9f28157778ede0d4f183f7ab3b46995bb400abbe ]

Fix a slab-out-of-bounds read that occurs in nla_put() called from
nfc_genl_send_target() when target->sensb_res_len, which is duplicated
from an nfc_target in pn533, is too large as the nfc_target is not
properly initialized and retains garbage values. Clear nfc_targets with
memset() before they are used.

Found by a modified version of syzkaller.

BUG: KASAN: slab-out-of-bounds in nla_put
Call Trace:
 memcpy
 nla_put
 nfc_genl_dump_targets
 genl_lock_dumpit
 netlink_dump
 __netlink_dump_start
 genl_family_rcv_msg_dumpit
 genl_rcv_msg
 netlink_rcv_skb
 genl_rcv
 netlink_unicast
 netlink_sendmsg
 sock_sendmsg
 ____sys_sendmsg
 ___sys_sendmsg
 __sys_sendmsg
 do_syscall_64

Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221214015139.119673-1-linuxlovemin@yonsei.ac.kr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 806309ee4165..fe81946a9ab4 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1294,6 +1294,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);
 
+	memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;
 
 	rc = rsp->status & PN533_CMD_RET_MASK;
@@ -1776,6 +1778,8 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 
 		dev_dbg(dev->dev, "Creating new target\n");
 
+		memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
 		nfc_target.nfcid1_len = 10;
 		memcpy(nfc_target.nfcid1, rsp->nfcid3t, nfc_target.nfcid1_len);
-- 
2.35.1



