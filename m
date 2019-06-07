Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1708039050
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731420AbfFGPvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732274AbfFGPvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:51:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B65A2146E;
        Fri,  7 Jun 2019 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922663;
        bh=xOFzgDzIJd+HZd+bR7YkJZ9x9WUvI8zhPy1SBcGADjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vogjOTqmgVa/8nhVBuUATRdQNtGxhMTDvNkM7qzrgJY0tKyuH+dcAK/lPVTwBmEQ1
         /JCqjyoXmtNjm3rsQLV8VCVypUOEqjwQtrDYN83ko72alj295yLF5vuhzyho5vi0pG
         pOV3/wBn0nMyk8FqvjsWeHN0YXLKnTQwnH9Ea6UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Halat <ghalat@redhat.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.1 63/85] vt/fbcon: deinitialize resources in visual_init() after failed memory allocation
Date:   Fri,  7 Jun 2019 17:39:48 +0200
Message-Id: <20190607153856.346128456@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
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
@@ -1056,6 +1056,13 @@ static void visual_init(struct vc_data *
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
@@ -1103,6 +1110,7 @@ int vc_allocate(unsigned int currcons)	/
 
 	return 0;
 err_free:
+	visual_deinit(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return -ENOMEM;
@@ -1331,9 +1339,8 @@ struct vc_data *vc_deallocate(unsigned i
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
@@ -1248,7 +1248,7 @@ finished:
 	if (free_font)
 		vc->vc_font.data = NULL;
 
-	if (vc->vc_hi_font_mask)
+	if (vc->vc_hi_font_mask && vc->vc_screenbuf)
 		set_vc_hi_font(vc, false);
 
 	if (!con_is_bound(&fb_con))


