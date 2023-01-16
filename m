Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB0466C829
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbjAPQgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbjAPQgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633302B0A1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6BAB81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D4DC433EF;
        Mon, 16 Jan 2023 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886295;
        bh=fakw6uQwB6peSJsSDqTtxyYkWRzDW0/1/aUtrNZqSdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awhVatKVFkFNTqYg+UIgPA5+Di6VxSqxSmroVQaTMnTc6gvbUu5+agIKEIhZvuH1a
         yX5X/00d0oRhaf3CxagYsQhsD/POGZGaUh1Ht54LDDMvkz2v7I1S8SVOcl96FLQyPW
         cQw20CYzq2wKO7V69c0q/0YJ2C/WSYEsorzSNa1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 376/658] nfc: pn533: Clear nfc_target before being used
Date:   Mon, 16 Jan 2023 16:47:44 +0100
Message-Id: <20230116154926.769467982@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 807b7b37d9dc..1e90ff17f87d 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1293,6 +1293,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);
 
+	memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;
 
 	rc = rsp->status & PN533_CMD_RET_MASK;
@@ -1774,6 +1776,8 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 
 		dev_dbg(dev->dev, "Creating new target\n");
 
+		memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
 		nfc_target.nfcid1_len = 10;
 		memcpy(nfc_target.nfcid1, rsp->nfcid3t, nfc_target.nfcid1_len);
-- 
2.35.1



