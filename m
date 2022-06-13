Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47458549469
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353559AbiFMMZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355653AbiFMMX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE0B27B21;
        Mon, 13 Jun 2022 04:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47F10B80D3A;
        Mon, 13 Jun 2022 11:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA713C3411C;
        Mon, 13 Jun 2022 11:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118309;
        bh=T7zgCZdrnSI9zOst5mi3apWNt045/z6rDMsSMmV8L38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snrxRISEEfoiJZ24vhQcBJPTGkJjlH5CMEeAvADOAq4U/7EuCPLK/mQuZH51PiqRA
         hVSYg/tXz3qMJAezb/jnEecKdWTjs+9Gt4rK4q7RJtV0w1aBTHzTf+ZHWITNZmTr7s
         6kWTakYnurJq6+IwL6Ks2lYj7sxvIOCtlOMpAGnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ma <linma@zju.edu.cn>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/172] USB: storage: karma: fix rio_karma_init return
Date:   Mon, 13 Jun 2022 12:09:31 +0200
Message-Id: <20220613094853.090907893@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit b92ffb1eddd9a66a90defc556dcbf65a43c196c7 ]

The function rio_karam_init() should return -ENOMEM instead of
value 0 (USB_STOR_TRANSPORT_GOOD) when allocation fails.

Similarly, it should return -EIO when rio_karma_send_command() fails.

Fixes: dfe0d3ba20e8 ("USB Storage: add rio karma eject support")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20220412144359.28447-1-linma@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/karma.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 05cec81dcd3f..38ddfedef629 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -174,24 +174,25 @@ static void rio_karma_destructor(void *extra)
 
 static int rio_karma_init(struct us_data *us)
 {
-	int ret = 0;
 	struct karma_data *data = kzalloc(sizeof(struct karma_data), GFP_NOIO);
 
 	if (!data)
-		goto out;
+		return -ENOMEM;
 
 	data->recv = kmalloc(RIO_RECV_LEN, GFP_NOIO);
 	if (!data->recv) {
 		kfree(data);
-		goto out;
+		return -ENOMEM;
 	}
 
 	us->extra = data;
 	us->extra_destructor = rio_karma_destructor;
-	ret = rio_karma_send_command(RIO_ENTER_STORAGE, us);
-	data->in_storage = (ret == 0);
-out:
-	return ret;
+	if (rio_karma_send_command(RIO_ENTER_STORAGE, us))
+		return -EIO;
+
+	data->in_storage = 1;
+
+	return 0;
 }
 
 static struct scsi_host_template karma_host_template;
-- 
2.35.1



