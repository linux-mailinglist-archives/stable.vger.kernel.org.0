Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38DB3837F1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbhEQPrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344815AbhEQPpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7CF613AE;
        Mon, 17 May 2021 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262636;
        bh=5JqOWewpSfjRjyDmUHVM+mU4K6QsgUlEZfEB6rZz/nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0bP5iP/ZTeAobbSlj8+ohiv+hkDaCS8+581YL0Nw311kSimCQJLsiw3lewtT33Ub
         LTjCDkv1PlO3MtruiP6we2y7TVdj4eZUJnhEWnGbAry6J2hN10SN8VegJoKfWTjpm3
         Rh9y5bcCIGJqYIVzoHJzO5VXqCKM4k9Mq74hm1eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 5.10 241/289] usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield
Date:   Mon, 17 May 2021 16:02:46 +0200
Message-Id: <20210517140313.275170593@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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


