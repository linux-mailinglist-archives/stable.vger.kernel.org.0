Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06951A0BCF
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfH1Us6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfH1Us6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:48:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F335C2189D;
        Wed, 28 Aug 2019 20:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567025337;
        bh=4bhfb4iDI7/UZxPJteKxKe9NQf+fDNK3cOYQ+DWdqcI=;
        h=Subject:To:From:Date:From;
        b=wifPsEr5l4YnaZVBE8CWNZsG2RQQEAuJ/+s9baSLbSQTQm8562y2kiF6oKG8g+pFE
         kt0B6e5LVNDTi3HREcEMZ3fmcQeQilFLadeZiYAvIQfqbD2/vKiNnbgQ9KV6dOTI9A
         URrkd/+gwrCtSSQx4IBQwykhpq/UXMNcnnSWwoAY=
Subject: patch "typec: tcpm: fix a typo in the comparison of pdo_max_voltage" added to usb-linus
To:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:48:55 +0200
Message-ID: <156702533523127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    typec: tcpm: fix a typo in the comparison of pdo_max_voltage

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a684d8fd87182090ee96e34519ecdf009cef093a Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Thu, 22 Aug 2019 14:52:12 +0100
Subject: typec: tcpm: fix a typo in the comparison of pdo_max_voltage

There appears to be a typo in the comparison of pdo_max_voltage[i]
with the previous value, currently it is checking against the
array pdo_min_voltage rather than pdo_max_voltage. I believe this
is a typo. Fix this.

Addresses-Coverity: ("Copy-paste error")
Fixes: 5007e1b5db73 ("typec: tcpm: Validate source and sink caps")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20190822135212.10195-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 15abe1d9958f..bcfdb55fd198 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1446,7 +1446,7 @@ static enum pdo_err tcpm_caps_err(struct tcpm_port *port, const u32 *pdo,
 				else if ((pdo_min_voltage(pdo[i]) ==
 					  pdo_min_voltage(pdo[i - 1])) &&
 					 (pdo_max_voltage(pdo[i]) ==
-					  pdo_min_voltage(pdo[i - 1])))
+					  pdo_max_voltage(pdo[i - 1])))
 					return PDO_ERR_DUPE_PDO;
 				break;
 			/*
-- 
2.23.0


