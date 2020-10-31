Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F692A16AE
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgJaLrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgJaLpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B23E20739;
        Sat, 31 Oct 2020 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144704;
        bh=tLe4UjHfaP1L6JDkFsgInBOXWJARSnPmbin4YN2jjzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Se5VZKePghQMys4CE9LO198UvjbYXY5dBzURSXZVtlSjgSS+c80gwGe44MPJWWT+W
         /AMUyH5yUPBhGeAoz9I7YKW5vCcdZwKaD9Y2iV+gTTrg6vsseeXRRbIE5R0ygH4lkz
         MJt6zMCh2+7XTR6Gqo+Fpj0I5Hi8nC8sWKxhdMEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 49/74] net/smc: fix invalid return code in smcd_new_buf_create()
Date:   Sat, 31 Oct 2020 12:36:31 +0100
Message-Id: <20201031113502.388439261@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 6b1bbf94ab369d97ed3bdaa561521a52c27ef619 ]

smc_ism_register_dmb() returns error codes set by the ISM driver which
are not guaranteed to be negative or in the errno range. Such values
would not be handled by ERR_PTR() and finally the return code will be
used as a memory address.
Fix that by using a valid negative errno value with ERR_PTR().

Fixes: 72b7f6c48708 ("net/smc: unique reason code for exceeded max dmb count")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1616,7 +1616,8 @@ static struct smc_buf_desc *smcd_new_buf
 		rc = smc_ism_register_dmb(lgr, bufsize, buf_desc);
 		if (rc) {
 			kfree(buf_desc);
-			return (rc == -ENOMEM) ? ERR_PTR(-EAGAIN) : ERR_PTR(rc);
+			return (rc == -ENOMEM) ? ERR_PTR(-EAGAIN) :
+						 ERR_PTR(-EIO);
 		}
 		buf_desc->pages = virt_to_page(buf_desc->cpu_addr);
 		/* CDC header stored in buf. So, pretend it was smaller */


