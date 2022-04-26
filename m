Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961F050F53F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345566AbiDZIqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346833AbiDZIpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA59FB1887;
        Tue, 26 Apr 2022 01:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7817561805;
        Tue, 26 Apr 2022 08:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8597BC385A0;
        Tue, 26 Apr 2022 08:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962153;
        bh=8lOvhLAFxd8QUqgv//ER/ADXQbcIfcssIo0AaOmgPks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2r0Ie936Yp/J3JMtCzYfRUSlPghHLWG3rHElUGE9Pc2AyqhKx8nn+VXZNryR8EVz
         NJFtMbjF3o2rdJcoKSaUL0kJJyx69x3xxdF5nv26RmPpctvfvBMD6CUW0pDY/C4BZS
         RqZzt86hP8Cfz2cWnfWnGQ7oqROmnCWGQCL4gQAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 83/86] spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller
Date:   Tue, 26 Apr 2022 10:21:51 +0200
Message-Id: <20220426081743.610999702@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 8c235cc25087495c4288d94f547e9d3061004991 upstream.

Use the spi_mem_default_supports_op() core helper in order to take into
account the buswidth specified by the user in device tree.

Cc: <stable@vger.kernel.org>
Fixes: 0e6aae08e9ae ("spi: Add QuadSPI driver for Atmel SAMA5D2")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20220406133604.455356-1-tudor.ambarus@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/atmel-quadspi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -277,6 +277,9 @@ static int atmel_qspi_find_mode(const st
 static bool atmel_qspi_supports_op(struct spi_mem *mem,
 				   const struct spi_mem_op *op)
 {
+	if (!spi_mem_default_supports_op(mem, op))
+		return false;
+
 	if (atmel_qspi_find_mode(op) < 0)
 		return false;
 


