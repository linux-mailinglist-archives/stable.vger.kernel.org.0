Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8AA3A62EC
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhFNLGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235119AbhFNLEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A609C61921;
        Mon, 14 Jun 2021 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667499;
        bh=wxZ6nuSNY/Cfnc5zRh7hFW3LIgNWXwEOgOdjmfO6Q/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6LWAgJiziCJV39heeahPYkIuqHwDgQhR169dUqMMiE13OrIutnwSQvmEVgVTI7mz
         6SdByY+ZYhkIKCBMBHun6HTCrg5+si6OP6IWQ0eactQuKao4M+2xFCKynXUzXr2d0j
         sxw6XKM62c5L0X0+4WyyPCankrjgy9qsfcUQif6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 078/131] usb: typec: intel_pmc_mux: Put fwnode in error case during ->probe()
Date:   Mon, 14 Jun 2021 12:27:19 +0200
Message-Id: <20210614102655.680524233@linuxfoundation.org>
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

commit 1a85b350a7741776a406005b943e3dec02c424ed upstream.

device_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: 6701adfa9693 ("usb: typec: driver for Intel PMC mux control")
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210607205007.71458-1-andy.shevchenko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -623,8 +623,10 @@ static int pmc_usb_probe(struct platform
 			break;
 
 		ret = pmc_usb_register_port(pmc, i, fwnode);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			goto err_remove_ports;
+		}
 	}
 
 	platform_set_drvdata(pdev, pmc);


