Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66031657F7E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiL1QFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiL1QF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:05:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0819283
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:05:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE83BB81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22374C433D2;
        Wed, 28 Dec 2022 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243525;
        bh=EJmILK6yAOIGNz0S2ddwxsZoVnw0JsuolayKR407KjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0a65SYw04ky/SWGLSJ6zpmALIAXXCSo9Lh6y8MzosyaeaYOnYOCG33xNny+5NPfTx
         6oYN68YwIfg8cXOKYfo0ERMy1KbBTh6tjxQPpEkrLStpr0GnAR4MditqbiI91IQgZE
         79lUd4nJagh8w8B32mvWFYW5uw3g8G1DJQoTk1R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Inga Stotland <inga.stotland@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0539/1073] Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS
Date:   Wed, 28 Dec 2022 15:35:27 +0100
Message-Id: <20221228144342.695952622@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Inga Stotland <inga.stotland@intel.com>

[ Upstream commit 3b1c7c00b8c22b3cb79532252c59eb0b287bb86d ]

When validating the parameter length for MGMT_OP_ADD_EXT_ADV_PARAMS
command, use the correct op code in error status report:
was MGMT_OP_ADD_ADVERTISING, changed to MGMT_OP_ADD_EXT_ADV_PARAMS.

Fixes: 12410572833a2 ("Bluetooth: Break add adv into two mgmt commands")
Signed-off-by: Inga Stotland <inga.stotland@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3d1cd0666968..22bfeb5b2b3b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8385,7 +8385,7 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 	 * extra parameters we don't know about will be ignored in this request.
 	 */
 	if (data_len < MGMT_ADD_EXT_ADV_PARAMS_MIN_SIZE)
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
 				       MGMT_STATUS_INVALID_PARAMS);
 
 	flags = __le32_to_cpu(cp->flags);
-- 
2.35.1



