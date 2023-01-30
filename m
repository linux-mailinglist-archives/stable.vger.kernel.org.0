Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE146681160
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbjA3OM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbjA3OMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15823B670
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C72661035
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADF7C433D2;
        Mon, 30 Jan 2023 14:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087956;
        bh=od2+84rHqzHmfgO0/CjVxae8TsjveLctZX+Tal3gvUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rxt669SvacqYccEm09rP6r2wZf6HjDzeupL0ilphC7CZTuuk8secBC/zN1F9uDuv5
         pyQAq58VNgPJEpdEcIkc1eeuWdvgwU2ZvIEvGb3YN5SpSd7W42E/J/KMkjdRCekmOo
         TNjSSg/UFSiqpLNUkKhQdfkiDb0jb6euhdW1w5hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Esina Ekaterina <eesina@astralinux.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/204] net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs
Date:   Mon, 30 Jan 2023 14:50:04 +0100
Message-Id: <20230130134318.031257445@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esina Ekaterina <eesina@astralinux.ru>

[ Upstream commit 488e0bf7f34af3d42d1d5e56f7a5a7beaff188a3 ]

If uhdlc_priv_tsa != 1 then utdm is not initialized.
And if ret != NULL then goto undo_uhdlc_init, where
utdm is dereferenced. Same if dev == NULL.

Found by Astra Linux on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 8d68100ab4ad ("soc/fsl/qe: fix err handling of ucc_of_parse_tdm")
Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
Link: https://lore.kernel.org/r/20230112074703.13558-1-eesina@astralinux.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index cda1b4ce6b21..8305df1a3008 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1241,9 +1241,11 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
 free_dev:
 	free_netdev(dev);
 undo_uhdlc_init:
-	iounmap(utdm->siram);
+	if (utdm)
+		iounmap(utdm->siram);
 unmap_si_regs:
-	iounmap(utdm->si_regs);
+	if (utdm)
+		iounmap(utdm->si_regs);
 free_utdm:
 	if (uhdlc_priv->tsa)
 		kfree(utdm);
-- 
2.39.0



