Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DC823A52A
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgHCMdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729101AbgHCMdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EE92054F;
        Mon,  3 Aug 2020 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458033;
        bh=C8PD6oRY0Isp66vleS6E1szTsB0xCyrvx6x4AqQUzOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuorgMdhxZ5x6GoI9Bk5Ycl9Ipvx5BQ4c7jkJYPpUGFmDTr3kFiDMtWpUMCYq/Ert
         4qSghotILyZqK/SS2zdfKm/NiTy9eqBLn1N1pQ3QXrk2B0cLLGaA3onnZGqWZQ0wqt
         H5N2qAInmvm7uAuMpubCjqyoAKbh9wpuC8EY7qIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/51] crypto: ccp - Release all allocated memory if sha type is invalid
Date:   Mon,  3 Aug 2020 14:19:48 +0200
Message-Id: <20200803121849.654696381@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 330853a2702f0..43b74cf0787e1 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1783,8 +1783,9 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
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



