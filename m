Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0229B8D977
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfHNRIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbfHNRIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 772B22084D;
        Wed, 14 Aug 2019 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802521;
        bh=hCgr0/7hadj/Z1Ak1ssKJSqfrRjV0yt0Iiv3obLQrfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyE9xSufYmW53wxmKRCu0+KElmWUbTDUFEzO1AokacUkDg7gsJZHNmyHPfy39iiP8
         uPoqVaT+9qJUcN7AjUbXEZUVE+vC2mfIWqBXKIChTzPvbcl7mA2g+cVCfiLS7Tt+TF
         eOrCfsZs6Kqq4xMG9M6rJ5T6rP+aS03XrQUXU+Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+199ea16c7f26418b4365@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 14/91] Input: usbtouchscreen - initialize PM mutex before using it
Date:   Wed, 14 Aug 2019 19:00:37 +0200
Message-Id: <20190814165750.373364516@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit b55d996f057bf2e7ba9422a80b5e17e99860cb0b upstream.

Mutexes shall be initialized before they are used.

Fixes: 12e510dbc57b2 ("Input: usbtouchscreen - fix deadlock in autosuspend")
Reported-by: syzbot+199ea16c7f26418b4365@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/usbtouchscreen.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -1672,6 +1672,8 @@ static int usbtouch_probe(struct usb_int
 	if (!usbtouch || !input_dev)
 		goto out_free;
 
+	mutex_init(&usbtouch->pm_mutex);
+
 	type = &usbtouch_dev_info[id->driver_info];
 	usbtouch->type = type;
 	if (!type->process_pkt)


