Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7A4226420
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgGTPmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730042AbgGTPmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:42:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EBBA2176B;
        Mon, 20 Jul 2020 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259736;
        bh=Ii21Y4dB2dtPOuktMfoSercnM/W9406kERuSR4p265M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/TqHLLLbdeasWBOwtL5LOFu1m+3+tlivVvuw6nf9vBIuXtr/ohZJy0Qu7Q6KYDBe
         uh8TeFQcCJwVtxPJluFMvpJ6zY3znq+M7J8q0VnV9Mgox60vKu/yRBOEfd62uOG8ZF
         QapkVYeRFzeKsC6UHSYx5unEU2TOQcbxYJPGIMiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yariv <oigevald+kernel@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 60/86] HID: magicmouse: do not set up autorepeat
Date:   Mon, 20 Jul 2020 17:36:56 +0200
Message-Id: <20200720152756.196264399@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
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
@@ -451,6 +451,12 @@ static int magicmouse_setup_input(struct
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
 


