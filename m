Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3FE4F3E11
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382665AbiDEMQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243697AbiDEKhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9AD554AC;
        Tue,  5 Apr 2022 03:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D6661676;
        Tue,  5 Apr 2022 10:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92860C385A1;
        Tue,  5 Apr 2022 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154168;
        bh=AI9DrVufi3MdEFjnhzkWMRlWnmYNO4xCFAbfcOkWUqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ittSaKI1uO2KJTgN72lmBFxjQtR5a4rmV3doIFVjiWFITIp2i74Ui5Qk6EefYMcgj
         mbj3UPbuIpXqVADhRbI1LJsO4XUjOhYEXlRtiquwF73UVtve9Rd7UekoSvzgQ9+RW8
         bJnEYOiKvg50CzywgNgrK0+in97SCeZxPzMyyFXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peiwei Hu <jlu.hpw@foxmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 481/599] media: ir_toy: free before error exiting
Date:   Tue,  5 Apr 2022 09:32:55 +0200
Message-Id: <20220405070313.141702132@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Peiwei Hu <jlu.hpw@foxmail.com>

[ Upstream commit 52cdb013036391d9d87aba5b4fc49cdfc6ea4b23 ]

Fix leak in error path.

Signed-off-by: Peiwei Hu <jlu.hpw@foxmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 1aa7989e756c..7f394277478b 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -429,7 +429,7 @@ static int irtoy_probe(struct usb_interface *intf,
 	err = usb_submit_urb(irtoy->urb_in, GFP_KERNEL);
 	if (err != 0) {
 		dev_err(irtoy->dev, "fail to submit in urb: %d\n", err);
-		return err;
+		goto free_rcdev;
 	}
 
 	err = irtoy_setup(irtoy);
-- 
2.34.1



