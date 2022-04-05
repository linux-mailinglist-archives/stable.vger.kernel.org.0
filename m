Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5695B4F3865
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiDELXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349465AbiDEJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F96659A;
        Tue,  5 Apr 2022 02:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3074FB81B14;
        Tue,  5 Apr 2022 09:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8398BC385A2;
        Tue,  5 Apr 2022 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151999;
        bh=5dFCK/bwE+X+xrItH9sMlwXXPJaUtIAhj7mXcM9iEas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQROW5FSMhGfRWopfHZGXP1eSW6M+IUo18qRZt8LJrUpH+kJJbudsiP+JDHNskGwJ
         0qiEZruM5kYU7v9JsKhoBf7qmp77hQ4+qLYcVBsmXdMxbQ8qYnCMfIQA6dFLO2l63o
         wrzS91DqcQT6ZOXoZMKRUGiGIFRaLgFty0TJKMLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joel Stanley <joel@jms.id.au>,
        Eddie James <eajames@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 580/913] fsi: scom: Fix error handling
Date:   Tue,  5 Apr 2022 09:27:22 +0200
Message-Id: <20220405070357.230944920@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit d46fddd52d11eb6a3a7ed836f9f273e9cf8cd01c ]

SCOM error handling is made complex by trying to pass around two bits of
information: the function return code, and a status parameter that
represents the CFAM error status register.

The commit f72ddbe1d7b7 ("fsi: scom: Remove retries") removed the
"hidden" retries in the SCOM driver, in preference of allowing the
calling code (userspace or driver) to decide how to handle a failed
SCOM. However it introduced a bug by attempting to be smart about the
return codes that were "errors" and which were ok to fall through to the
status register parsing.

We get the following errors:

 - EINVAL or ENXIO, for indirect scoms where the value is invalid
 - EINVAL, where the size or address is incorrect
 - EIO or ETIMEOUT, where FSI write failed (aspeed master)
 - EAGAIN, where the master detected a crc error (GPIO master only)
 - EBUSY, where the bus is disabled (GPIO master in external mode)

In all of these cases we should fail the SCOM read/write and return the
error.

Thanks to Dan Carpenter for the detailed bug report.

Fixes: f72ddbe1d7b7 ("fsi: scom: Remove retries")
Link: https://lists.ozlabs.org/pipermail/linux-fsi/2021-November/000235.html
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20211207033811.518981-2-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-scom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fsi/fsi-scom.c b/drivers/fsi/fsi-scom.c
index da1486bb6a14..3b427f7e9027 100644
--- a/drivers/fsi/fsi-scom.c
+++ b/drivers/fsi/fsi-scom.c
@@ -289,7 +289,7 @@ static int put_scom(struct scom_device *scom, uint64_t value,
 	int rc;
 
 	rc = raw_put_scom(scom, value, addr, &status);
-	if (rc == -ENODEV)
+	if (rc)
 		return rc;
 
 	rc = handle_fsi2pib_status(scom, status);
@@ -308,7 +308,7 @@ static int get_scom(struct scom_device *scom, uint64_t *value,
 	int rc;
 
 	rc = raw_get_scom(scom, value, addr, &status);
-	if (rc == -ENODEV)
+	if (rc)
 		return rc;
 
 	rc = handle_fsi2pib_status(scom, status);
-- 
2.34.1



