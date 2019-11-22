Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22FD106BF8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbfKVKsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:48:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729159AbfKVKso (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:48:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEAA420637;
        Fri, 22 Nov 2019 10:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419724;
        bh=jIJzKKrRiPN4sYSrKyogbBy6hg42/byJJuVxrEWKYyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVvn/dwte8GjJhmmBAJ5Gnv6PLpv0j3HX6pABAqRphyKhtQOf0yQ6IxAfdQ36iCyS
         wrZIoW5uIB3DSxtMtl51PLpiBqOwxKZefh9h6NTblIqfBfMqMnPsYw+46mO4FUlqWq
         vw75FWLfNP0S2WxKTVaD+Ns4xWv/cipOwVZK3H1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 208/222] media: isif: fix a NULL pointer dereference bug
Date:   Fri, 22 Nov 2019 11:29:08 +0100
Message-Id: <20191122100917.353814632@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

[ Upstream commit a26ac6c1bed951b2066cc4b2257facd919e35c0b ]

In isif_probe(), there is a while loop to get the ISIF base address and
linearization table0 and table1 address. In the loop body, the function
platform_get_resource() is called to get the resource. If
platform_get_resource() returns NULL, the loop is terminated and the
execution goes to 'fail_nobase_res'. Suppose the loop is terminated at the
first iteration because platform_get_resource() returns NULL and the
execution goes to 'fail_nobase_res'. Given that there is another while loop
at 'fail_nobase_res' and i equals to 0, one iteration of the second while
loop will be executed. However, the second while loop does not check the
return value of platform_get_resource(). This can cause a NULL pointer
dereference bug if the return value is a NULL pointer.

This patch avoids the above issue by adding a check in the second while
loop after the call to platform_get_resource().

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/isif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index 99faea2e84c6b..78e37cf3470f2 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1106,7 +1106,8 @@ static int isif_probe(struct platform_device *pdev)
 
 	while (i >= 0) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		release_mem_region(res->start, resource_size(res));
+		if (res)
+			release_mem_region(res->start, resource_size(res));
 		i--;
 	}
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
-- 
2.20.1



