Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628944F30CD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbiDEIe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbiDEIUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781808F99A;
        Tue,  5 Apr 2022 01:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F8060AFB;
        Tue,  5 Apr 2022 08:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20512C385A4;
        Tue,  5 Apr 2022 08:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146377;
        bh=eGTpxXH09wxPDurXHU6C89R4dTMpZZ0TsDKQfzO4kZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRGHsLhg6ioZrikoqghenTDI3fSRDwZc51AosiJMzJs/T6l0W9RlwXD6dusEIp97e
         i6C4xAUMJeU5DfYXlq9XHH0yJCnCZLhEutoFcCcObk14jf59zBoOQ5QPAhzZYwXbVp
         WBNUNTNOOzfFgQ8e14YFy3dZZnUPqsAjxj1jmVIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Eddie James <eajames@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0715/1126] fsi: scom: Remove retries in indirect scoms
Date:   Tue,  5 Apr 2022 09:24:22 +0200
Message-Id: <20220405070428.583773894@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit ab1b79159ad5a6dc4e4994b49737f7feb13b7155 ]

In commit f72ddbe1d7b7 ("fsi: scom: Remove retries") the retries were
removed from get and put scoms. That patch missed the retires in get and
put indirect scom.

For the same reason, remove them from the scom driver to allow the
caller to decide to retry.

This removes the following special case which would have caused the
retry code to return early:

 -       if ((ind_data & XSCOM_DATA_IND_COMPLETE) || (err != SCOM_PIB_BLOCKED))
 -               return 0;

I believe this case is handled.

Fixes: f72ddbe1d7b7 ("fsi: scom: Remove retries")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20211207033811.518981-3-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-scom.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/fsi/fsi-scom.c b/drivers/fsi/fsi-scom.c
index 3b427f7e9027..bcb756dc9866 100644
--- a/drivers/fsi/fsi-scom.c
+++ b/drivers/fsi/fsi-scom.c
@@ -145,7 +145,7 @@ static int put_indirect_scom_form0(struct scom_device *scom, uint64_t value,
 				   uint64_t addr, uint32_t *status)
 {
 	uint64_t ind_data, ind_addr;
-	int rc, retries, err = 0;
+	int rc, err;
 
 	if (value & ~XSCOM_DATA_IND_DATA)
 		return -EINVAL;
@@ -156,19 +156,14 @@ static int put_indirect_scom_form0(struct scom_device *scom, uint64_t value,
 	if (rc || (*status & SCOM_STATUS_ANY_ERR))
 		return rc;
 
-	for (retries = 0; retries < SCOM_MAX_IND_RETRIES; retries++) {
-		rc = __get_scom(scom, &ind_data, addr, status);
-		if (rc || (*status & SCOM_STATUS_ANY_ERR))
-			return rc;
+	rc = __get_scom(scom, &ind_data, addr, status);
+	if (rc || (*status & SCOM_STATUS_ANY_ERR))
+		return rc;
 
-		err = (ind_data & XSCOM_DATA_IND_ERR_MASK) >> XSCOM_DATA_IND_ERR_SHIFT;
-		*status = err << SCOM_STATUS_PIB_RESP_SHIFT;
-		if ((ind_data & XSCOM_DATA_IND_COMPLETE) || (err != SCOM_PIB_BLOCKED))
-			return 0;
+	err = (ind_data & XSCOM_DATA_IND_ERR_MASK) >> XSCOM_DATA_IND_ERR_SHIFT;
+	*status = err << SCOM_STATUS_PIB_RESP_SHIFT;
 
-		msleep(1);
-	}
-	return rc;
+	return 0;
 }
 
 static int put_indirect_scom_form1(struct scom_device *scom, uint64_t value,
@@ -188,7 +183,7 @@ static int get_indirect_scom_form0(struct scom_device *scom, uint64_t *value,
 				   uint64_t addr, uint32_t *status)
 {
 	uint64_t ind_data, ind_addr;
-	int rc, retries, err = 0;
+	int rc, err;
 
 	ind_addr = addr & XSCOM_ADDR_DIRECT_PART;
 	ind_data = (addr & XSCOM_ADDR_INDIRECT_PART) | XSCOM_DATA_IND_READ;
@@ -196,21 +191,15 @@ static int get_indirect_scom_form0(struct scom_device *scom, uint64_t *value,
 	if (rc || (*status & SCOM_STATUS_ANY_ERR))
 		return rc;
 
-	for (retries = 0; retries < SCOM_MAX_IND_RETRIES; retries++) {
-		rc = __get_scom(scom, &ind_data, addr, status);
-		if (rc || (*status & SCOM_STATUS_ANY_ERR))
-			return rc;
-
-		err = (ind_data & XSCOM_DATA_IND_ERR_MASK) >> XSCOM_DATA_IND_ERR_SHIFT;
-		*status = err << SCOM_STATUS_PIB_RESP_SHIFT;
-		*value = ind_data & XSCOM_DATA_IND_DATA;
+	rc = __get_scom(scom, &ind_data, addr, status);
+	if (rc || (*status & SCOM_STATUS_ANY_ERR))
+		return rc;
 
-		if ((ind_data & XSCOM_DATA_IND_COMPLETE) || (err != SCOM_PIB_BLOCKED))
-			return 0;
+	err = (ind_data & XSCOM_DATA_IND_ERR_MASK) >> XSCOM_DATA_IND_ERR_SHIFT;
+	*status = err << SCOM_STATUS_PIB_RESP_SHIFT;
+	*value = ind_data & XSCOM_DATA_IND_DATA;
 
-		msleep(1);
-	}
-	return rc;
+	return 0;
 }
 
 static int raw_put_scom(struct scom_device *scom, uint64_t value,
-- 
2.34.1



