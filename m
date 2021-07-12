Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510193C4AA1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhGLGxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239463AbhGLGts (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F8660FD8;
        Mon, 12 Jul 2021 06:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072421;
        bh=pLyHru/6LPL5ZD8EdeUCxgMJ0rk2W/O2xl6joVuYubI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tx9LNGbkbcTGr9xLNmBhJPHrD6nqB+kIzeJjfWQkJuEB+aGcmTgAkLvtPDV1t3kyD
         d0u+pJ7cAcxksmk3zAczUqdQgslJ/T1A3piVZkpYzDcW+BUS4wtLkfrN80xNNb5BBl
         TevHrViOk20BaYT/musPjYEj0d+ZSyN+hhzPX1+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 491/593] fsi: occ: Dont accept response from un-initialized OCC
Date:   Mon, 12 Jul 2021 08:10:51 +0200
Message-Id: <20210712060945.296010908@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 8a4659be08576141f47d47d94130eb148cb5f0df ]

If the OCC is not initialized and responds as such, the driver
should continue waiting for a valid response until the timeout
expires.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Fixes: 7ed98dddb764 ("fsi: Add On-Chip Controller (OCC) driver")
Link: https://lore.kernel.org/r/20210209171235.20624-2-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-occ.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fsi/fsi-occ.c b/drivers/fsi/fsi-occ.c
index 9eeb856c8905..a691f9732a13 100644
--- a/drivers/fsi/fsi-occ.c
+++ b/drivers/fsi/fsi-occ.c
@@ -445,6 +445,7 @@ int fsi_occ_submit(struct device *dev, const void *request, size_t req_len,
 			goto done;
 
 		if (resp->return_status == OCC_RESP_CMD_IN_PRG ||
+		    resp->return_status == OCC_RESP_CRIT_INIT ||
 		    resp->seq_no != seq_no) {
 			rc = -ETIMEDOUT;
 
-- 
2.30.2



