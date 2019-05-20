Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731D12362C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389740AbfETM2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389349AbfETM0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2677A21479;
        Mon, 20 May 2019 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355204;
        bh=4CXJx8mG7PBQ+VliU1mAvTpPrbLkRKfqM+3TOBtjgf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jw0JSLV1zJV7GUkzmZ+d8ACZM8qQzwvwVhS6qT6mgv7ngoEMCv6/bQK5OrXjtKvSy
         du+YQlhmkMKfld2zZq6OJAVGSKxUeXYFTsJkeU5uD124ThlOGEJAuov0vtJGV6YpE+
         N8hfe4DUiXv4TODj95txeuk792TunhpAp2PgWyAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 5.0 031/123] crypto: ccp - Do not free psp_master when PLATFORM_INIT fails
Date:   Mon, 20 May 2019 14:13:31 +0200
Message-Id: <20190520115246.833094276@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Singh, Brijesh <brijesh.singh@amd.com>

commit f5a2aeb8b254c764772729a6e48d4e0c914bb56a upstream.

Currently, we free the psp_master if the PLATFORM_INIT fails during the
SEV FW probe. If psp_master is freed then driver does not invoke the PSP
FW. As per SEV FW spec, there are several commands (PLATFORM_RESET,
PLATFORM_STATUS, GET_ID etc) which can be executed in the UNINIT state
We should not free the psp_master when PLATFORM_INIT fails.

Fixes: 200664d5237f ("crypto: ccp: Add SEV support")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/psp-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -972,7 +972,7 @@ void psp_pci_init(void)
 	rc = sev_platform_init(&error);
 	if (rc) {
 		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
-		goto err;
+		return;
 	}
 
 	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,


