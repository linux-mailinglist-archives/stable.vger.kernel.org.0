Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03D2A511E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgKCUiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbgKCUiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC5022226;
        Tue,  3 Nov 2020 20:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435881;
        bh=/GclZEcaBTfiRQa/ogs0zaxm6VHYHLeOr/Y4F7bTqEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldcAkZIiLERToUgXTSXUIw/LHNdbyQNFcWHNMMsuqrt2o4asZsppCe5ENRfgzTznf
         vOA6yJtIkDEydHgR19stiGhIOOQmATetiGhsRsGdim05YMDoIP0i98lFIQNna8Z9kE
         nGd7HBMcPBLX7JW8ESPk/kX6xrzrcl2hH2Vx4ha0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 016/391] tee: client UUID: Skip REE kernel login method as well
Date:   Tue,  3 Nov 2020 21:31:07 +0100
Message-Id: <20201103203349.059249313@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

[ Upstream commit 722939528a37aa0cb22d441e2045c0cf53e78fb0 ]

Since the addition of session's client UUID generation via commit [1],
login via REE kernel method was disallowed. So fix that via passing
nill UUID in case of TEE_IOCTL_LOGIN_REE_KERNEL method as well.

Fixes: e33bcbab16d1 ("tee: add support for session's client UUID generation") [1]
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 64637e09a0953..2f6199ebf7698 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -200,7 +200,8 @@ int tee_session_calc_client_uuid(uuid_t *uuid, u32 connection_method,
 	int name_len;
 	int rc;
 
-	if (connection_method == TEE_IOCTL_LOGIN_PUBLIC) {
+	if (connection_method == TEE_IOCTL_LOGIN_PUBLIC ||
+	    connection_method == TEE_IOCTL_LOGIN_REE_KERNEL) {
 		/* Nil UUID to be passed to TEE environment */
 		uuid_copy(uuid, &uuid_null);
 		return 0;
-- 
2.27.0



