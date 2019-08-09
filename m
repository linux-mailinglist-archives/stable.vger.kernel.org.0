Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E3687BC4
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407178AbfHINq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407157AbfHINq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F55521874;
        Fri,  9 Aug 2019 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358417;
        bh=Bll61FBxQFEAZ7jzNiAdReu8C4E77sdRKdifBhJ4bmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlsv9G6MuhFBr3zXmIqrQilQynDk8SQUYPHbpWhInyIDW+6R9B7svjNsXtZbFJgVC
         h3hke56vMjZITSNYC1knMIaZ/d4dFW/j6379UG1IjNYN+8e2FawaK5YuH2fPg5Jfcx
         8MtP0t8mh2iLO8D8RfICeFy56RUtoXOV6HF1+fYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 08/32] HID: wacom: fix bit shift for Cintiq Companion 2
Date:   Fri,  9 Aug 2019 15:45:11 +0200
Message-Id: <20190809133923.218536897@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Armstrong Skomra <skomra@gmail.com>

commit 693c3dab4e50403f91bca4b52fc6d8562a3180f6 upstream.

The bit indicating BTN_6 on this device is overshifted
by 2 bits, resulting in the incorrect button being
reported.

Also fix copy-paste mistake in comments.

Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Link: https://github.com/linuxwacom/xf86-input-wacom/issues/71
Fixes: c7f0522a1ad1 ("HID: wacom: Slim down wacom_intuos_pad processing")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -529,14 +529,14 @@ static int wacom_intuos_pad(struct wacom
 		 */
 		buttons = (data[4] << 1) | (data[3] & 0x01);
 	} else if (features->type == CINTIQ_COMPANION_2) {
-		/* d-pad right  -> data[4] & 0x10
-		 * d-pad up     -> data[4] & 0x20
-		 * d-pad left   -> data[4] & 0x40
-		 * d-pad down   -> data[4] & 0x80
-		 * d-pad center -> data[3] & 0x01
+		/* d-pad right  -> data[2] & 0x10
+		 * d-pad up     -> data[2] & 0x20
+		 * d-pad left   -> data[2] & 0x40
+		 * d-pad down   -> data[2] & 0x80
+		 * d-pad center -> data[1] & 0x01
 		 */
 		buttons = ((data[2] >> 4) << 7) |
-		          ((data[1] & 0x04) << 6) |
+		          ((data[1] & 0x04) << 4) |
 		          ((data[2] & 0x0F) << 2) |
 		          (data[1] & 0x03);
 	} else if (features->type >= INTUOS5S && features->type <= INTUOSPL) {


