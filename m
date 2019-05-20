Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C85B233F5
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbfETMVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388231AbfETMVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:21:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1BD520815;
        Mon, 20 May 2019 12:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354903;
        bh=oU8ELGmWcICzgQj8njCsPkwaruA3CSb1XebZBOO8JIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SC2y2dZNloO747Yd6cx9mVSeX7y5V2zhAZO2v5qQNNXS53HYXqKKRyJBtwU/T6phH
         NFHFaN6x9vss4TZktqIETo1+l1xrcV8xQYYGe8fSbBxISiUqwfwnIot+2wnlgXQtXX
         BAQ/Fode1xts7/yvXNDqb47KxUNEluszHOE7YRi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 4.19 022/105] crypto: ccp - Do not free psp_master when PLATFORM_INIT fails
Date:   Mon, 20 May 2019 14:13:28 +0200
Message-Id: <20190520115248.559897416@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
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
@@ -935,7 +935,7 @@ void psp_pci_init(void)
 	rc = sev_platform_init(&error);
 	if (rc) {
 		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
-		goto err;
+		return;
 	}
 
 	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,


