Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626541BCA79
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgD1StE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgD1SkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 173482076A;
        Tue, 28 Apr 2020 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099219;
        bh=0sOTq4s30ooeuz5sbfz4jOZfhxiqi4UmbeG8VQrVoww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WT1iPFX+mjgqv8Elp3qaDdgSuJzeaqekiamvVVegIh+i1k7rCRC8vaHY/snEp/Gpe
         v0nxggMBOEPTD7pCptoKbLHsds29Nn6CbnUapzF8epg4aTbOUIeWyR8KExiwWKP9o3
         ZciZkyaCn5IR/1A16UltmuVjOdVoumNehrnzjzxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4.19 116/131] vt: dont use kmalloc() for the unicode screen buffer
Date:   Tue, 28 Apr 2020 20:25:28 +0200
Message-Id: <20200428182239.834497789@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

commit 9a98e7a80f95378c9ee0c644705e3b5aa54745f1 upstream.

Even if the actual screen size is bounded in vc_do_resize(), the unicode
buffer is still a little more than twice the size of the glyph buffer
and may exceed MAX_ORDER down the kmalloc() path. This can be triggered
from user space.

Since there is no point having a physically contiguous buffer here,
let's avoid the above issue as well as reducing pressure on high order
allocations by using vmalloc() instead.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2003282214210.2671@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -81,6 +81,7 @@
 #include <linux/errno.h>
 #include <linux/kd.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/major.h>
 #include <linux/mm.h>
 #include <linux/console.h>
@@ -350,7 +351,7 @@ static struct uni_screen *vc_uniscr_allo
 	/* allocate everything in one go */
 	memsize = cols * rows * sizeof(char32_t);
 	memsize += rows * sizeof(char32_t *);
-	p = kmalloc(memsize, GFP_KERNEL);
+	p = vmalloc(memsize);
 	if (!p)
 		return NULL;
 
@@ -366,7 +367,7 @@ static struct uni_screen *vc_uniscr_allo
 
 static void vc_uniscr_set(struct vc_data *vc, struct uni_screen *new_uniscr)
 {
-	kfree(vc->vc_uni_screen);
+	vfree(vc->vc_uni_screen);
 	vc->vc_uni_screen = new_uniscr;
 }
 


