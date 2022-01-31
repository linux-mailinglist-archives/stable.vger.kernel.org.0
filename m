Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1D4A44BE
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359236AbiAaLcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379106AbiAaL3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BAAC06179A;
        Mon, 31 Jan 2022 03:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B76E60FF0;
        Mon, 31 Jan 2022 11:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE87BC340E8;
        Mon, 31 Jan 2022 11:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627952;
        bh=MHXlHwAP0nOuHl9xPnMSnywI5ytIcnBsXgjfK+SJr0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klNXfMov3mJZt+lIq3hd7suww9B5x4bHlzxWF+ctjUPEgx+T8y3vLfZRQ60S+iggr
         /3ymmnXn/R+4toehf3T9j2fqR7LwJnhZlHxcucNvpJak/+EbtxiJrXOrcog3MzCl0q
         2Ayn41N5V/DLFRZY6OPzvTTnS1nds0repUGPDtBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.16 077/200] usb: cdnsp: Fix segmentation fault in cdns_lost_power function
Date:   Mon, 31 Jan 2022 11:55:40 +0100
Message-Id: <20220131105236.188320509@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 79aa3e19fe8f5be30e846df8a436bfe306e8b1a6 upstream.

CDNSP driver read not initialized cdns->otg_v0_regs
which lead to segmentation fault. Patch fixes this issue.

Fixes: 2cf2581cd229 ("usb: cdns3: add power lost support for system resume")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220111090737.10345-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/drd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -483,11 +483,11 @@ int cdns_drd_exit(struct cdns *cdns)
 /* Indicate the cdns3 core was power lost before */
 bool cdns_power_is_lost(struct cdns *cdns)
 {
-	if (cdns->version == CDNS3_CONTROLLER_V1) {
-		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
+	if (cdns->version == CDNS3_CONTROLLER_V0) {
+		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
 			return true;
 	} else {
-		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
+		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
 			return true;
 	}
 	return false;


