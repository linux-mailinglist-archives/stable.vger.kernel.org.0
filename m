Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B485929B189
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902152AbgJ0ObD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759313AbgJ0O3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23CA820780;
        Tue, 27 Oct 2020 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808944;
        bh=G7bVG5paWlmju2PkmCPdYFjqKq5uqJ9Q/dZLNw6Wznc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woM79kPkyVpR9QUePKloAfownMe+C3DsVl+DPZLQap2zlrJd4gA9IVhPvQbw2X2wn
         sx1QjYYtQFTak28Cvr/fwQFaF84D6qfmM6uv8F40woeC+Wz5VirGIKU6X3m9K/zaji
         eWFuM2/5i0GwVIcyriUKWbOAtlmDj2ht9w7n/Efc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 008/408] net/smc: fix valid DMBE buffer sizes
Date:   Tue, 27 Oct 2020 14:49:06 +0100
Message-Id: <20201027135455.435579536@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit ef12ad45880b696eb993d86c481ca891836ab593 ]

The SMCD_DMBE_SIZES should include all valid DMBE buffer sizes, so the
correct value is 6 which means 1MB. With 7 the registration of an ISM
buffer would always fail because of the invalid size requested.
Fix that and set the value to 6.

Fixes: c6ba7c9ba43d ("net/smc: add base infrastructure for SMC-D and ISM")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -795,7 +795,7 @@ static struct smc_buf_desc *smcr_new_buf
 	return buf_desc;
 }
 
-#define SMCD_DMBE_SIZES		7 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
+#define SMCD_DMBE_SIZES		6 /* 0 -> 16KB, 1 -> 32KB, .. 6 -> 1MB */
 
 static struct smc_buf_desc *smcd_new_buf_create(struct smc_link_group *lgr,
 						bool is_dmb, int bufsize)


