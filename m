Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE01C13DA
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgEANdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbgEANde (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96A1F2068E;
        Fri,  1 May 2020 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340014;
        bh=13vhvx7c692PAJM9gk7L0KsDuCIQKgT3anH1uEiPt2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQNt6oebChE7mqsYGfoEKlfgmXYaYRx/5EPz06z70/M+Kr2EZw9uN4iL73tmAev9l
         L0nGgb3DdNQ+0zVV8J9a8CbSiesoI7lM4XcTyJwMsRz18sVpsCN7shuDEzUq2HV21r
         qzWGGCZAC1PjhGyrOSA9481bOJSwG467bXfZ71DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH 4.14 071/117] vt: dont hardcode the mem allocation upper bound
Date:   Fri,  1 May 2020 15:21:47 +0200
Message-Id: <20200501131553.523399758@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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
@@ -880,7 +880,7 @@ static int vc_do_resize(struct tty_struc
 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
 		return 0;
 
-	if (new_screen_size > (4 << 20))
+	if (new_screen_size > KMALLOC_MAX_SIZE)
 		return -EINVAL;
 	newscreen = kzalloc(new_screen_size, GFP_USER);
 	if (!newscreen)


