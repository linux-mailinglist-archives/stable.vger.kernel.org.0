Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB4927CDDA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733182AbgI2MrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbgI2LGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B8321D46;
        Tue, 29 Sep 2020 11:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377571;
        bh=9rCrCU/IlF42dXf6kWQ22ZRUzkR1Au7ZM8NK732koDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLN47IcCv+02TtMy39Ki5OQQeSkY6tqmy55VgoWoO3itK7B3l2D+TswXT8Cdkc7Ju
         glO3f4W0ko11rHnkiSlyZgBpidgodNt5eVwTlc+kXEWbX1OmAjRxqf77TOmRfQMuaN
         YfEZWCAEBmIiYbvriksi5NAnDqTKA/dzBzDjQHE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        linux-usb@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-fbdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.4 80/85] tty: vt, consw->con_scrolldelta cleanup
Date:   Tue, 29 Sep 2020 13:00:47 +0200
Message-Id: <20200929105932.191358795@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 97293de977365fe672daec2523e66ef457104921 upstream.

* allow NULL consw->con_scrolldelta (some consoles define an empty
  hook)
* => remove empty hooks now
* return value of consw->con_scrolldelta is never checked => make the
  function void
* document consw->con_scrolldelta a bit

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: linux-usb@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: Ajay Kaher <akaher@vmware.com>
[ for 4.4.y backport, only do the first change above, to prevent
.con_scrolldelta from being called if not present - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2484,7 +2484,7 @@ static void console_callback(struct work
 	if (scrollback_delta) {
 		struct vc_data *vc = vc_cons[fg_console].d;
 		clear_selection();
-		if (vc->vc_mode == KD_TEXT)
+		if (vc->vc_mode == KD_TEXT && vc->vc_sw->con_scrolldelta)
 			vc->vc_sw->con_scrolldelta(vc, scrollback_delta);
 		scrollback_delta = 0;
 	}


