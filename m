Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273ED5826D5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbiG0MjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 08:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiG0MjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 08:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3788637189
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 05:39:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7643614F1
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 12:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAC4C433C1;
        Wed, 27 Jul 2022 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658925560;
        bh=aoBGMR5Ibj07hzfR/EoSrTOGocOqQfGtufjgVDI4/6g=;
        h=Subject:To:From:Date:From;
        b=BQAurFkxt/yihB/kq5s3dhAifdBVPZLdoOi1o7qJlsYSa+GSEuphi1z6LSLbY3knJ
         TYP28UPuou0Vu49bFryORVBMkI5bJQbPQ9nzQfj0xo78ghI/8cC/YTC9gVIrWFdnCZ
         UK+Jl0WUlHwy6IXucJjN0kw7MV3ueUmfpzedcfMs=
Subject: patch "usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion" added to usb-testing
To:     quic_linyyuan@quicinc.com, gregkh@linuxfoundation.org,
        quic_jackp@quicinc.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Jul 2022 14:39:02 +0200
Message-ID: <165892554235232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a7dc438b5e446afcd1b3b6651da28271400722f2 Mon Sep 17 00:00:00 2001
From: Linyu Yuan <quic_linyyuan@quicinc.com>
Date: Tue, 26 Jul 2022 14:45:49 +0800
Subject: usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion

We found PPM will not send any notification after it report error status
and OPM issue GET_ERROR_STATUS command to read the details about error.

According UCSI spec, PPM may clear the Error Status Data after the OPM
has acknowledged the command completion.

This change add operation to acknowledge the command completion from PPM.

Fixes: bdc62f2bae8f (usb: typec: ucsi: Simplified registration and I/O API)
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1658817949-4632-1-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index cbd862f9f2a1..1aea46493b85 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -76,6 +76,10 @@ static int ucsi_read_error(struct ucsi *ucsi)
 	if (ret)
 		return ret;
 
+	ret = ucsi_acknowledge_command(ucsi);
+	if (ret)
+		return ret;
+
 	switch (error) {
 	case UCSI_ERROR_INCOMPATIBLE_PARTNER:
 		return -EOPNOTSUPP;
-- 
2.37.1


