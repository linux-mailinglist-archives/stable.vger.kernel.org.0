Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0744045C3BA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345511AbhKXNmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350483AbhKXNkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056FD61872;
        Wed, 24 Nov 2021 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758639;
        bh=m5BwtAhOnaDAYw1zTd29HVLcSehLDcVN2KyVWfanMlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPnQs+LBgL5kgBaWEyNRYMrwAqZyg+EOc49X/nmRlLaCaS5zVeU/xvrmM5LRl1g/k
         bqK+ESCf3SI4DAAgn3iOqxexed213HRpLee/fg+vi4NboENzcKRafInUTWdiaXutlO
         e6QVvQIqMMvf310dpWNTwMMuj0EBz28NfQW5UaXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 135/154] parisc/sticon: fix reverse colors
Date:   Wed, 24 Nov 2021 12:58:51 +0100
Message-Id: <20211124115706.672276554@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
@@ -332,13 +332,13 @@ static u8 sticon_build_attr(struct vc_da
 			    bool blink, bool underline, bool reverse,
 			    bool italic)
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


