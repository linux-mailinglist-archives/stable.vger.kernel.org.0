Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79F14BDB9C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352333AbiBUKEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:04:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353086AbiBUJ5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108DC45ADF;
        Mon, 21 Feb 2022 01:25:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8A4BB80EB1;
        Mon, 21 Feb 2022 09:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039BCC340E9;
        Mon, 21 Feb 2022 09:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435497;
        bh=S/iVw1ZUHEf93QErcB6ZooCHz2LvyqWyuvWT1BdyIyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHwQeuxckMdw5DYgEyC83VgZ9TuZip+Piu3wVi4ZxtCbhEiN/4y2+y24+82IhZ/PH
         MZZKEG0RYTqbssI2hix7aUSXEIZ54r86KpzM6vp8dGOS9zI1LIe8bP4vxlbyX/Mqq0
         bKjFUPACLfn1exiMV2KsbgO3m3DFF3UrBibvrWoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Christian Eggers <ceggers@arri.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.16 152/227] mtd: rawnand: gpmi: dont leak PM reference in error path
Date:   Mon, 21 Feb 2022 09:49:31 +0100
Message-Id: <20220221084939.884740253@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit 9161f365c91614e5a3f5c6dcc44c3b1b33bc59c0 upstream.

If gpmi_nfc_apply_timings() fails, the PM runtime usage counter must be
dropped.

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: f53d4c109a66 ("mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220125081619.6286-1-ceggers@arri.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2291,7 +2291,7 @@ static int gpmi_nfc_exec_op(struct nand_
 		this->hw.must_apply_timings = false;
 		ret = gpmi_nfc_apply_timings(this);
 		if (ret)
-			return ret;
+			goto out_pm;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
@@ -2420,6 +2420,7 @@ unmap:
 
 	this->bch = false;
 
+out_pm:
 	pm_runtime_mark_last_busy(this->dev);
 	pm_runtime_put_autosuspend(this->dev);
 


