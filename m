Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D1DD7C2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfJSJpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 05:45:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbfJSJpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Oct 2019 05:45:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1364389F301;
        Sat, 19 Oct 2019 09:45:32 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4509B19481;
        Sat, 19 Oct 2019 09:45:30 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Hans de Goede <hdegoede@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] tpm: Switch to platform_get_irq_optional()
Date:   Sat, 19 Oct 2019 11:45:28 +0200
Message-Id: <20191019094528.27850-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Sat, 19 Oct 2019 09:45:32 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 7723f4c5ecdb ("driver core: platform: Add an error message to
platform_get_irq*()"), platform_get_irq() will call dev_err() on an error,
as the IRQ usage in the tpm_tis driver is optional, this is undesirable.

Specifically this leads to this new false-positive error being logged:
[    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found

This commit switches to platform_get_irq_optional(), which does not log
an error, fixing this.

Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index e4fdde93ed4c..e7df342a317d 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -286,7 +286,7 @@ static int tpm_tis_plat_probe(struct platform_device *pdev)
 	}
 	tpm_info.res = *res;
 
-	tpm_info.irq = platform_get_irq(pdev, 0);
+	tpm_info.irq = platform_get_irq_optional(pdev, 0);
 	if (tpm_info.irq <= 0) {
 		if (pdev != force_pdev)
 			tpm_info.irq = -1;
-- 
2.23.0

