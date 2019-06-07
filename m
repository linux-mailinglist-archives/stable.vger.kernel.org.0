Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93846390E0
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfFGPp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731229AbfFGPp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67BFA2147A;
        Fri,  7 Jun 2019 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922326;
        bh=6sCJXvJ69TniPuY2wU4isPT7eKmXmwixLUZhU5Wi9r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRAwVGWBDvs7ohUKXqAwm8GPe8RYi0KaZrTsc46O7U1Qbcfw9+BLBs9jbnD1aIcX0
         r5PDgvsbLPwsQ2hqz/WApPcRgpVX7gxIY4pM2+dEUJUN7ieR0eDvlOVKb7YRzMclgH
         /6qWj7Sl0VF0yV6ttqJSac8QJ8x3vcfOfdQzYGzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Halat <ghalat@redhat.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.19 48/73] vt/fbcon: deinitialize resources in visual_init() after failed memory allocation
Date:   Fri,  7 Jun 2019 17:39:35 +0200
Message-Id: <20190607153854.502883153@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Halat <ghalat@redhat.com>

commit a1ad1cc9704f64c169261a76e1aee1cf1ae51832 upstream.

After memory allocation failure vc_allocate() doesn't clean up data
which has been initialized in visual_init(). In case of fbcon this
leads to divide-by-0 in fbcon_init() on next open of the same tty.

memory allocation in vc_allocate() may fail here:
1097:     vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_KERNEL);

on next open() fbcon_init() skips vc_font.data initialization:
1088:     if (!p->fontdata) {

division by zero in fbcon_init() happens here:
1149:     new_cols /= vc->vc_font.width;

Additional check is needed in fbcon_deinit() to prevent
usage of uninitialized vc_screenbuf:

1251:        if (vc->vc_hi_font_mask && vc->vc_screenbuf)
1252:                set_vc_hi_font(vc, false);

Crash:

 #6 [ffffc90001eafa60] divide_error at ffffffff81a00be4
    [exception RIP: fbcon_init+463]
    RIP: ffffffff814b860f  RSP: ffffc90001eafb18  RFLAGS: 00010246
...
 #7 [ffffc90001eafb60] visual_init at ffffffff8154c36e
 #8 [ffffc90001eafb80] vc_allocate at ffffffff8154f53c
 #9 [ffffc90001eafbc8] con_install at ffffffff8154f624
...

Signed-off-by: Grzegorz Halat <ghalat@redhat.com>
Reviewed-by: Oleksandr Natalenko <oleksandr@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c              |   11 +++++++++--
 drivers/video/fbdev/core/fbcon.c |    2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1059,6 +1059,13 @@ static void visual_init(struct vc_data *
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
 }
 
+
+static void visual_deinit(struct vc_data *vc)
+{
+	vc->vc_sw->con_deinit(vc);
+	module_put(vc->vc_sw->owner);
+}
+
 int vc_allocate(unsigned int currcons)	/* return 0 on success */
 {
 	struct vt_notifier_param param;
@@ -1106,6 +1113,7 @@ int vc_allocate(unsigned int currcons)	/
 
 	return 0;
 err_free:
+	visual_deinit(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return -ENOMEM;
@@ -1334,9 +1342,8 @@ struct vc_data *vc_deallocate(unsigned i
 		param.vc = vc = vc_cons[currcons].d;
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vcs_remove_sysfs(currcons);
-		vc->vc_sw->con_deinit(vc);
+		visual_deinit(vc);
 		put_pid(vc->vt_pid);
-		module_put(vc->vc_sw->owner);
 		vc_uniscr_set(vc, NULL);
 		kfree(vc->vc_screenbuf);
 		vc_cons[currcons].d = NULL;
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1237,7 +1237,7 @@ finished:
 	if (free_font)
 		vc->vc_font.data = NULL;
 
-	if (vc->vc_hi_font_mask)
+	if (vc->vc_hi_font_mask && vc->vc_screenbuf)
 		set_vc_hi_font(vc, false);
 
 	if (!con_is_bound(&fb_con))


