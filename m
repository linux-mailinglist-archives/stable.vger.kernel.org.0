Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16B011DDE
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfEBPfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbfEBPdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:33:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636802081C;
        Thu,  2 May 2019 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811185;
        bh=/E2o9HfPxvjrRe7PG7NksRFjzd9aZsD5DVnngzJger0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQrLBKNI2aKB2ARHPJduKwBiki8vl5sKYp8HK/v7IWEuTjFpZbCk5se1zEChAZ8W3
         WryiWFCJ03U1OpJ4VKGUOtcZ8EdcL7g9OZHRV7U9kzM7L+QZha1rTZg7OUQocnli9J
         ODpYCD99OsK9I12IA33W2zJK2/JcZaMbd4Gsoq6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 075/101] scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN
Date:   Thu,  2 May 2019 17:21:17 +0200
Message-Id: <20190502143344.903966567@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c8206579175c34a2546de8a74262456278a7795a ]

If an incoming ELS of type RSCN contains more than one element, zfcp
suboptimally causes repeated erp trigger NOP trace records for each
previously failed port. These could be ports that went away.  It loops over
each RSCN element, and for each of those in an inner loop over all
zfcp_ports.

The trigger to recover failed ports should be just the reception of some
RSCN, no matter how many elements it has. So we can loop over failed ports
separately, and only then loop over each RSCN element to handle the
non-failed ports.

The call chain was:

  zfcp_fc_incoming_rscn
    for (i = 1; i < no_entries; i++)
      _zfcp_fc_incoming_rscn
        list_for_each_entry(port, &adapter->port_list, list)
          if (masked port->d_id match) zfcp_fc_test_link
          if (!port->d_id) zfcp_erp_port_reopen "fcrscn1"   <===

In order the reduce the "flooding" of the REC trace area in such cases, we
factor out handling the failed ports to be outside of the entries loop:

  zfcp_fc_incoming_rscn
    if (no_entries > 1)                                     <===
      list_for_each_entry(port, &adapter->port_list, list)  <===
        if (!port->d_id) zfcp_erp_port_reopen "fcrscn1"     <===
    for (i = 1; i < no_entries; i++)
      _zfcp_fc_incoming_rscn
        list_for_each_entry(port, &adapter->port_list, list)
          if (masked port->d_id match) zfcp_fc_test_link

Abbreviated example trace records before this code change:

Tag            : fcrscn1
WWPN           : 0x500507630310d327
ERP want       : 0x02
ERP need       : 0x02

Tag            : fcrscn1
WWPN           : 0x500507630310d327
ERP want       : 0x02
ERP need       : 0x00                 NOP => superfluous trace record

The last trace entry repeats if there are more than 2 RSCN elements.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/s390/scsi/zfcp_fc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index db00b5e3abbe..33eddb02ee30 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -239,10 +239,6 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 	list_for_each_entry(port, &adapter->port_list, list) {
 		if ((port->d_id & range) == (ntoh24(page->rscn_fid) & range))
 			zfcp_fc_test_link(port);
-		if (!port->d_id)
-			zfcp_erp_port_reopen(port,
-					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "fcrscn1");
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
@@ -250,6 +246,7 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 {
 	struct fsf_status_read_buffer *status_buffer = (void *)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fc_els_rscn *head;
 	struct fc_els_rscn_page *page;
 	u16 i;
@@ -263,6 +260,22 @@ static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 	no_entries = be16_to_cpu(head->rscn_plen) /
 		sizeof(struct fc_els_rscn_page);
 
+	if (no_entries > 1) {
+		/* handle failed ports */
+		unsigned long flags;
+		struct zfcp_port *port;
+
+		read_lock_irqsave(&adapter->port_list_lock, flags);
+		list_for_each_entry(port, &adapter->port_list, list) {
+			if (port->d_id)
+				continue;
+			zfcp_erp_port_reopen(port,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     "fcrscn1");
+		}
+		read_unlock_irqrestore(&adapter->port_list_lock, flags);
+	}
+
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
 		page++;
-- 
2.19.1



