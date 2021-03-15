Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4618533B7E6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhCOOBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232496AbhCON7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D2C264F60;
        Mon, 15 Mar 2021 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816771;
        bh=f/SalJyee8+GeT1xcSqOnFDZYd4raLachmV8vPv0UtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmXqu9Thkp81FwbZ6le0Zw8I+RQ974ABVCluArFm/AqKPYOvTSf9P5+UJ+cfKRsXm
         8WFEXX2APHbEzJkcGyqCuREtiE1yFJKbkVZY74ulUwIGyThOgHYA7JVkdoZlEE3QKa
         OaOtJ+YoIDH4WZrshFLpDwSbDOux1eL99gUfTtcg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.14 50/95] USB: gadget: u_ether: Fix a configfs return code
Date:   Mon, 15 Mar 2021 14:57:20 +0100
Message-Id: <20210315135741.919624690@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 650bf52208d804ad5ee449c58102f8dc43175573 upstream.

If the string is invalid, this should return -EINVAL instead of 0.

Fixes: 73517cf49bd4 ("usb: gadget: add RNDIS configfs options for class/subclass/protocol")
Cc: stable <stable@vger.kernel.org>
Acked-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YCqZ3P53yyIg5cn7@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether_configfs.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/u_ether_configfs.h
+++ b/drivers/usb/gadget/function/u_ether_configfs.h
@@ -172,12 +172,11 @@ out:									\
 						size_t len)		\
 	{								\
 		struct f_##_f_##_opts *opts = to_f_##_f_##_opts(item);	\
-		int ret;						\
+		int ret = -EINVAL;					\
 		u8 val;							\
 									\
 		mutex_lock(&opts->lock);				\
-		ret = sscanf(page, "%02hhx", &val);			\
-		if (ret > 0) {						\
+		if (sscanf(page, "%02hhx", &val) > 0) {			\
 			opts->_n_ = val;				\
 			ret = len;					\
 		}							\


