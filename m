Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AFF45C172
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347239AbhKXNSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345768AbhKXNQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:16:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6082E61ADF;
        Wed, 24 Nov 2021 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757892;
        bh=3hASDUYPLjcaNZ3qvW+VwaDN0ZGKb2nxPc2pr74xnRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I27UupydoYsX7E4TR12W87CYQ/Cdf22MD0Y1KiycYdes3h5sDpHBDzPGkfwhaSBx7
         2shFoy1b40AJw0KKyX6L4rqYyRd/qyHoQmNaC4BIK87f1D+Q2viHBuiWu+rrlv56D4
         2RjuFIjO1RDFft6RFUCNWsYTz2WR3q6gi1LWxdBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 311/323] parisc/sticon: fix reverse colors
Date:   Wed, 24 Nov 2021 12:58:21 +0100
Message-Id: <20211124115729.427625105@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

commit bec05f33ebc1006899c6d3e59a00c58881fe7626 upstream.

sticon_build_attr() checked the reverse argument and flipped
background and foreground color, but returned the non-reverse
value afterwards. Fix this and also add two local variables
for foreground and background color to make the code easier
to read.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/sticon.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -291,13 +291,13 @@ static unsigned long sticon_getxy(struct
 static u8 sticon_build_attr(struct vc_data *conp, u8 color, u8 intens,
 			    u8 blink, u8 underline, u8 reverse, u8 italic)
 {
-    u8 attr = ((color & 0x70) >> 1) | ((color & 7));
+	u8 fg = color & 7;
+	u8 bg = (color & 0x70) >> 4;
 
-    if (reverse) {
-	color = ((color >> 3) & 0x7) | ((color & 0x7) << 3);
-    }
-
-    return attr;
+	if (reverse)
+		return (fg << 3) | bg;
+	else
+		return (bg << 3) | fg;
 }
 
 static void sticon_invert_region(struct vc_data *conp, u16 *p, int count)


