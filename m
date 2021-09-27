Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0397C419BBC
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhI0RVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236997AbhI0RTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4711F6120C;
        Mon, 27 Sep 2021 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762779;
        bh=9LRoE2px25O4HcnNQgzWjeuyz5NTiCYmeax5E52GbXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bnj1Kq3M9T5sqEQwl/8t9OiFEpz2qrnTTxBwFSLj2D4gaFNj9KFmrESYJ4/1nK0ps
         GGFt3cQYZoDK8Y9FL2HZuVFYw9C12qyRFAXNLmF8WeXg1YuVsF8jJJdtVH7V9Im5S9
         bVJ42Q9OIBkeX32U3vHpob3I1HwR1xbI4sCdY7zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 5.14 021/162] usb: isp1760: do not sleep in field register poll
Date:   Mon, 27 Sep 2021 19:01:07 +0200
Message-Id: <20210927170234.192519990@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

commit 41f673183862a183d4ea0522c045fabfbd1b28c8 upstream.

When polling for a setup or clear of a register field we were sleeping
in atomic context but using a very tight sleep interval.

Since the use cases for this poll mechanism are only in setup and
stop paths, and in practice this poll is not used most of the times
but needs to be there to comply to hardware setup times, remove the
sleep time and make the poll loop tighter.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/r/20210727100516.4190681-3-rui.silva@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/isp1760/isp1760-hcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/isp1760/isp1760-hcd.c
+++ b/drivers/usb/isp1760/isp1760-hcd.c
@@ -251,7 +251,7 @@ static int isp1760_hcd_set_and_wait(stru
 	isp1760_hcd_set(hcd, field);
 
 	return regmap_field_read_poll_timeout(priv->fields[field], val,
-					      val, 10, timeout_us);
+					      val, 0, timeout_us);
 }
 
 static int isp1760_hcd_set_and_wait_swap(struct usb_hcd *hcd, u32 field,
@@ -263,7 +263,7 @@ static int isp1760_hcd_set_and_wait_swap
 	isp1760_hcd_set(hcd, field);
 
 	return regmap_field_read_poll_timeout(priv->fields[field], val,
-					      !val, 10, timeout_us);
+					      !val, 0, timeout_us);
 }
 
 static int isp1760_hcd_clear_and_wait(struct usb_hcd *hcd, u32 field,
@@ -275,7 +275,7 @@ static int isp1760_hcd_clear_and_wait(st
 	isp1760_hcd_clear(hcd, field);
 
 	return regmap_field_read_poll_timeout(priv->fields[field], val,
-					      !val, 10, timeout_us);
+					      !val, 0, timeout_us);
 }
 
 static bool isp1760_hcd_is_set(struct usb_hcd *hcd, u32 field)


