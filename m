Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48246635767
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiKWJmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbiKWJln (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B036C1121F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:39:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DBE861B22
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D694C433C1;
        Wed, 23 Nov 2022 09:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196357;
        bh=LGSmYJnvpbn77ND6YCFRfwq+7XPVEZfsoPVcABtc6KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBLr6kg943R83DtrfE+OouOUDB9AjR5gyNNMF2McMA4O+h0becjxsSF7N9OMhfWMI
         3KP0X1zz4rLrMAV8eAENs6j3ivkrubS0nylWo3tLoG8A9+2sW+HafXQKQVl63arWrz
         N7Tdf7cEDrq+OKOjwsCW9BgGLfaxODG4Lr+mD5YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Marangi <ansuelsmth@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.0 001/314] mtd: rawnand: qcom: handle ret from parse with codeword_fixup
Date:   Wed, 23 Nov 2022 09:47:26 +0100
Message-Id: <20221123084625.538391210@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit 7df140e84a75c89962feef659d686303d3ce75e5 upstream.

With use_codeword_fixup enabled, any return from
mtd_device_parse_register gets overwritten. Aside from the clear bug, this
is also problematic as a parser can EPROBE_DEFER and because this is not
correctly handled, the nand is never rescanned later in the bootup
process.

An example of this problem is when smem requires additional time to be
probed and nandc use qcomsmempart as parser. Parser will return
EPROBE_DEFER but in the current code this ret gets overwritten by
qcom_nand_host_parse_boot_partitions and qcom_nand_host_init_and_register
return 0.

Correctly handle the return code from mtd_device_parse_register so that
any error from this function is not ignored.

Fixes: 862bdedd7f4b ("mtd: nand: raw: qcom_nandc: add support for unprotected spare data pages")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221021165304.19991-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -3167,16 +3167,18 @@ static int qcom_nand_host_init_and_regis
 
 	ret = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
 	if (ret)
-		nand_cleanup(chip);
+		goto err;
 
 	if (nandc->props->use_codeword_fixup) {
 		ret = qcom_nand_host_parse_boot_partitions(nandc, host, dn);
-		if (ret) {
-			nand_cleanup(chip);
-			return ret;
-		}
+		if (ret)
+			goto err;
 	}
 
+	return 0;
+
+err:
+	nand_cleanup(chip);
 	return ret;
 }
 


