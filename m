Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AEC22685B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbgGTQS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388121AbgGTQNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8302064B;
        Mon, 20 Jul 2020 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261611;
        bh=KiPVoFkWqXoOMvSZ98d4FiJrMC62nVa/LYDq0eJYjQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBqQh9OHeUTI7BjPCFSVdGYsMGIQsntJyCRvnomwqud0ApVgKxpZZ5YsuLPjGulze
         u0Kcou1ellu/Ze99TYUBqfU5iXsEiEyghlTVTIhKc9jCgN4E8Qgf33TAi9+ZZT+aSV
         Ea1ypUuGOy+jygEQuNBtLXRIWxXe1ObbByLtv5r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yariv <oigevald+kernel@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.7 148/244] HID: magicmouse: do not set up autorepeat
Date:   Mon, 20 Jul 2020 17:36:59 +0200
Message-Id: <20200720152832.890892511@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 6363d2065cd399cf9d6dc9d08c437f8658831100 upstream.

Neither the trackpad, nor the mouse want input core to generate autorepeat
events for their buttons, so let's reset the bit (as hid-input sets it for
these devices based on the usage vendor code).

Cc: stable@vger.kernel.org
Reported-by: Yariv <oigevald+kernel@gmail.com>
Tested-by: Yariv <oigevald+kernel@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-magicmouse.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -535,6 +535,12 @@ static int magicmouse_setup_input(struct
 		__set_bit(MSC_RAW, input->mscbit);
 	}
 
+	/*
+	 * hid-input may mark device as using autorepeat, but neither
+	 * the trackpad, nor the mouse actually want it.
+	 */
+	__clear_bit(EV_REP, input->evbit);
+
 	return 0;
 }
 


