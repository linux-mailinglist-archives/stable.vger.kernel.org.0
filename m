Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4234BE6C6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350503AbiBUJei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:34:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350521AbiBUJeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:34:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5C029C89;
        Mon, 21 Feb 2022 01:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE01460018;
        Mon, 21 Feb 2022 09:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9324C340E9;
        Mon, 21 Feb 2022 09:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434857;
        bh=Y+8wWX/+BHdYHM4G0Ut01oY1twruDTgP/fIUZ6UlneE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULpM8Q4s6JRFhiazIiLzI4eLiNGz9HxxnkZWu27EhL8hp9jAQ11eiAmlJWfeW7a6C
         48lketTq2i7/6fseeNl5y4r6vzl4aFLpLPyp7DXEY8W2LXXNDIiGuSHllvlSXlhJR5
         2zb4Ln97HIAhic5jOqAphmRUt/pNe0iTm1YHimx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Christian Eggers <ceggers@arri.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 123/196] mtd: rawnand: gpmi: dont leak PM reference in error path
Date:   Mon, 21 Feb 2022 09:49:15 +0100
Message-Id: <20220221084935.052504671@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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
@@ -2293,7 +2293,7 @@ static int gpmi_nfc_exec_op(struct nand_
 		this->hw.must_apply_timings = false;
 		ret = gpmi_nfc_apply_timings(this);
 		if (ret)
-			return ret;
+			goto out_pm;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
@@ -2422,6 +2422,7 @@ unmap:
 
 	this->bch = false;
 
+out_pm:
 	pm_runtime_mark_last_busy(this->dev);
 	pm_runtime_put_autosuspend(this->dev);
 


