Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C588328EDC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241762AbhCATjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241951AbhCATaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF85964EBB;
        Mon,  1 Mar 2021 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620120;
        bh=26OWrAVrGMCTmUYU1gbnan0rK1oLBHFFIq1nAT5BP+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6VRbKkimvahMZSswHgcMNcqQqIkf0g0CUX2TpIwXlTg3yX8DlyNbNqy6vjdl/UDj
         x+6qUxsgvbBpaLNMJYIB4UKqSEJPSae4zdzU02C4VT5X+WsPwURlPfp2LxOmlWOedq
         wtYIAlw7CiwKV5ttjkjms1llwF3UCnn7eiVsHQYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 007/775] scsi: qla2xxx: Fix mailbox Ch erroneous error
Date:   Mon,  1 Mar 2021 17:02:55 +0100
Message-Id: <20210301161202.066931075@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 044c218b04503858ca4e17f61899c8baa0ae9ba1 upstream.

Mailbox Ch/dump ram extend expects mb register 10 to be set. If not
set/clear, firmware can pick up garbage from previous invocation of this
mailbox. Example: mctp dump can set mb10.  On subsequent flash read which
use mailbox cmd Ch, mb10 can retain previous value.

Link: https://lore.kernel.org/r/20210111093134.1206-6-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -202,6 +202,7 @@ qla24xx_dump_ram(struct qla_hw_data *ha,
 		wrt_reg_word(&reg->mailbox0, MBC_DUMP_RISC_RAM_EXTENDED);
 		wrt_reg_word(&reg->mailbox1, LSW(addr));
 		wrt_reg_word(&reg->mailbox8, MSW(addr));
+		wrt_reg_word(&reg->mailbox10, 0);
 
 		wrt_reg_word(&reg->mailbox2, MSW(LSD(dump_dma)));
 		wrt_reg_word(&reg->mailbox3, LSW(LSD(dump_dma)));
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4276,7 +4276,8 @@ qla2x00_dump_ram(scsi_qla_host_t *vha, d
 	if (MSW(addr) || IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM_EXTENDED;
 		mcp->mb[8] = MSW(addr);
-		mcp->out_mb = MBX_8|MBX_0;
+		mcp->mb[10] = 0;
+		mcp->out_mb = MBX_10|MBX_8|MBX_0;
 	} else {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM;
 		mcp->out_mb = MBX_0;


