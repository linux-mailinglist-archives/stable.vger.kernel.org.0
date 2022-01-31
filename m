Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9B74A425F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359574AbiAaLLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42274 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376914AbiAaLJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 436416102A;
        Mon, 31 Jan 2022 11:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EC4C340E8;
        Mon, 31 Jan 2022 11:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627359;
        bh=MHXlHwAP0nOuHl9xPnMSnywI5ytIcnBsXgjfK+SJr0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR2toczDXb3iK81JvxaYKAb4oD/z3/+rosvJEd+julmtozjq+4yj49fHhcqmIOZgN
         It3G02GGuA3TDTL6d4xz7NwCKmP1DcsQemduJo8FdQZzmmRPF6MNb6MHpwyMe6R0gN
         yESrvioiTk2PLfFxkfXLoYwXOOcupjFR8lmTkZ0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 057/171] usb: cdnsp: Fix segmentation fault in cdns_lost_power function
Date:   Mon, 31 Jan 2022 11:55:22 +0100
Message-Id: <20220131105231.953701145@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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


