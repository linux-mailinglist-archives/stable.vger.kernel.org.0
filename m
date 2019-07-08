Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BD76244C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbfGHPZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388649AbfGHPZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:25:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B3A20665;
        Mon,  8 Jul 2019 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599540;
        bh=64V9h1K9sOO1/vFNR+nqekbcBPvH68uwg+pEVDOf8Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPKvA7nf1nLXFV8mRgNeUarJZ/0aleZka6iOwuej5FtH7Z9WbohroRIMTIwgxrrNH
         1JXIp2rh5CCNyQrpDRgK0fbvOs1318j5wCdL6TctpRava+I/REkhHJfvpOBeC9n5lO
         Ry9pvr7m1qaVs7wzifXoZb8HEZpuqqUPEjh2zXLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/56] tty: rocket: fix incorrect forward declaration of rp_init()
Date:   Mon,  8 Jul 2019 17:13:40 +0200
Message-Id: <20190708150523.944446224@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 423ea3255424b954947d167681b71ded1b8fca53 ]

Make the forward declaration actually match the real function
definition, something that previous versions of gcc had just ignored.

This is another patch to fix new warnings from gcc-9 before I start the
merge window pulls.  I don't want to miss legitimate new warnings just
because my system update brought a new compiler with new warnings.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/rocket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 070733ca94d5..32943afacffd 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -279,7 +279,7 @@ MODULE_PARM_DESC(pc104_3, "set interface types for ISA(PC104) board #3 (e.g. pc1
 module_param_array(pc104_4, ulong, NULL, 0);
 MODULE_PARM_DESC(pc104_4, "set interface types for ISA(PC104) board #4 (e.g. pc104_4=232,232,485,485,...");
 
-static int rp_init(void);
+static int __init rp_init(void);
 static void rp_cleanup_module(void);
 
 module_init(rp_init);
-- 
2.20.1



