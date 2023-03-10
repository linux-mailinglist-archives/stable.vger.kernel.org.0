Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD136B44AC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjCJO1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjCJO0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:26:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578B711E6C1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:25:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13C6EB822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619DEC4339B;
        Fri, 10 Mar 2023 14:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458313;
        bh=uS+YupRx4mGbpp4bKhIlzft/qTvehTAjlNntYH3YC3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUM2AhSXmuVlen0GNcdpQ8Egai4pIm0Ix1rLS/tsfIJ99z5BtuBUQkQI5sAWwTbMg
         nSZvrzFSkfXgOqZmVh+7JO/hf1zlguBHXZD8L8uKzyQIy3cFVre+pAOde+8obOm3Pr
         p4eGhDn6XJWA9o4kuGsMYfdV+uGOYhHbanFsEmmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/252] mei: bus-fixup:upon error print return values of send and receive
Date:   Fri, 10 Mar 2023 14:40:07 +0100
Message-Id: <20230310133726.572954754@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 4b8659e2c258e4fdac9ccdf06cc20c0677894ef9 ]

For easier debugging, upon error, print also return values
from __mei_cl_recv() and __mei_cl_send() functions.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221212214933.275434-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/bus-fixup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 198e030e5b3d5..14f3e05643fc3 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -174,7 +174,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 	ret = __mei_cl_send(cldev->cl, buf, sizeof(struct mkhi_msg_hdr),
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd\n");
+		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -186,7 +186,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 		 * Should be at least one version block,
 		 * error out if nothing found
 		 */
-		dev_err(&cldev->dev, "Could not read FW version\n");
+		dev_err(&cldev->dev, "Could not read FW version ret = %d\n", bytes_recv);
 		return -EIO;
 	}
 
@@ -335,7 +335,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(struct mei_nfc_cmd),
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(bus->dev, "Could not send IF version cmd\n");
+		dev_err(bus->dev, "Could not send IF version cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -350,7 +350,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = 0;
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length, 0, 0);
 	if (bytes_recv < 0 || (size_t)bytes_recv < if_version_length) {
-		dev_err(bus->dev, "Could not read IF version\n");
+		dev_err(bus->dev, "Could not read IF version ret = %d\n", bytes_recv);
 		ret = -EIO;
 		goto err;
 	}
-- 
2.39.2



