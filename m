Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8774603EE2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiJSJWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiJSJVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D4D3C16F;
        Wed, 19 Oct 2022 02:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F143261807;
        Wed, 19 Oct 2022 09:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F0EC433D6;
        Wed, 19 Oct 2022 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170088;
        bh=9IY8itcj0UntKkJNFI/Iu3RvzWtyhrIob2EbC+YLLxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifqvi3Te3cGp3CQx6+NZ1Oao+aiG4jhHPvNmy7U44XpeLQIZnmRkgSbuKc1Wg7AW6
         IBProP9Uc5CWOe9o+CEz98Pq3P0eYcxnrzzle1AH0Ec8maYyDuVtB5a0NH7ASMLV7/
         ubcu2u7QzaIF+hIk3iPE41blr57xEyU2Jkoy11I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb25f85e5aa482864dc0@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Tommaso Merciai <tommaso.merciai@amarulasolution.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 486/862] media: airspy: fix memory leak in airspy probe
Date:   Wed, 19 Oct 2022 10:29:33 +0200
Message-Id: <20221019083311.448540730@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 23bc5eb55f8c9607965c20d9ddcc13cb1ae59568 ]

The commit ca9dc8d06ab6 ("media: airspy: respect the DMA coherency
 rules") moves variable buf from stack to heap, however, it only frees
buf in the error handling code, missing deallocation in the success
path.

Fix this by freeing buf in the success path since this variable does not
have any references in other code.

Fixes: ca9dc8d06ab6 ("media: airspy: respect the DMA coherency rules")
Reported-by: syzbot+bb25f85e5aa482864dc0@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolution.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/airspy/airspy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 240a7cc56777..7b1c40132555 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -1070,6 +1070,10 @@ static int airspy_probe(struct usb_interface *intf,
 				ret);
 		goto err_free_controls;
 	}
+
+	/* Free buf if success*/
+	kfree(buf);
+
 	dev_info(s->dev, "Registered as %s\n",
 			video_device_node_name(&s->vdev));
 	dev_notice(s->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
-- 
2.35.1



