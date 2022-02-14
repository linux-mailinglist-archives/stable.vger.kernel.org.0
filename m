Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984434B4829
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbiBNJwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344686AbiBNJvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A57F6D381;
        Mon, 14 Feb 2022 01:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D27BAB80D83;
        Mon, 14 Feb 2022 09:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CD6C36AE2;
        Mon, 14 Feb 2022 09:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831785;
        bh=fEKu0wIsrTU9+RjmzFhznFG/l8LoKPcNOQsQGHl9h6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF9sp0pZdx2rFPS4UcbAn7DIaXcXJl6LKI062+FcHuJYbuMuDpV+cEczCjN/XWXue
         OrWl+JgScXTMMvZqOcHVWFixBwt6DyI6JgZV/n3KZQIR1gDfIMFIxBFyTKc2PaQ7AX
         kdw/1JWvfNmP9FkCTGgUUupOhTwCQK/e9PYTFy8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 5.10 095/116] usb: ulpi: Call of_node_put correctly
Date:   Mon, 14 Feb 2022 10:26:34 +0100
Message-Id: <20220214092502.051973305@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <sean.anderson@seco.com>

commit 0a907ee9d95e3ac35eb023d71f29eae0aaa52d1b upstream.

of_node_put should always be called on device nodes gotten from
of_get_*. Additionally, it should only be called after there are no
remaining users. To address the first issue, call of_node_put if later
steps in ulpi_register fail. To address the latter, call put_device if
device_register fails, which will call ulpi_dev_release if necessary.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20220127190004.1446909-3-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -250,12 +250,16 @@ static int ulpi_register(struct device *
 		return ret;
 
 	ret = ulpi_read_id(ulpi);
-	if (ret)
+	if (ret) {
+		of_node_put(ulpi->dev.of_node);
 		return ret;
+	}
 
 	ret = device_register(&ulpi->dev);
-	if (ret)
+	if (ret) {
+		put_device(&ulpi->dev);
 		return ret;
+	}
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
 		ulpi->id.vendor, ulpi->id.product);


