Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C14383241
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241003AbhEQOqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239765AbhEQOk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:40:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DB326194B;
        Mon, 17 May 2021 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261139;
        bh=XmE/h6mxa1tGTjLYTwMQGr/iIbvAWN++PJsig3t2DFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwKCgTQHdo6ZnqHTW1rFJhkCue4qDuoSqDgEKEQ9vzG/W+d5l4koYB/IYyC7QOmcU
         5dU50fvUboaggphD9HE9IFAeYCNT9vEv4SNCBUJbF6xWalq80z65QmhyDr2nursWQx
         06nm/fmWv9WzFUAfvzdKgfYayZcsovvk0zTHd494=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Felipe Balbi <balbi@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 5.12 313/363] usb: dwc3: imx8mp: fix error return code in dwc3_imx8mp_probe()
Date:   Mon, 17 May 2021 16:02:59 +0200
Message-Id: <20210517140313.190624227@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 0b2b149e918f6dddb4ea53615551bf7bc131f875 upstream.

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 6dd2565989b4 ("usb: dwc3: add imx8mp dwc3 glue layer driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210508015310.1627-1-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -167,6 +167,7 @@ static int dwc3_imx8mp_probe(struct plat
 
 	dwc3_np = of_get_child_by_name(node, "dwc3");
 	if (!dwc3_np) {
+		err = -ENODEV;
 		dev_err(dev, "failed to find dwc3 core child\n");
 		goto disable_rpm;
 	}


