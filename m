Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877503C4708
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhGLGbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235995AbhGLG3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6567061245;
        Mon, 12 Jul 2021 06:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071195;
        bh=GlYp8JQn9d6UBv7sFP6zPMo/MIfx+vAG2YlGlHpHkw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hqn5bJJqP95EY3BqXJsInFZQI8e0fycpAMrq5I5NGglaOy7lzdkNWfMdK/A12y3Ss
         yyBjOpm9CNMr34A9DAQUQP+q7WfnMGqHRjtFibNl1SgNTXbfinEI5uvdhn6IGvnIXO
         goFS54jx7+xXWbxVUgXbHn2N7vZe8vI8AXCRrLjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 316/348] staging: rtl8712: remove redundant check in r871xu_drv_init
Date:   Mon, 12 Jul 2021 08:11:40 +0200
Message-Id: <20210712060745.916503123@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 69d998f1e552f6e2e7b55f5058ce1ac7a72903f9 ]

padapter->dvobj_init is initialized rigth before
initialization check. There is no need for any
branching here.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/d367e5f39f22af44c545f8710cc18fb00f10e66c.1623620630.git.paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/usb_intf.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 2fcd65260f4c..bc421925e84c 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -380,13 +380,11 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	/* step 3.
 	 * initialize the dvobj_priv
 	 */
-	if (!padapter->dvobj_init) {
+
+	status = padapter->dvobj_init(padapter);
+	if (status != _SUCCESS)
 		goto error;
-	} else {
-		status = padapter->dvobj_init(padapter);
-		if (status != _SUCCESS)
-			goto error;
-	}
+
 	/* step 4. */
 	status = r8712_init_drv_sw(padapter);
 	if (status)
-- 
2.30.2



