Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B013A9137
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390193AbfIDSOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390734AbfIDSOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0682087E;
        Wed,  4 Sep 2019 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620849;
        bh=42Ue3ROqGJcvhAgSPq8izBe8OHOarSjHQeq0zM3Nt3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YG1SKKNE3iIjbj6Og0mm2o8Qf3sqfay1h3kbn3WVneNLxUEYWUGh2afQdxIVLUnIY
         zugUDc9yyd/6KeumIkRkBrM1dltkfRv1Oqty96+l0BKM78SuuhvSem/Dw6nwRPgwvk
         xwtJmDM3zBGVozWGeO78BGFHmprZD1Q6R6Q6pMGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.2 101/143] typec: tcpm: fix a typo in the comparison of pdo_max_voltage
Date:   Wed,  4 Sep 2019 19:54:04 +0200
Message-Id: <20190904175318.269640830@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit a684d8fd87182090ee96e34519ecdf009cef093a upstream.

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
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1446,7 +1446,7 @@ static enum pdo_err tcpm_caps_err(struct
 				else if ((pdo_min_voltage(pdo[i]) ==
 					  pdo_min_voltage(pdo[i - 1])) &&
 					 (pdo_max_voltage(pdo[i]) ==
-					  pdo_min_voltage(pdo[i - 1])))
+					  pdo_max_voltage(pdo[i - 1])))
 					return PDO_ERR_DUPE_PDO;
 				break;
 			/*


