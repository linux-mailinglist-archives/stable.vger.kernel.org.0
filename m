Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2937871C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhEJLNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235964AbhEJLHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF976162D;
        Mon, 10 May 2021 10:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644238;
        bh=BnQ2WjSQ5Q+TNsP6SxVor3xEFQL6n8L3r6/lM4WX5ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bawCVYpxq7MfriyLO8hLdnle5wYtbtg6n2RbyfrJ65bLBU1uxHbJlakAyZpskpVP6
         Uvt1cyzUX6h71R+ugkZIQzeScJ5MUaWZeO4woVZqp7MHAGYG0QryGkzg6NxfJGDP09
         8J6hQod5SIDZWSdK8X8A2f3qdblhBHS0tOyOlIOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dean Anderson <dean@sensoray.com>
Subject: [PATCH 5.11 324/342] usb: gadget/function/f_fs string table fix for multiple languages
Date:   Mon, 10 May 2021 12:21:54 +0200
Message-Id: <20210510102020.818049337@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Anderson <dean@sensoray.com>

commit 55b74ce7d2ce0b0058f3e08cab185a0afacfe39e upstream.

Fixes bug with the handling of more than one language in
the string table in f_fs.c.
str_count was not reset for subsequent language codes.
str_count-- "rolls under" and processes u32 max strings on
the processing of the second language entry.
The existing bug can be reproduced by adding a second language table
to the structure "strings" in tools/usb/ffs-test.c.

Signed-off-by: Dean Anderson <dean@sensoray.com>
Link: https://lore.kernel.org/r/20210317224109.21534-1-dean@sensoray.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2640,6 +2640,7 @@ static int __ffs_data_got_strings(struct
 
 	do { /* lang_count > 0 so we can use do-while */
 		unsigned needed = needed_count;
+		u32 str_per_lang = str_count;
 
 		if (len < 3)
 			goto error_free;
@@ -2675,7 +2676,7 @@ static int __ffs_data_got_strings(struct
 
 			data += length + 1;
 			len -= length + 1;
-		} while (--str_count);
+		} while (--str_per_lang);
 
 		s->id = 0;   /* terminator */
 		s->s = NULL;


