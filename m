Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D954F27D9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiDEIJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236283AbiDEIBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B994B431;
        Tue,  5 Apr 2022 00:59:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 016A961748;
        Tue,  5 Apr 2022 07:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDC0C340EE;
        Tue,  5 Apr 2022 07:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145597;
        bh=UdP0IzdJecjT0BWP9LHkIR4ds8fCXT1iDcxu9yYHu28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQBHawjyy9cRrEpsb1SUASZMtP6VQwqZd/lEDn6zHvMWbp56xcu9KmMLaldTamwS2
         P0GIxH6xpmoBGUIznbO8RW9Wo8ysjt4nVdnEUaZCdSC4apGvwxjt8kXO8aC0qFDe+y
         RwfId9C1g8VSMtaBCel9v6WkZ2wj/0ysFet5xJYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0460/1126] ionic: Correctly print AQ errors if completions arent received
Date:   Tue,  5 Apr 2022 09:20:07 +0200
Message-Id: <20220405070421.128240864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Brett Creeley <brett@pensando.io>

[ Upstream commit bc43ed4f35abfdb1d52311110d49b545fccce975 ]

Recent changes went into the driver to allow flexibility when
printing error messages. Unfortunately this had the unexpected
consequence of printing confusing messages like the following:

IONIC_CMD_RX_FILTER_ADD (31) failed: IONIC_RC_SUCCESS (-6)

In cases like this the completion of the admin queue command never
completes, so the completion status is 0, hence IONIC_RC_SUCCESS
is printed even though the command clearly failed. For example,
this could happen when the driver tries to add a filter and at
the same time the FW goes through a reset, so the AQ command
never completes.

Fix this by forcing the FW completion status to IONIC_RC_ERROR
in cases where we never get the completion.

Fixes: 8c9d956ab6fb ("ionic: allow adminq requests to override default error message")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 2e4294a4fa83..a0f9136b2d89 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -322,6 +322,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 		if (do_msg && !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 			netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
 				   name, ctx->cmd.cmd.opcode, err);
+		ctx->comp.comp.status = IONIC_RC_ERROR;
 		return err;
 	}
 
@@ -340,6 +341,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 			if (do_msg)
 				netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
 					   name, ctx->cmd.cmd.opcode);
+			ctx->comp.comp.status = IONIC_RC_ERROR;
 			return -ENXIO;
 		}
 
-- 
2.34.1



