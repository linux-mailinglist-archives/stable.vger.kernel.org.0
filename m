Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDBB450BFF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhKORdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237862AbhKORai (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA5376329E;
        Mon, 15 Nov 2021 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996809;
        bh=vo6Lsvq4i+FGd3a0twRJRjQ948mnWJGLloR6+8Dz+r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nbivy3s85uH37H6xZaRxF4/MExxZbfIGXHG2fxD5F4dhoQ9EABzVPvLp6LQz7lkLn
         x1aM6iejx0NtxKRzOYMHRxeshcHY2hdw4L3CqDdYwvBQJMwZI1IGQiDpBHeZwZYvbp
         OpvGE1ltgdvkiNsqdVjmDHdzl1LMSX/oNbH4N6Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 274/355] usb: gadget: hid: fix error code in do_config()
Date:   Mon, 15 Nov 2021 18:03:18 +0100
Message-Id: <20211115165322.599568068@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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



