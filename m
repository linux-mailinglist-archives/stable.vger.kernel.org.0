Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8635F1BCA80
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgD1St2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730479AbgD1SkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:40:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4084920575;
        Tue, 28 Apr 2020 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099214;
        bh=RatZWJj2molmVc4U4IIdVkhkfYTHFDUQlZN6Amy12T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StBqV7xzLX6pRiI/OFc4uasOEaSifzzzhGjg51qaiwZJQ9F9IaFn7cNWOyUFD5EhA
         C1AMTZARSQi+kdHiyoStVSWco9/fDXftmSGHxNX8Y7WwYa3dSzpIm8XuSqVvu/EPP9
         wOv7koMPH0qprkc8lhSOxp0IlyNCRrErDckBy5Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH 4.19 115/131] vt: dont hardcode the mem allocation upper bound
Date:   Tue, 28 Apr 2020 20:25:27 +0200
Message-Id: <20200428182239.702907674@linuxfoundation.org>
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

commit 2717769e204e83e65b8819c5e2ef3e5b6639b270 upstream.

The code in vc_do_resize() bounds the memory allocation size to avoid
exceeding MAX_ORDER down the kzalloc() call chain and generating a
runtime warning triggerable from user space. However, not only is it
unwise to use a literal value here, but MAX_ORDER may also be
configurable based on CONFIG_FORCE_MAX_ZONEORDER.
Let's use KMALLOC_MAX_SIZE instead.

Note that prior commit bb1107f7c605 ("mm, slab: make sure that
KMALLOC_MAX_SIZE will fit into MAX_ORDER") the KMALLOC_MAX_SIZE value
could not be relied upon.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2003281702410.2671@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1209,7 +1209,7 @@ static int vc_do_resize(struct tty_struc
 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
 		return 0;
 
-	if (new_screen_size > (4 << 20))
+	if (new_screen_size > KMALLOC_MAX_SIZE)
 		return -EINVAL;
 	newscreen = kzalloc(new_screen_size, GFP_USER);
 	if (!newscreen)


