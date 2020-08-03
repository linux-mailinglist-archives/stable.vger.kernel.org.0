Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9823A647
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgHCMqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbgHCM0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:26:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69443204EC;
        Mon,  3 Aug 2020 12:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457608;
        bh=z8DB9BbECBRb+IaSNOPSwPWCqDsqjkirBR1M+COF/qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwW71cknxB4vRmyutIwtIJsKpIoOHoeHBAzfB2ANjDYwPAyIxtms5CVSD93jqZOG7
         /65sX5O1D6GqsvPJ1iLFTkSNl7s5+e4edYRYEphvPXN/OC6yYFAeHepWiyzSlGwNVh
         dwUNt7Peez2MRH68bVSejgx3+gQut5/eVjKoWxjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/90] crypto: ccp - Release all allocated memory if sha type is invalid
Date:   Mon,  3 Aug 2020 14:18:23 +0200
Message-Id: <20200803121857.614278053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 128c66429247add5128c03dc1e144ca56f05a4e2 ]

Release all allocated memory if sha type is invalid:
In ccp_run_sha_cmd, if the type of sha is invalid, the allocated
hmac_buf should be released.

v2: fix the goto.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index c8da8eb160da0..422193690fd47 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1777,8 +1777,9 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			       LSB_ITEM_SIZE);
 			break;
 		default:
+			kfree(hmac_buf);
 			ret = -EINVAL;
-			goto e_ctx;
+			goto e_data;
 		}
 
 		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
-- 
2.25.1



