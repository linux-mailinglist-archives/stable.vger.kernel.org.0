Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E293745C0AE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347580AbhKXNKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348360AbhKXNJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4587613AC;
        Wed, 24 Nov 2021 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757622;
        bh=vo6Lsvq4i+FGd3a0twRJRjQ948mnWJGLloR6+8Dz+r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoQTFtHl+ywqe4y0h0lGqJFp3yxuLnxYVCY77NF3oJQg2w9dxOQnFdm8kO9rg2/mt
         xsqfehiO0l3Ex8ylwAhAsQlxPP+72KQHzSVU00Qq144e2AhCHQxKRkc4fru+FTAMl8
         TpDjJYdXYu/cltGoN5ZCGa32Lg1e4ubMAJPKoip8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/323] usb: gadget: hid: fix error code in do_config()
Date:   Wed, 24 Nov 2021 12:56:20 +0100
Message-Id: <20211124115725.353621785@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 68e7c510fdf4f6167404609da52e1979165649f6 ]

Return an error code if usb_get_function() fails.  Don't return success.

Fixes: 4bc8a33f2407 ("usb: gadget: hid: convert to new interface of f_hid")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211011123739.GC15188@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/hid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/hid.c b/drivers/usb/gadget/legacy/hid.c
index 5b27d289443fe..3912cc805f3af 100644
--- a/drivers/usb/gadget/legacy/hid.c
+++ b/drivers/usb/gadget/legacy/hid.c
@@ -99,8 +99,10 @@ static int do_config(struct usb_configuration *c)
 
 	list_for_each_entry(e, &hidg_func_list, node) {
 		e->f = usb_get_function(e->fi);
-		if (IS_ERR(e->f))
+		if (IS_ERR(e->f)) {
+			status = PTR_ERR(e->f);
 			goto put;
+		}
 		status = usb_add_function(c, e->f);
 		if (status < 0) {
 			usb_put_function(e->f);
-- 
2.33.0



