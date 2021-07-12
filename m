Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DD13C4782
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbhGLGdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235789AbhGLG3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F36A61130;
        Mon, 12 Jul 2021 06:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071158;
        bh=QGS7j9NEiqhohFQQek983CFj0kWK3C1qM3FUkdMk+VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWFpfrdsi8KKf765qBYTBU008nPHOrKNgGjN3ugp+WbJ5K9iGFuzjZfTwbnlBafJc
         NDpnyONJJ1qYG/h52fqS3yoGlNIt/jzDODPccXxDMwNV13Xuhlbv4m+FMm8GvBoYpe
         SEVzDvcRlA/06wT+TAB9N6qUcqIHopQYFcocyJfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 297/348] fsi: occ: Dont accept response from un-initialized OCC
Date:   Mon, 12 Jul 2021 08:11:21 +0200
Message-Id: <20210712060743.040504178@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 7da9c81759ac..8f1644804570 100644
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



