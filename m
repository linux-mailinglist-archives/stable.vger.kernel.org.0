Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391FFD9FD8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438280AbfJPV6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438276AbfJPV6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:49 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75C3321928;
        Wed, 16 Oct 2019 21:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263128;
        bh=RR3rpb/NWDOjZesUdv/4qJSanHshBDUM1P6TXdKXDcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCtyvcH5amPypjJfAUcInV18x+1DGPOF38T+14Hm5YzG0kMrHkLklvPAYIVKTulJc
         XP3tNQaGbJLtaoNwXtIaWwInWAA7vvORvvk1hjqOZvJfBsoDsMpcyzEch4QVBwivms
         nyjpNWrEJTElQvrDUdLVKXSCTpO8wKb2YeV4+BQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH 5.3 051/112] staging: vt6655: Fix memory leak in vt6655_probe
Date:   Wed, 16 Oct 2019 14:50:43 -0700
Message-Id: <20191016214857.295568959@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 80b15db5e1e9c3300de299b2d43d1aafb593e6ac upstream.

In vt6655_probe, if vnt_init() fails the cleanup code needs to be called
like other error handling cases. The call to device_free_info() is
added.

Fixes: 67013f2c0e58 ("staging: vt6655: mac80211 conversion add main mac80211 functions")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191004200319.22394-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6655/device_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1748,8 +1748,10 @@ vt6655_probe(struct pci_dev *pcid, const
 
 	priv->hw->max_signal = 100;
 
-	if (vnt_init(priv))
+	if (vnt_init(priv)) {
+		device_free_info(priv);
 		return -ENODEV;
+	}
 
 	device_print_info(priv);
 	pci_set_drvdata(pcid, priv);


