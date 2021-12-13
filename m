Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E3C4728F3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhLMKQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243803AbhLMKOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69ADC08ED7E;
        Mon, 13 Dec 2021 01:55:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2A790CE0DDE;
        Mon, 13 Dec 2021 09:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4EAC34602;
        Mon, 13 Dec 2021 09:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389307;
        bh=21jZ2UjaoRY0GsDWCdenTxNyfFIV+8Ddh9bEFDoktx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1UUfYMirbO1pD9z1p6vWenRjuXc2pkwa6NmYYkH3Pv3jjKJGZEVJLf8sPdITGPZP
         CD44+Qp4kwv9wqb1tdtce+/kEluPJq2gmyxciQnTlO7eKPiZW7LvV8gftD4+s29aq4
         hvWuzJ1dEb9kfxvqGAi3st8hTlNP9MAMdyExriGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ameer Hamza <amhamza.mgc@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 053/171] net: dsa: mv88e6xxx: error handling for serdes_power functions
Date:   Mon, 13 Dec 2021 10:29:28 +0100
Message-Id: <20211213092946.873870480@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ameer Hamza <amhamza.mgc@gmail.com>

commit 0416e7af2369b0d12a28dea8d30b104df9a6953d upstream.

Added default case to handle undefined cmode scenario in
mv88e6393x_serdes_power() and mv88e6393x_serdes_power() methods.

Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
Fixes: 21635d9203e1c (net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X)
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
Link: https://lore.kernel.org/r/20211209041552.9810-1-amhamza.mgc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -842,6 +842,9 @@ int mv88e6390_serdes_power(struct mv88e6
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
 		err = mv88e6390_serdes_power_10g(chip, lane, up);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (!err && up)
@@ -1541,6 +1544,9 @@ int mv88e6393x_serdes_power(struct mv88e
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (err)


