Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3494A40B3
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358454AbiAaK7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:59:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347215AbiAaK65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:58:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 508F3B82A5B;
        Mon, 31 Jan 2022 10:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C7DC340E8;
        Mon, 31 Jan 2022 10:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626735;
        bh=r7uyHTqwIEpWFXAEtLU0400+E6IKEBK6/CX5sFHCkmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBcKzo4A15bhqk1jwaHHAuif6ykuR5RI/VY2iPxk7/z+ZOA/yDZiMZBMjau9sDyW1
         MyZ6J78y+02QD4Y/KNkO2lK0FfIFsHZa4YlsE7Kb4/bTTmR2pCWSdoO938NZtcyMpp
         c18MnHjlzZNzIm7XsCm9aLTeQa9LQvJJBtsai+SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sing-Han Chen <singhanc@nvidia.com>,
        Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.4 22/64] ucsi_ccg: Check DEV_INT bit only when starting CCG4
Date:   Mon, 31 Jan 2022 11:56:07 +0100
Message-Id: <20220131105216.409342888@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sing-Han Chen <singhanc@nvidia.com>

commit 825911492eb15bf8bb7fb94bc0c0421fe7a6327d upstream.

CCGx clears Bit 0:Device Interrupt in the INTR_REG
if CCGx is reset successfully. However, there might
be a chance that other bits in INTR_REG are not
cleared due to internal data queued in PPM. This case
misleads the driver that CCGx reset failed.

The commit checks bit 0 in INTR_REG and ignores other
bits. The ucsi driver would reset PPM later.

Fixes: 247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sing-Han Chen <singhanc@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20220112094143.628610-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -304,7 +304,7 @@ static int ucsi_ccg_init(struct ucsi_ccg
 		if (status < 0)
 			return status;
 
-		if (!data)
+		if (!(data & DEV_INT))
 			return 0;
 
 		status = ccg_write(uc, CCGX_RAB_INTR_REG, &data, sizeof(data));


