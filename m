Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76411AC790
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404415AbgDPO4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409143AbgDPN4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:56:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C5221744;
        Thu, 16 Apr 2020 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045361;
        bh=i/WQ4zp2hHzop+pFU2DiVs4dApyLMmZBX3q6djS2+kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpSF4T10z6CeKRjgjdRXBXTkliIkNeGbUIxNbKi4e+ItUY8QqPlbN5yF3FKOpZYRS
         qdpzD5RsIVB0Au3x2ISMA+gAtBv9Hghbg8NKmpe+QDPbQ6COX94eK3HUaNdcYFkHeY
         QrnmXaC6xQxxrn5NLur/9768W9Ck4+6JmaJ8hgsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenhua Liu <liuw@vmware.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.6 096/254] nvmet-tcp: fix maxh2cdata icresp parameter
Date:   Thu, 16 Apr 2020 15:23:05 +0200
Message-Id: <20200416131337.973130294@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 9cda34e37489244a8c8628617e24b2dbc8a8edad upstream.

MAXH2CDATA is not zero based. Also no reason to limit ourselves to
1M transfers as we can do more easily. Make this an arbitrary limit
of 16M.

Reported-by: Wenhua Liu <liuw@vmware.com>
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/target/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -794,7 +794,7 @@ static int nvmet_tcp_handle_icreq(struct
 	icresp->hdr.pdo = 0;
 	icresp->hdr.plen = cpu_to_le32(icresp->hdr.hlen);
 	icresp->pfv = cpu_to_le16(NVME_TCP_PFV_1_0);
-	icresp->maxdata = cpu_to_le32(0xffff); /* FIXME: support r2t */
+	icresp->maxdata = cpu_to_le32(0x400000); /* 16M arbitrary limit */
 	icresp->cpda = 0;
 	if (queue->hdr_digest)
 		icresp->digest |= NVME_TCP_HDR_DIGEST_ENABLE;


