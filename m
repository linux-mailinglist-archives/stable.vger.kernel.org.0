Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D93110C5
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhBER15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233478AbhBEQAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1520765053;
        Fri,  5 Feb 2021 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534341;
        bh=0Jg9HhX2wgLDjUo+HzKXXr/haumhWqdQR9muR8xmCak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNv7CtOQpW5SprQU1Ujk5Mm3V+Rzy5H5d03cuFicQFZwhrFwah0tgote2X9VfMuC8
         AuagyGrWNV204hQPtMjU/D45QREhSHXafh6FIlpP891YXDsAFLzfHOUfFebC+2VJEo
         p1U8TAeSC72utiIuzk0AYdFav63qvr2vqt+6SXKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 03/32] ibmvnic: Ensure that CRQ entry read are correctly ordered
Date:   Fri,  5 Feb 2021 15:07:18 +0100
Message-Id: <20210205140652.499953112@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

commit e41aec79e62fa50f940cf222d1e9577f14e149dc upstream.

Ensure that received Command-Response Queue (CRQ) entries are
properly read in order by the driver. dma_rmb barrier has
been added before accessing the CRQ descriptor to ensure
the entire descriptor is read before processing.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/20210128013442.88319-1-ljp@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4752,6 +4752,12 @@ static void ibmvnic_tasklet(void *data)
 	while (!done) {
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
+			/* This barrier makes sure ibmvnic_next_crq()'s
+			 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
+			 * before ibmvnic_handle_crq()'s
+			 * switch(gen_crq->first) and switch(gen_crq->cmd).
+			 */
+			dma_rmb();
 			ibmvnic_handle_crq(crq, adapter);
 			crq->generic.first = 0;
 		}


