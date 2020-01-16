Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D0D13FFCF
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgAPXWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbgAPXWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4691E20684;
        Thu, 16 Jan 2020 23:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216961;
        bh=a5YYx2ZQyypM/51X9oNyFaPwgNPW3b4jNytdJ17wumg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpGgf2Tb23lIU8SdMnUnbTH6sxa+3kX+UJQxLB93Muds0OW/EHzvLnKV3+86/UWbr
         cUD7niGZeS+4u6WTFiKDXCc82YWWBFMo4gAZktD8mWQaKKSkNAFCTYwgDgiH63gpBR
         suR6NtMdMIQaKRi4MlpxA8uGkD+2C3Y7cKYdHdrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 065/203] RDMA/siw: Fix port number endianness in a debug message
Date:   Fri, 17 Jan 2020 00:16:22 +0100
Message-Id: <20200116231749.774888260@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 050dbddf249eee3e936b5734c30b2e1b427efdc3 upstream.

sin_port and sin6_port are big endian member variables. Convert these port
numbers into CPU endianness before printing.

Link: https://lore.kernel.org/r/20190930231707.48259-5-bvanassche@acm.org
Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/siw/siw_cm.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1867,14 +1867,7 @@ static int siw_listen_address(struct iw_
 	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
 	cep->state = SIW_EPSTATE_LISTENING;
 
-	if (addr_family == AF_INET)
-		siw_dbg(id->device, "Listen at laddr %pI4 %u\n",
-			&(((struct sockaddr_in *)laddr)->sin_addr),
-			((struct sockaddr_in *)laddr)->sin_port);
-	else
-		siw_dbg(id->device, "Listen at laddr %pI6 %u\n",
-			&(((struct sockaddr_in6 *)laddr)->sin6_addr),
-			((struct sockaddr_in6 *)laddr)->sin6_port);
+	siw_dbg(id->device, "Listen at laddr %pISp\n", laddr);
 
 	return 0;
 


