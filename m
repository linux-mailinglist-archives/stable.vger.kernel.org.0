Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9293C47FEF4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhL0PeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbhL0Pdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48DFC06175B;
        Mon, 27 Dec 2021 07:33:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85EC76104C;
        Mon, 27 Dec 2021 15:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEE6C36AE7;
        Mon, 27 Dec 2021 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619216;
        bh=JRLEknULjTL2TIusauV1Ss/yCzoJcLXfpCqo9qBgZac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7Od4yLl0DabNr7NfRNFy9xG2nlxSOufaXMqJq7iiicDWFmc/abg071zxlaWvIhB6
         wXhN7hyK+u2SRCxj2OXF9JWQJb/1eEYDqIyWbaGtSVcCzkNWVPpdgQ/lSX3b8jd3EE
         i2qclPSqzP0lNkWfM1QzPmQw9gKBvozqzMIzMfT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 33/38] Input: i8042 - enable deferred probe quirk for ASUS UM325UA
Date:   Mon, 27 Dec 2021 16:31:10 +0100
Message-Id: <20211227151320.486601011@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Čavoj <samuel@cavoj.net>

commit 44ee250aeeabb28b52a10397ac17ffb8bfe94839 upstream.

The ASUS UM325UA suffers from the same issue as the ASUS UX425UA, which
is a very similar laptop. The i8042 device is not usable immediately
after boot and fails to initialize, requiring a deferred retry.

Enable the deferred probe quirk for the UM325UA.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190256
Signed-off-by: Samuel Čavoj <samuel@cavoj.net>
Link: https://lore.kernel.org/r/20211204015615.232948-1-samuel@cavoj.net
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -996,6 +996,13 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "C504"),
 		},
 	},
+	{
+		/* ASUS ZenBook UM325UA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+		},
+	},
 	{ }
 };
 


