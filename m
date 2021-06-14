Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3E53A6424
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhFNLVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234575AbhFNLS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB98361464;
        Mon, 14 Jun 2021 10:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667868;
        bh=cCXZivSBwiK1xWs6iMAz1t1q7PuAUzlQTxl/G1rfKxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LX8GNA/Dop2HenYkHrOchFCCAr41vQe0TBd1LGU0W+HwFZQR4wnFmymlO+XgErhUS
         j9E9a+Ly3WZotmy75RV8GvFes9e+gCQyzAsXm0iYWtL4O5g/lQVgScCslCYp1eav0v
         WieA9eGF+fHDf5od0XCrBVbuWpWeuqbUsALb+zCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.12 098/173] usb: typec: intel_pmc_mux: Add missed error check for devm_ioremap_resource()
Date:   Mon, 14 Jun 2021 12:27:10 +0200
Message-Id: <20210614102701.424401839@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

commit 843fabdd7623271330af07f1b7fbd7fabe33c8de upstream.

devm_ioremap_resource() can return an error, add missed check for it.

Fixes: 43d596e32276 ("usb: typec: intel_pmc_mux: Check the port status before connect")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210607205007.71458-2-andy.shevchenko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -586,6 +586,11 @@ static int pmc_usb_probe_iom(struct pmc_
 		return -ENOMEM;
 	}
 
+	if (IS_ERR(pmc->iom_base)) {
+		put_device(&adev->dev);
+		return PTR_ERR(pmc->iom_base);
+	}
+
 	pmc->iom_adev = adev;
 
 	return 0;


