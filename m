Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6388C4F2772
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbiDEIGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbiDEIBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C690249FB3;
        Tue,  5 Apr 2022 00:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1903761668;
        Tue,  5 Apr 2022 07:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8ACC340EE;
        Tue,  5 Apr 2022 07:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145594;
        bh=RMDCIpgqoRMmnnuBwu/bpCkTKuBa8Q1wElxe8DXBVS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uM1XR2k6yO1O8upXZhDFHLBkUPgthYlQOHrsbaaqUsOZCp8ulh29o85clO3Tf0uD+
         8BPhy2vjejLZGD2q+JXnTpkiLuyTDXPq1wzpY8YaHGeFSaLCTKyC4nub+hDxHUEdbH
         8fT779XW+2wuzOnOjzSU58lwVKYKC3e0oUGRj8xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0459/1126] ionic: fix up printing of timeout error
Date:   Tue,  5 Apr 2022 09:20:06 +0200
Message-Id: <20220405070421.098402779@linuxfoundation.org>
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

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 4cc787bd88be6974f3362fa49fd8c5609bd039b8 ]

Make sure we print the TIMEOUT string if we had a timeout
error, rather than printing the wrong status.

Fixes: 8c9d956ab6fb ("ionic: allow adminq requests to override default error message")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a548f2a01806..2e4294a4fa83 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -215,9 +215,13 @@ static void ionic_adminq_flush(struct ionic_lif *lif)
 void ionic_adminq_netdev_err_print(struct ionic_lif *lif, u8 opcode,
 				   u8 status, int err)
 {
+	const char *stat_str;
+
+	stat_str = (err == -ETIMEDOUT) ? "TIMEOUT" :
+					 ionic_error_to_str(status);
+
 	netdev_err(lif->netdev, "%s (%d) failed: %s (%d)\n",
-		   ionic_opcode_to_str(opcode), opcode,
-		   ionic_error_to_str(status), err);
+		   ionic_opcode_to_str(opcode), opcode, stat_str, err);
 }
 
 static int ionic_adminq_check_err(struct ionic_lif *lif,
-- 
2.34.1



