Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CED5E9F5F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiIZKZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbiIZKXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:23:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849D9DEDD;
        Mon, 26 Sep 2022 03:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE33ACE10E9;
        Mon, 26 Sep 2022 10:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F7AC433D6;
        Mon, 26 Sep 2022 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187411;
        bh=LjL2pJ7jfJN9nliWkDI+Wueh5f4fUGrGKlyxUIDa3ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWru3uGTZtmIoPBfWBfQ//UB6zUJxezVdjNMwst+DmHX72t1xa2uFUXKdUMSkDhQW
         Pl97O1MIkx6RK25cb8VekikRpDCmqDBJ2K1ZJxYmUyQUfPf8c6fZKkQWOyBs+5N0Vp
         7DrpWbk+bPnO+YGNJCJbGoP1NUl+A8PZcDoP152Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 4.14 40/40] media: em28xx: initialize refcount before kref_get
Date:   Mon, 26 Sep 2022 12:12:08 +0200
Message-Id: <20220926100739.866179955@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit c08eadca1bdfa099e20a32f8fa4b52b2f672236d upstream.

The commit 47677e51e2a4("[media] em28xx: Only deallocate struct
em28xx after finishing all extensions") adds kref_get to many init
functions (e.g., em28xx_audio_init). However, kref_init is called too
late in em28xx_usb_probe, since em28xx_init_dev before will invoke
those init functions and call kref_get function. Then refcount bug
occurs in my local syzkaller instance.

Fix it by moving kref_init before em28xx_init_dev. This issue occurs
not only in dev but also dev->dev_next.

Fixes: 47677e51e2a4 ("[media] em28xx: Only deallocate struct em28xx after finishing all extensions")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[DP: drop changes related to dev->dev_next as second tuner functionality was added in 4.16]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3644,6 +3644,8 @@ static int em28xx_usb_probe(struct usb_i
 		goto err_free;
 	}
 
+	kref_init(&dev->ref);
+
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
@@ -3730,8 +3732,6 @@ static int em28xx_usb_probe(struct usb_i
 			dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
 
-	kref_init(&dev->ref);
-
 	request_modules(dev);
 
 	/*


