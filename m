Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0649A3836F6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245226AbhEQPiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242941AbhEQPgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE39F61CEB;
        Mon, 17 May 2021 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262396;
        bh=5JqOWewpSfjRjyDmUHVM+mU4K6QsgUlEZfEB6rZz/nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6iczzP87kpfnMZTq/tL9OU8iCKwXMEv5P4rObWjJiA/cIn1AgUFnm02NdNEZav1m
         cAj4A9gMiTJafWRQ8RTJEO/xKCKzFh+TtfnEn2NP5hooH6gI808pvb5mMir3bFO5Gx
         6gXfWFgcE5ya3+pGEpHT/VCvrSQeK22DYtwT7xXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 5.11 282/329] usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield
Date:   Mon, 17 May 2021 16:03:13 +0200
Message-Id: <20210517140311.642150134@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

commit 04357fafea9c7ed34525eb9680c760245c3bb958 upstream.

On Intel Merrifield LPM is causing host to reset port after a timeout.
By disabling LPM entirely this is prevented.

Fixes: 066c09593454 ("usb: dwc3: pci: Enable extcon driver for Intel Merrifield")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210425150947.5862-1-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -120,6 +120,7 @@ static const struct property_entry dwc3_
 	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u3_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
+	PROPERTY_ENTRY_BOOL("snps,usb2-gadget-lpm-disable"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };


