Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339ECA9135
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390723AbfIDSOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390193AbfIDSOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C49E206BA;
        Wed,  4 Sep 2019 18:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620846;
        bh=AijjDcw+bDNa2gdFvNVN9OG3Ed0uGHSfKxuUEJK5c9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZH+OapStm/CKo2eQrYaS56zs1nQU2fIrRVqsxNwuXuvk1tqorVuhTNT+7l4mVNFO
         LCfVA7DPRVQxFfu2La8yuu/mbZUhkcr3oQ0gSwUn6f+6XywaxrZLCZQ46OOyHIszaj
         YtoB0lpsoXwtdmz5AlEMPzKdL3+kYMr0mSzL9UGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 118/143] crypto: ccp - Ignore unconfigured CCP device on suspend/resume
Date:   Wed,  4 Sep 2019 19:54:21 +0200
Message-Id: <20190904175319.015719586@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

commit 5871cd93692c8071fb9358daccb715b5081316ac upstream.

If a CCP is unconfigured (e.g. there are no available queues) then
there will be no data structures allocated for the device. Thus, we
must check for validity of a pointer before trying to access structure
members.

Fixes: 720419f01832f ("crypto: ccp - Introduce the AMD Secure Processor device")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-dev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -540,6 +540,10 @@ int ccp_dev_suspend(struct sp_device *sp
 	unsigned long flags;
 	unsigned int i;
 
+	/* If there's no device there's nothing to do */
+	if (!ccp)
+		return 0;
+
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
 
 	ccp->suspending = 1;
@@ -564,6 +568,10 @@ int ccp_dev_resume(struct sp_device *sp)
 	unsigned long flags;
 	unsigned int i;
 
+	/* If there's no device there's nothing to do */
+	if (!ccp)
+		return 0;
+
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
 
 	ccp->suspending = 0;


