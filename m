Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6755C6C7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbiF0LvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbiF0Ltu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5546E71;
        Mon, 27 Jun 2022 04:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D76FB61268;
        Mon, 27 Jun 2022 11:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4002C341C7;
        Mon, 27 Jun 2022 11:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330206;
        bh=iloeB/dZ6LP3VpD/hj6iCJ5H6/wOfIuWN46VZKW9bYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw36LNMgd22PpNhjC0VpUaDE9Y7HPqEhcbZ6f5hN9pMEIMFFK0c8BR/zwnC8iNKNe
         XxV5j6kCbeLpM6e/k8SowsB2/xXuJe4V+sRntPOrk2tg6dD5BpiypX0fUk1+aHVjBx
         lxfAWlQj+BeK4oJZAlB56hxzdxpnnmpaQABj2zM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.18 118/181] usb: gadget: uvc: fix list double add in uvcg_video_pump
Date:   Mon, 27 Jun 2022 13:21:31 +0200
Message-Id: <20220627111948.117853093@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Vacura <w36195@motorola.com>

commit 96163f835e65f8c9897487fac965819f0651d671 upstream.

A panic can occur if the endpoint becomes disabled and the
uvcg_video_pump adds the request back to the req_free list after it has
already been queued to the endpoint. The endpoint complete will add the
request back to the req_free list. Invalidate the local request handle
once it's been queued.

<6>[  246.796704][T13726] configfs-gadget gadget: uvc: uvc_function_set_alt(1, 0)
<3>[  246.797078][   T26] list_add double add: new=ffffff878bee5c40, prev=ffffff878bee5c40, next=ffffff878b0f0a90.
<6>[  246.797213][   T26] ------------[ cut here ]------------
<2>[  246.797224][   T26] kernel BUG at lib/list_debug.c:31!
<6>[  246.807073][   T26] Call trace:
<6>[  246.807180][   T26]  uvcg_video_pump+0x364/0x38c
<6>[  246.807366][   T26]  process_one_work+0x2a4/0x544
<6>[  246.807394][   T26]  worker_thread+0x350/0x784
<6>[  246.807442][   T26]  kthread+0x2ac/0x320

Fixes: f9897ec0f6d3 ("usb: gadget: uvc: only pump video data if necessary")
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Link: https://lore.kernel.org/r/20220617163154.16621-1-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -415,6 +415,9 @@ static void uvcg_video_pump(struct work_
 			uvcg_queue_cancel(queue, 0);
 			break;
 		}
+
+		/* Endpoint now owns the request */
+		req = NULL;
 		video->req_int_count++;
 	}
 


