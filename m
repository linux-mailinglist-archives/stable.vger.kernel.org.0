Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B416AF238
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbjCGSvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjCGSvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39CDA7A80
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:39:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD81FB819DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169C4C433EF;
        Tue,  7 Mar 2023 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214339;
        bh=28H1ONkz1lDv/Iw0RjJPxoKVjR46cl+b9yllVLbZiW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYBh9bVdygG70StujXsqQq/Qn640FGYUEkE8nyHt98/yy5PydAcpoY+nWC6zA4M6l
         14tj72yFeK8WeTLYpkGAv75mYEEUkGb6q5xqMJ9ZPfx/IS5pFnWQya4dXPyloST/94
         MlPLZebeX6rUs1CTYpt9q4ttgtMTu+A/+02zWKtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 6.1 790/885] mtd: spi-nor: sfdp: Fix index value for SCCR dwords
Date:   Tue,  7 Mar 2023 18:02:04 +0100
Message-Id: <20230307170036.220087095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

commit ad9679f3811899fd1c21dc7bdd715e8e1cfb46b9 upstream.

Array index for SCCR 22th DOWRD should be 21.

Fixes: 981a8d60e01f ("mtd: spi-nor: Parse SFDP SCCR Map")
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d8a2a77c2c95cf776e7dcae6392d29fdcf5d6307.1672026365.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sfdp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1222,7 +1222,7 @@ static int spi_nor_parse_sccr(struct spi
 
 	le32_to_cpu_array(dwords, sccr_header->length);
 
-	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[22]))
+	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[21]))
 		nor->flags |= SNOR_F_IO_MODE_EN_VOLATILE;
 
 out:


