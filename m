Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1D333B9D2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhCOOGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233191AbhCOOBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B9E64EF8;
        Mon, 15 Mar 2021 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816909;
        bh=FTAwELuj2EcQRMLn9mlwt2MunR7r3AyeDut4nIGaRjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rC7qsszv565+rLEVBc1n2GeCQ18P+X852i5FA3EmbNTO7CqP5a/wodkVl9rVVGx40
         7G1X9EUsyfxSSfULBUH0XRNg6BQIU1j+aDEJCOYGEymdllHGJdqDIqIFqlh/V+3NEM
         QTwQEGESqB2uQE+QCs0A8ylT8SclImH3aPo6GE60=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.11 195/306] USB: gadget: u_ether: Fix a configfs return code
Date:   Mon, 15 Mar 2021 14:54:18 +0100
Message-Id: <20210315135514.221199882@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
@@ -169,12 +169,11 @@ out:									\
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


