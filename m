Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99773498AA7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbiAXTGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344745AbiAXTD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF78E60917;
        Mon, 24 Jan 2022 19:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76087C340EA;
        Mon, 24 Jan 2022 19:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051007;
        bh=jSDtslNoiyB+pHNp5QUV4hVr5+6MybxkHTQSJuJJGVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvI0O0zFGUWqImpC90FNfmZ4Xm9nKxuOlDY7vZcfbRKItk2XO8YxTm9FxgtlzOC13
         4+wFj+HX90SD+nLysz07rHCniPypnoOEd8Wc3UTSN5absEvsCMK/QqtQ6HyG4RAhv6
         dbgOXhleHjw+pjIKhBtwVtjBqk16N96HPknp71is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 024/186] media: cpia2: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:41:39 +0100
Message-Id: <20220124183937.898159368@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 10729be03327f53258cb196362015ad5c6eabe02 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: ab33d5071de7 ("V4L/DVB (3376): Add cpia2 camera support")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/cpia2/cpia2_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -559,7 +559,7 @@ static int write_packet(struct usb_devic
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	kfree(buf);
 	return ret;
@@ -591,7 +591,7 @@ static int read_packet(struct usb_device
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	if (ret >= 0)
 		memcpy(registers, buf, size);


