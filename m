Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF83CD9BC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245013AbhGSOb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244268AbhGSO3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A569761279;
        Mon, 19 Jul 2021 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707345;
        bh=cIocqr/2eWHLk60vDJlVXLyodDMmSPmNZkVuuqH7N/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AG8Om64SBTAWqcyWu2WS3IjTe41YaboDhVtUwjD/mfFIvcaKoNVdWJEHm32mlNMSp
         nLxbBULmT3mmWKIaEJHJ/qCPdIBzuOkmJfORdumEH7Vtkyr+xweke1LHBZJtvZBy06
         fCiefMmQVkCcnL+hLVrPCPNTAEdWpc0CSAS+onbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quat Le <quat.le@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 123/245] scsi: core: Retry I/O for Notify (Enable Spinup) Required error
Date:   Mon, 19 Jul 2021 16:51:05 +0200
Message-Id: <20210719144944.391209315@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quat Le <quat.le@oracle.com>

commit 104739aca4488909175e9e31d5cd7d75b82a2046 upstream.

If the device is power-cycled, it takes time for the initiator to transmit
the periodic NOTIFY (ENABLE SPINUP) SAS primitive, and for the device to
respond to the primitive to become ACTIVE. Retry the I/O request to allow
the device time to become ACTIVE.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210629155826.48441-1-quat.le@oracle.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Quat Le <quat.le@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_lib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -915,6 +915,7 @@ void scsi_io_completion(struct scsi_cmnd
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
+				case 0x11: /* notify (enable spinup) required */
 				case 0x14: /* space allocation in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;


