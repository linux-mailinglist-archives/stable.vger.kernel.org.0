Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875644A47D2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378568AbiAaNLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378586AbiAaNLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:11:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A0EC06173E
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 05:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92FE611DE
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90885C340F0;
        Mon, 31 Jan 2022 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643634704;
        bh=iz+Iln+yXhErTP8YF3hKmWeS8dMSawVDJ/e6h8HAxbY=;
        h=Subject:To:From:Date:From;
        b=PJqD4+v5/B5KrbCtloF+2ro71QwMBWrpK9EQAcO/hWS1wPPoygdSipye5GP07pfDh
         ckFlE8fM3vw+AeknGEkRR3h0yIYQsTtRoqyIuCuGHm2gZUfzQ9s/8ssuykCpLOHTu9
         uQN0wnaKnXDC4xW3NmwyTauVZxeWnzzpZDbpJHAM=
Subject: patch "usb: ulpi: Call of_node_put correctly" added to usb-linus
To:     sean.anderson@seco.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 14:11:33 +0100
Message-ID: <16436346938033@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: ulpi: Call of_node_put correctly

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0a907ee9d95e3ac35eb023d71f29eae0aaa52d1b Mon Sep 17 00:00:00 2001
From: Sean Anderson <sean.anderson@seco.com>
Date: Thu, 27 Jan 2022 14:00:03 -0500
Subject: usb: ulpi: Call of_node_put correctly

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
 drivers/usb/common/ulpi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 09ad569a1a35..5509d3847af4 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -248,12 +248,16 @@ static int ulpi_register(struct device *dev, struct ulpi *ulpi)
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
-- 
2.35.1


