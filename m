Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756C63C4777
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhGLGcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235302AbhGLGa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0650461006;
        Mon, 12 Jul 2021 06:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071289;
        bh=perK1Rv+zcYzDbyBXsYGxkG7BhjZJdCvaulLMazwFmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWtx6u4m6rASfKFMVYW6ProaDy9jxPNJuHBzcwtzBQIKBF5eyYXRvghqeUg0pMSoj
         bRzVvtc0eZIDqMoLTYKuvNcF5dB7Lu21OyTXlQmoeoL60NLsno9IeFUtZsaEFboxxZ
         MX2fkVp/HvY1hXCi/GtIMrjtZPnCuhmCbMkdXqxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quat Le <quat.le@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 348/348] scsi: core: Retry I/O for Notify (Enable Spinup) Required error
Date:   Mon, 12 Jul 2021 08:12:12 +0200
Message-Id: <20210712060750.363169241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
@@ -762,6 +762,7 @@ static void scsi_io_completion_action(st
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
+				case 0x11: /* notify (enable spinup) required */
 				case 0x14: /* space allocation in progress */
 				case 0x1a: /* start stop unit in progress */
 				case 0x1b: /* sanitize in progress */


