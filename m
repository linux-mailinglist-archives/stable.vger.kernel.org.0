Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F9828958
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390326AbfEWTen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391614AbfEWT1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E412D2054F;
        Thu, 23 May 2019 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639656;
        bh=wo0rAbH0ZJ53UEuPAxfUCnXzx11Ia4RZgA1x+PQCU40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJJoOyW5XXHLHThoHtl8YOfbhwpzJenei1aFI027b8jtjRmWx+LkXkxWbYjXXFY9o
         YoXnFoLOBRS7Mvrx+98nWhzE0V4ecA1C3v6CEYbP0vyxskQipkxKFVqTyvmecT6TLn
         wrCn9gUX1bp5M2JyNRaWwdDwKELFEGsEl906I27o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.1 030/122] parisc: Allow live-patching of __meminit functions
Date:   Thu, 23 May 2019 21:05:52 +0200
Message-Id: <20190523181708.832938862@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit d19a12906e5e558c0f6b6cfece7b7caf1012ef95 upstream.

When making the text sections writeable with set_kernel_text_rw(1),
include all text sections including those in the __init section.
Otherwise functions marked with __meminit will stay read-only.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>	# 4.20+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -495,7 +495,7 @@ static void __init map_pages(unsigned lo
 
 void __init set_kernel_text_rw(int enable_read_write)
 {
-	unsigned long start = (unsigned long) _text;
+	unsigned long start = (unsigned long) __init_begin;
 	unsigned long end   = (unsigned long) &data_start;
 
 	map_pages(start, __pa(start), end-start,


