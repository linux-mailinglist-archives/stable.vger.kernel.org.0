Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEAF2D6292
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391089AbgLJQx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391048AbgLJOg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 25/54] scsi: mpt3sas: Fix ioctl timeout
Date:   Thu, 10 Dec 2020 15:27:02 +0100
Message-Id: <20201210142603.268852705@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

commit 42f687038bcc34aa919e0e4c29b04e4cda3f6a79 upstream.

Commit c1a6c5ac4278 ("scsi: mpt3sas: For NVME device, issue a protocol
level reset") modified the ioctl path 'timeout' variable type to u8 from
unsigned long, limiting the maximum timeout value that the driver can
support to 255 seconds.

If the management application is requesting a higher value the resulting
timeout will be zero. The operation times out immediately and the ioctl
request fails.

Change datatype back to unsigned long.

Link: https://lore.kernel.org/r/20201125094838.4340-1-suganath-prabu.subramani@broadcom.com
Fixes: c1a6c5ac4278 ("scsi: mpt3sas: For NVME device, issue a protocol level reset")
Cc: <stable@vger.kernel.org> #v4.18+
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -650,7 +650,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPT
 	Mpi26NVMeEncapsulatedRequest_t *nvme_encap_request = NULL;
 	struct _pcie_device *pcie_device = NULL;
 	u16 smid;
-	u8 timeout;
+	unsigned long timeout;
 	u8 issue_reset;
 	u32 sz, sz_arg;
 	void *psge;


