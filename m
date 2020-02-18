Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873991631E6
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgBRUD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgBRUDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA38824670;
        Tue, 18 Feb 2020 20:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056205;
        bh=H4Ew2aAUupScSkFrN5Wkm/NovnKlteYwH0KQ/xlpASU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXJPDhziwn0gcbF20foHroFI4jeoiK0gXgvrMj8558aGGiSHVCHHTaOef7jiHKyxe
         LXXihx1+bmN4Wr1R/DDIfcfHZKs0fvd6wqHBJGPi91vYJL2oJrC9SBJoUR83ykN6tf
         owrVIbcTzvQAH4mTavlI4R2YFRkmKzZQ9cjEbAJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Christian Rund <RUNDC@de.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.5 38/80] s390/pkey: fix missing length of protected key on return
Date:   Tue, 18 Feb 2020 20:54:59 +0100
Message-Id: <20200218190436.045686429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit aab73d278d49c718b722ff5052e16c9cddf144d4 upstream.

The pkey ioctl call PKEY_SEC2PROTK updates a struct pkey_protkey
on return. The protected key is stored in, the protected key type
is stored in but the len information was not updated. This patch
now fixes this and so the len field gets an update to refrect
the actual size of the protected key value returned.

Fixes: efc598e6c8a9 ("s390/zcrypt: move cca misc functions to new code file")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reported-by: Christian Rund <RUNDC@de.ibm.com>
Suggested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/pkey_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -774,7 +774,7 @@ static long pkey_unlocked_ioctl(struct f
 			return -EFAULT;
 		rc = cca_sec2protkey(ksp.cardnr, ksp.domain,
 				     ksp.seckey.seckey, ksp.protkey.protkey,
-				     NULL, &ksp.protkey.type);
+				     &ksp.protkey.len, &ksp.protkey.type);
 		DEBUG_DBG("%s cca_sec2protkey()=%d\n", __func__, rc);
 		if (rc)
 			break;


