Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15026ECDF6
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjDXN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjDXN2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD606A6F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FD2861D4A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83797C433D2;
        Mon, 24 Apr 2023 13:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342874;
        bh=Fd67DUmgcp3dcXuG3HRyaJFLs/SAgMjAeeVxLaWDe34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XReUt/lbRJURydsBjxZVRnLBsPK0ywDMoKc5VwgXYSzKFiVrbpx1iIMpNNJmUdooi
         5UDWtDdb0ymOLVbc1/F6kLkI242CD9IkIaTbQKLS75nkOOJyaKcDf+jjAkZovBDyWh
         zXIFyWgihGqrQeY014kUPhC3XjFcPNdlSSIjejfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Soumya Negi <soumya.negi97@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        syzbot+04ee0cb4caccaed12d78@syzkaller.appspotmail.com
Subject: [PATCH 6.1 91/98] Input: pegasus-notetaker - check pipe type when probing
Date:   Mon, 24 Apr 2023 15:17:54 +0200
Message-Id: <20230424131137.423613827@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soumya Negi <soumya.negi97@gmail.com>

commit b3d80fd27a3c2d8715a40cbf876139b56195f162 upstream.

Fix WARNING in pegasus_open/usb_submit_urb
Syzbot bug: https://syzkaller.appspot.com/bug?id=bbc107584dcf3262253ce93183e51f3612aaeb13

Warning raised because pegasus_driver submits transfer request for
bogus URB (pipe type does not match endpoint type). Add sanity check at
probe time for pipe value extracted from endpoint descriptor. Probe
will fail if sanity check fails.

Reported-and-tested-by: syzbot+04ee0cb4caccaed12d78@syzkaller.appspotmail.com
Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
Link: https://lore.kernel.org/r/20230404074145.11523-1-soumya.negi97@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/tablet/pegasus_notetaker.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/tablet/pegasus_notetaker.c
+++ b/drivers/input/tablet/pegasus_notetaker.c
@@ -296,6 +296,12 @@ static int pegasus_probe(struct usb_inte
 	pegasus->intf = intf;
 
 	pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
+	/* Sanity check that pipe's type matches endpoint's type */
+	if (usb_pipe_type_check(dev, pipe)) {
+		error = -EINVAL;
+		goto err_free_mem;
+	}
+
 	pegasus->data_len = usb_maxpacket(dev, pipe);
 
 	pegasus->data = usb_alloc_coherent(dev, pegasus->data_len, GFP_KERNEL,


