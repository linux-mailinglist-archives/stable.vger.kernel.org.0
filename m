Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50329BC79
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810019AbgJ0QdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802490AbgJ0Ptj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8530204EF;
        Tue, 27 Oct 2020 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813778;
        bh=N5QeLT4lYf6VW3DsLZV3yTNIyO2Q9L2kglcl6ro5PDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsfssL7RXfGHYhzkwU32g6em/YM8xmQ1v43AnhuePu8re1T97fbrK4JQcglnrgH8w
         WWf+k7f7CObZmkeXTCGTJd56ElsRI3Lhj+NEy+z8jTRNYWk3sSJnFU7sf/5QrmGvpu
         +QfrlIdez4Y1//9FLG7bDBvfQYJR+VK2KJyIKWZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 667/757] media: atomisp: fix memleak in ia_css_stream_create
Date:   Tue, 27 Oct 2020 14:55:17 +0100
Message-Id: <20201027135521.828900887@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit c1bca5b5ced0cbd779d56f60cdbc9f5e6f6449fe ]

When aspect_ratio_crop_init() fails, curr_stream needs
to be freed just like what we've done in the following
error paths. However, current code is returning directly
and ends up leaking memory.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index a68cbb4995f0f..33a0f8ff82aa8 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -9521,7 +9521,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 	if (err)
 	{
 		IA_CSS_LEAVE_ERR(err);
-		return err;
+		goto ERR;
 	}
 #endif
 	for (i = 0; i < num_pipes; i++)
-- 
2.25.1



