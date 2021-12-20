Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7896047AE6A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbhLTPBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47588 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbhLTO5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:57:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AB36611C8;
        Mon, 20 Dec 2021 14:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3FEC36AE9;
        Mon, 20 Dec 2021 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012220;
        bh=ryrD61VgsU7jY9+QdctlxBe2PRJnPS3Ma3LYzPDuV+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WC1nkIUJlwB56GvU3VPse4AqkT+A5ZzvrHwpkxBE7jxoIfLJiXEj58OIVuvhZyRpi
         Ib6yygPDQtn+VHnv2e/76pmcknoAW/pYvCfi18HOGNjhMqpLzMmibdlj7UlLmtsaqM
         oCa4G5CvU+EF+/CLRTC+woI2G6w7TyXvUxQTSuuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ken (Jian) He" <jianhe@ambarella.com>,
        Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 123/177] usb: cdnsp: Fix incorrect status for control request
Date:   Mon, 20 Dec 2021 15:34:33 +0100
Message-Id: <20211220143044.221672296@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 99ea221f2e2f2743314e348b25c1e2574b467528 upstream.

Patch fixes incorrect status for control request.
Without this fix all usb_request objects were returned to upper drivers
with usb_reqest->status field set to -EINPROGRESS.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20211207091838.39572-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct
 		return;
 	}
 
+	*status = 0;
+
 	cdnsp_finish_td(pdev, td, event, pep, status);
 }
 


