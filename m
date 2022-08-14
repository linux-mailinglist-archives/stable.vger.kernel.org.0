Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7282659214C
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbiHNPgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240653AbiHNPfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424EB1CB33;
        Sun, 14 Aug 2022 08:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CAA7B80B83;
        Sun, 14 Aug 2022 15:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A2EC43143;
        Sun, 14 Aug 2022 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491038;
        bh=OIEXWfEWVldJFPuulknFHeZLnw4GjOwoPX3ngtDhBlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iic59+VYcCcco6AnFknvqX3NN3+8Je+NWhwwEuvCou0ciwD36B6/pe+3VZxZLpvPQ
         uWwrlng+O70lzHurk2nel9lAYD2u8oklcm2+yOwlaMVi5UX8oTvCrSvRZTbh7x7fyT
         vlbeRa70ZfYXTETK1+yKDc83DIzJp3hPvE/1s5CopfPflYI6NvUSKzazcISFqhpXdr
         z4lV+W4PfBHvSlHXvp4kPEk0ZITehIgVZEGw+ZV1wgisuItONtoxa5TmMVPWXjesrK
         gK9i9DkolDI9VDT4K3jvFAGj5ryXFqvMRZFK1fL3crajVaYFfqnNK20A7ixIp1y0zS
         CGN/i60zONKfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 08/56] usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info
Date:   Sun, 14 Aug 2022 11:29:38 -0400
Message-Id: <20220814153026.2377377-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit a725d0f6dfc5d3739d6499f30ec865305ba3544d ]

Likewise to the uvcvideo hostside driver, this patch is changing the
usb_request message of an non zero completion handler call from dev_info
to dev_warn.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220529223848.105914-4-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 4e4a7c312646..6fabdea0ddd6 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -258,7 +258,7 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 		break;
 
 	default:
-		uvcg_info(&video->uvc->func,
+		uvcg_warn(&video->uvc->func,
 			  "VS request completed with status %d.\n",
 			  req->status);
 		uvcg_queue_cancel(queue, 0);
-- 
2.35.1

