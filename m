Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E13119240
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfEISrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfEISrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6BB2184B;
        Thu,  9 May 2019 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427633;
        bh=AIFK3L+c1H4rIB8vBSH4Xb25UaW6efGxn2GKIhav6QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUATGymAjFGBDMd13SqDq97eWR20GrbbQRm5lCGV/CbqpDd7SP/MxJRyzXSXAuWW9
         WTE50eo0558mMHl1su3t/ac9/h6DCiIijvXkoOWU+JqQl+xLCWtr+0MHl4+XELmY3C
         5QYyd7XwgFWsgqbkxTWzqYIWxK7UZZJF6hp0oyJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>
Subject: [PATCH 4.19 05/66] staging: greybus: power_supply: fix prop-descriptor request size
Date:   Thu,  9 May 2019 20:41:40 +0200
Message-Id: <20190509181302.358228702@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 47830c1127ef166af787caf2f871f23089610a7f upstream.

Since moving the message buffers off the stack, the dynamically
allocated get-prop-descriptor request buffer is incorrectly sized due to
using the pointer rather than request-struct size when creating the
operation.

Fortunately, the pointer size is always larger than this one-byte
request, but this could still cause trouble on the remote end due to the
unexpected message size.

Fixes: 9d15134d067e ("greybus: power_supply: rework get descriptors")
Cc: stable <stable@vger.kernel.org>     # 4.9
Cc: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/greybus/power_supply.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/greybus/power_supply.c
+++ b/drivers/staging/greybus/power_supply.c
@@ -520,7 +520,7 @@ static int gb_power_supply_prop_descript
 
 	op = gb_operation_create(connection,
 				 GB_POWER_SUPPLY_TYPE_GET_PROP_DESCRIPTORS,
-				 sizeof(req), sizeof(*resp) + props_count *
+				 sizeof(*req), sizeof(*resp) + props_count *
 				 sizeof(struct gb_power_supply_props_desc),
 				 GFP_KERNEL);
 	if (!op)


