Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407C24C746A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiB1RpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238565AbiB1Rmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:42:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FA498F52;
        Mon, 28 Feb 2022 09:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 722B6B815BB;
        Mon, 28 Feb 2022 17:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C94C340E7;
        Mon, 28 Feb 2022 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069688;
        bh=Lx0IS8Gmlt0ON9JS9/mUQFsYYSB2G4HV4Wd3sTPvW9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXHurM8SrVst+2U3xZXrAh7Zq6MsKQUlskr9n5ld5UVxUp5CI2XymNwJsjbl0srbq
         ypSmnzQc2fyCVomg086BbFlNMplACk0ZxhGl9D9fX77/ALetph2XeN7A9a5/SrL1Aa
         xW0U2Gs5xUy15oFZs3ZXW5PWyTA3k9Ni56qoiq+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 21/80] bnx2x: fix driver load from initrd
Date:   Mon, 28 Feb 2022 18:24:02 +0100
Message-Id: <20220228172314.216735723@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
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


