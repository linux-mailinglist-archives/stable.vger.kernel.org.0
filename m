Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABA3A6332
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhFNLL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234711AbhFNLGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C8D61926;
        Mon, 14 Jun 2021 10:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667530;
        bh=eqeihHTWHF6Qu3ZQpWRNZPeMqFh+DvbpQG4aY32zYsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHN9w1+a/OxK4sOUhl460kCciQAoXYasPHjMotCRh+I/5+rqjCYaeY0db4JQRQTas
         sDR5VfyNOZQGOrW55xzVqQ43FahBVFV2KMuTTQzegnmsMFPmRtlpIFo78sDoaD8F2e
         eVHgbZFxnz2wf4K/sriN06F8O+tG4YZw5Mjwo2nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 079/131] usb: typec: intel_pmc_mux: Add missed error check for devm_ioremap_resource()
Date:   Mon, 14 Jun 2021 12:27:20 +0200
Message-Id: <20210614102655.710732959@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
@@ -573,6 +573,11 @@ static int pmc_usb_probe_iom(struct pmc_
 		return -ENOMEM;
 	}
 
+	if (IS_ERR(pmc->iom_base)) {
+		put_device(&adev->dev);
+		return PTR_ERR(pmc->iom_base);
+	}
+
 	pmc->iom_adev = adev;
 
 	return 0;


