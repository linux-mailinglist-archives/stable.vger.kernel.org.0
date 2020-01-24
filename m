Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C751F147AEE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgAXJja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731650AbgAXJja (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:30 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857A72070A;
        Fri, 24 Jan 2020 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858770;
        bh=oWb8Ya0sm0pvKPDxvhDcXDKyiSM/2jidzOVXJWnMCrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4QUoCoo8Vurhwx9ZrOdD1tdl/isvWdKqRdQPzoG/5M/T9SLOqoGvRS0WpDTNLYuH
         ANCwC3Svp3qWdAgt9ssbB5J7ERZB6+QWxHLo6B1w4sAQ/+3FGF0WHf+MiCw36UaYM3
         NoMNsFxDEU1KGbb5PQE04gu9UJtJ4W8uL37gb5sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Elfring <Markus.Elfring@web.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 035/102] s390/pkey: fix memory leak within _copy_apqns_from_user()
Date:   Fri, 24 Jan 2020 10:30:36 +0100
Message-Id: <20200124092811.559543225@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit f9cac4fd8878929c6ebff0bd272317905d77c38a upstream.

Fixes: f2bbc96e7cfad ("s390/pkey: add CCA AES cipher key support")
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/pkey_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -740,8 +740,10 @@ static void *_copy_apqns_from_user(void
 		kapqns = kmalloc(nbytes, GFP_KERNEL);
 		if (!kapqns)
 			return ERR_PTR(-ENOMEM);
-		if (copy_from_user(kapqns, uapqns, nbytes))
+		if (copy_from_user(kapqns, uapqns, nbytes)) {
+			kfree(kapqns);
 			return ERR_PTR(-EFAULT);
+		}
 	}
 
 	return kapqns;


