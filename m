Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A8A4C74C2
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiB1Rqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbiB1Rpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:45:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A68A4BBAE;
        Mon, 28 Feb 2022 09:37:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A11A61542;
        Mon, 28 Feb 2022 17:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2431FC36AF5;
        Mon, 28 Feb 2022 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069872;
        bh=Lx0IS8Gmlt0ON9JS9/mUQFsYYSB2G4HV4Wd3sTPvW9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bwj+ObP4BaX4+eUeFeUw7cxdk9Uf+vKENq4elmQ8lq8bNE0J4rd32mS4AUHNf9qkI
         6GALJNDNEZWg4ByAqiUGstlGFHsotudPK0zeKDouIZdzjAAr53JeYdSbysuryaAG9v
         m6avz5HnstP1pSqdkBCj8jo+qha/qvF1TFf1fbis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 041/139] bnx2x: fix driver load from initrd
Date:   Mon, 28 Feb 2022 18:23:35 +0100
Message-Id: <20220228172352.042622104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

commit e13ad1443684f7afaff24cf207e85e97885256bd upstream.

Commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0") added
new firmware support in the driver with maintaining older firmware
compatibility. However, older firmware was not added in MODULE_FIRMWARE()
which caused missing firmware files in initrd image leading to driver load
failure from initrd. This patch adds MODULE_FIRMWARE() for older firmware
version to have firmware files included in initrd.

Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215627
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Link: https://lore.kernel.org/r/20220223085720.12021-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -100,6 +100,9 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_FILE_NAME_E1);
 MODULE_FIRMWARE(FW_FILE_NAME_E1H);
 MODULE_FIRMWARE(FW_FILE_NAME_E2);
+MODULE_FIRMWARE(FW_FILE_NAME_E1_V15);
+MODULE_FIRMWARE(FW_FILE_NAME_E1H_V15);
+MODULE_FIRMWARE(FW_FILE_NAME_E2_V15);
 
 int bnx2x_num_queues;
 module_param_named(num_queues, bnx2x_num_queues, int, 0444);


