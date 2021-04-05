Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C08353E67
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhDEJFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237878AbhDEJFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF44613A7;
        Mon,  5 Apr 2021 09:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613529;
        bh=PrvXvLexksylJ5hd1iSur2YhtvHzTqsiS9WEgISJ7Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z20R3dAwdigg/D2wSbxjHqIzKkVcJxdrH3HNi/HvNh4BzQtigX12rQZP2uAY8PFMZ
         n8paFEjhQ6M1+PiIQxg5zEvxZhlf1wz0GhM30unv7FHSyOnIAuNFQkmVd4RjzfVH+N
         7S64T3cEHM9xEGbBk9sqGyLtfkVe2CSB4351D96o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH 5.4 71/74] usb: dwc2: Prevent core suspend when port connection flag is 0
Date:   Mon,  5 Apr 2021 10:54:35 +0200
Message-Id: <20210405085027.047740968@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>

commit 93f672804bf2d7a49ef3fd96827ea6290ca1841e upstream.

In host mode port connection status flag is "0" when loading
the driver. After loading the driver system asserts suspend
which is handled by "_dwc2_hcd_suspend()" function. Before
the system suspend the port connection status is "0". As
result need to check the "port_connect_status" if it is "0",
then skipping entering to suspend.

Cc: <stable@vger.kernel.org> # 5.2
Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with DWC2_POWER_DOWN_PARAM_NONE")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210326102510.BDEDEA005D@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4322,7 +4322,8 @@ static int _dwc2_hcd_suspend(struct usb_
 	if (hsotg->op_state == OTG_STATE_B_PERIPHERAL)
 		goto unlock;
 
-	if (hsotg->params.power_down > DWC2_POWER_DOWN_PARAM_PARTIAL)
+	if (hsotg->params.power_down != DWC2_POWER_DOWN_PARAM_PARTIAL ||
+	    hsotg->flags.b.port_connect_status == 0)
 		goto skip_power_saving;
 
 	/*


