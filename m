Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F245B7362
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiIMPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiIMPFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F25753A9;
        Tue, 13 Sep 2022 07:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAA09B80FA1;
        Tue, 13 Sep 2022 14:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCFBC433D7;
        Tue, 13 Sep 2022 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079426;
        bh=6QeIICB9afA+06gQQvIaQmzK9vuCVqdguqf5PTujeGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNDAyuMP1/TcLT2kSWwQTleQ42cN4XY84n4hI6vb83aEvNV5bNFDIboO9ynttSekq
         3ssdfPftON6V9rEqD749E2Y7zEJ/yRkGtKju0l8GxHefTECkcLRTqazf0umdo7canQ
         HwVQONHa6Bep1U+ParpXfh0IWaeHLCadwwEepgsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Zheng Wang <hackerzheng666@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.19 21/79] staging: rtl8712: fix use after free bugs
Date:   Tue, 13 Sep 2022 16:06:39 +0200
Message-Id: <20220913140349.912122205@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e230a4455ac3e9b112f0367d1b8e255e141afae0 upstream.

_Read/Write_MACREG callbacks are NULL so the read/write_macreg_hdl()
functions don't do anything except free the "pcmd" pointer.  It
results in a use after free.  Delete them.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Cc: stable <stable@kernel.org>
Reported-by: Zheng Wang <hackerzheng666@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/Yw4ASqkYcUhUfoY2@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/rtl8712_cmd.c |   36 ----------------------------------
 1 file changed, 36 deletions(-)

--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -129,34 +129,6 @@ static void r871x_internal_cmd_hdl(struc
 	kfree(pdrvcmd->pbuf);
 }
 
-static u8 read_macreg_hdl(struct _adapter *padapter, u8 *pbuf)
-{
-	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
-	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
-
-	/*  invoke cmd->callback function */
-	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
-	if (!pcmd_callback)
-		r8712_free_cmd_obj(pcmd);
-	else
-		pcmd_callback(padapter, pcmd);
-	return H2C_SUCCESS;
-}
-
-static u8 write_macreg_hdl(struct _adapter *padapter, u8 *pbuf)
-{
-	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
-	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
-
-	/*  invoke cmd->callback function */
-	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
-	if (!pcmd_callback)
-		r8712_free_cmd_obj(pcmd);
-	else
-		pcmd_callback(padapter, pcmd);
-	return H2C_SUCCESS;
-}
-
 static u8 read_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
@@ -225,14 +197,6 @@ static struct cmd_obj *cmd_hdl_filter(st
 	pcmd_r = NULL;
 
 	switch (pcmd->cmdcode) {
-	case GEN_CMD_CODE(_Read_MACREG):
-		read_macreg_hdl(padapter, (u8 *)pcmd);
-		pcmd_r = pcmd;
-		break;
-	case GEN_CMD_CODE(_Write_MACREG):
-		write_macreg_hdl(padapter, (u8 *)pcmd);
-		pcmd_r = pcmd;
-		break;
 	case GEN_CMD_CODE(_Read_BBREG):
 		read_bbreg_hdl(padapter, (u8 *)pcmd);
 		break;


