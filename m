Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694132C676D
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbgK0OGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 09:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbgK0OGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 09:06:16 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 317E320679;
        Fri, 27 Nov 2020 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606485975;
        bh=i1+M8KofmfCwcU8zE89Sq3P7NWZVu/Ox8h4dUwxC2kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKqGebrhcgDDIrrp8TSuYWEzD9Smik+hPN9iTfZaFWMA+nauI87Xt9/EWSx4HcQp1
         +y73N5VMw+QbwBVj+WNup+AsM7pZlJ8nxlrqhP8MXfnL85w8z8WBnrOJsqHaC3wkwR
         Eu6oRm+LTDVMXM1oVPp7cbnsiNlldJy4rJhIxhj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     balbi@kernel.org
Cc:     peter.chen@nxp.com, willmcvicker@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 2/5] USB: gadget: f_acm: add support for SuperSpeed Plus
Date:   Fri, 27 Nov 2020 15:05:56 +0100
Message-Id: <20201127140559.381351-3-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127140559.381351-1-gregkh@linuxfoundation.org>
References: <20201127140559.381351-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "taehyun.cho" <taehyun.cho@samsung.com>

Setup the SuperSpeed Plus descriptors for f_acm.  This allows the gadget
to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_acm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_acm.c b/drivers/usb/gadget/function/f_acm.c
index 46647bfac2ef..349945e064bb 100644
--- a/drivers/usb/gadget/function/f_acm.c
+++ b/drivers/usb/gadget/function/f_acm.c
@@ -686,7 +686,7 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 	acm_ss_out_desc.bEndpointAddress = acm_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, acm_fs_function, acm_hs_function,
-			acm_ss_function, NULL);
+			acm_ss_function, acm_ss_function);
 	if (status)
 		goto fail;
 
-- 
2.29.2

