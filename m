Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0945BBF7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbhKXMZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244910AbhKXMYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD8C460295;
        Wed, 24 Nov 2021 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756091;
        bh=I3H8yzAtI8SujZBXtSUndW4JbdVuHlp/D7yI0ExIHTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=027oBbAVNQ1SoEM1R5rT7MtG2cIUBCkXO4uSWLKscYI1Q8RptBSRAlmkcbOnpPYfk
         2cB/qBAlu1NlAEI77kBC6O3p3qwHsCjH2XM8AdlcZ4NhhuVRMa6CFqRM5+Ji/bGX6D
         XtODTiNrblUnmiJGhoy+QJm0uww1cD3pbWASV7+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 125/207] usb: gadget: hid: fix error code in do_config()
Date:   Wed, 24 Nov 2021 12:56:36 +0100
Message-Id: <20211124115708.100454110@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index cccbb948821b2..a55d3761d777c 100644
--- a/drivers/usb/gadget/legacy/hid.c
+++ b/drivers/usb/gadget/legacy/hid.c
@@ -103,8 +103,10 @@ static int do_config(struct usb_configuration *c)
 
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



