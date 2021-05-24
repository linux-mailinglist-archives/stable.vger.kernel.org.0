Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E686338EE2E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhEXPqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234661AbhEXPoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91AE86145F;
        Mon, 24 May 2021 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870569;
        bh=qhD0BZqeu27jr8v2vR77dTcRsazvYX0eWy1cx0Jai9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFr+mca4yqnowk88HKEU9JCdxUyZnuDFFYnWgzAVL44bPgqyUw71O5WrUxGbB1MIC
         y4jdzqX3jnm9T67nREERuidB7f4FE30qHeVid96Z3T7EsxJpwMKkzMa+Qeoks9mZE3
         EUBfPpQo0S9/qkkktNdREWgkyHX/RiUJvAhNVPjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 46/49] vgacon: Record video mode changes with VT_RESIZEX
Date:   Mon, 24 May 2021 17:25:57 +0200
Message-Id: <20210524152325.857253151@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d4d0ad57b3865795c4cde2fb5094c594c2e8f469 upstream.

Fix an issue with VGA console font size changes made after the initial
video text mode has been changed with a user tool like `svgatextmode'
calling the VT_RESIZEX ioctl.  As it stands in that case the original
screen geometry continues being used to validate further VT resizing.

Consequently when the video adapter is firstly reprogrammed from the
original say 80x25 text mode using a 9x16 character cell (720x400 pixel
resolution) to say 80x37 text mode and the same character cell (720x592
pixel resolution), and secondly the CRTC character cell updated to 9x8
(by loading a suitable font with the KD_FONT_OP_SET request of the
KDFONTOP ioctl), the VT geometry does not get further updated from 80x37
and only upper half of the screen is used for the VT, with the lower
half showing rubbish corresponding to whatever happens to be there in
the video memory that maps to that part of the screen.  Of course the
proportions change according to text mode geometries and font sizes
chosen.

Address the problem then, by updating the text mode geometry defaults
rather than checking against them whenever the VT is resized via a user
ioctl.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: e400b6ec4ede ("vt/vgacon: Check if screen resize request comes from userspace")
Cc: stable@vger.kernel.org # v2.6.24+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/vgacon.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1106,12 +1106,20 @@ static int vgacon_resize(struct vc_data
 	if ((width << 1) * height > vga_vram_size)
 		return -EINVAL;
 
+	if (user) {
+		/*
+		 * Ho ho!  Someone (svgatextmode, eh?) may have reprogrammed
+		 * the video mode!  Set the new defaults then and go away.
+		 */
+		screen_info.orig_video_cols = width;
+		screen_info.orig_video_lines = height;
+		vga_default_font_height = c->vc_font.height;
+		return 0;
+	}
 	if (width % 2 || width > screen_info.orig_video_cols ||
 	    height > (screen_info.orig_video_lines * vga_default_font_height)/
 	    c->vc_font.height)
-		/* let svgatextmode tinker with video timings and
-		   return success */
-		return (user) ? 0 : -EINVAL;
+		return -EINVAL;
 
 	if (con_is_visible(c) && !vga_is_gfx) /* who knows */
 		vgacon_doresize(c, width, height);


