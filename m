Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33649171DC5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbgB0OPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:15:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389226AbgB0OPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:15:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87F1246A0;
        Thu, 27 Feb 2020 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812906;
        bh=ZznlblGTBFbuds+Sph5WVVJsc6irhIrrzO9HTsUYnug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbvJnz1LXBS2hgxzpXxF8U70a0VJzEgo4XWxD3I1CWcnJ3bATzTzoUULyS/rfASP0
         +VRegD6f/GwIk35TMJs1YwVRYCw+fYa/IFxVxkf7Av/0qpTxyALl+0O+9jWcpzCtPK
         yNMYaa7GQ7KUgQZkLvRB99Hfia40ox5KvLEWNGoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.5 025/150] vt: fix scrollback flushing on background consoles
Date:   Thu, 27 Feb 2020 14:36:02 +0100
Message-Id: <20200227132236.554692580@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

commit 3f4ef485be9d54040b695f32ec76d0f1ea50bbf3 upstream.

Commit a6dbe4427559 ("vt: perform safe console erase in the right
order") provided fixes to an earlier commit by gathering all console
scrollback flushing operations in a function of its own. This includes
the invocation of vc_sw->con_switch() as previously done through a
update_screen() call. That commit failed to carry over the
con_is_visible() conditional though, as well as cursor handling, which
caused problems when "\e[3J" was written to a background console.

One could argue for preserving the call to update_screen(). However
this does far more than we need, and it is best to remove scrollback
assumptions from it. Instead let's gather the minimum needed to actually
perform scrollback flushing properly in that one place.

While at it, let's document the vc_sw->con_switch() side effect being
relied upon.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Reported-and-tested-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2001281205560.1655@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -936,10 +936,21 @@ static void flush_scrollback(struct vc_d
 	WARN_CONSOLE_UNLOCKED();
 
 	set_origin(vc);
-	if (vc->vc_sw->con_flush_scrollback)
+	if (vc->vc_sw->con_flush_scrollback) {
 		vc->vc_sw->con_flush_scrollback(vc);
-	else
+	} else if (con_is_visible(vc)) {
+		/*
+		 * When no con_flush_scrollback method is provided then the
+		 * legacy way for flushing the scrollback buffer is to use
+		 * a side effect of the con_switch method. We do it only on
+		 * the foreground console as background consoles have no
+		 * scrollback buffers in that case and we obviously don't
+		 * want to switch to them.
+		 */
+		hide_cursor(vc);
 		vc->vc_sw->con_switch(vc);
+		set_cursor(vc);
+	}
 }
 
 /*


