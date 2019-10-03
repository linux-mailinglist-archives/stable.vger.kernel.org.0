Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE088CA4B9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391326AbfJCQ1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391321AbfJCQ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:27:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A3E21783;
        Thu,  3 Oct 2019 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120066;
        bh=iPazQ00aOuuilt+GzDQbr9bRbIVeHkRFhHoRkii1JTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBM8rQuzSVkXUKFjULwrQMdXupW1Ev190+jz9k85MUMMqMoQyvfsG6UkJIKYAabaf
         SJXDpawyxM6y4R3oAbOyrZLRMJTRigHXPmKjQrM3KwBvSstX5vxU9eJl58WyVOHTg5
         UituwxUnlN8Ah/H46ylL4gzpf6rUFmdTOlrZJdRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 077/313] media: media/platform: fsl-viu.c: fix build for MICROBLAZE
Date:   Thu,  3 Oct 2019 17:50:55 +0200
Message-Id: <20191003154540.433851084@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6898dd580a045341f844862ceb775144156ec1af ]

arch/microblaze/ defines out_be32() and in_be32(), so don't do that
again in the driver source.

Fixes these build warnings:

../drivers/media/platform/fsl-viu.c:36: warning: "out_be32" redefined
../arch/microblaze/include/asm/io.h:50: note: this is the location of the previous definition
../drivers/media/platform/fsl-viu.c:37: warning: "in_be32" redefined
../arch/microblaze/include/asm/io.h:53: note: this is the location of the previous definition

Fixes: 29d750686331 ("media: fsl-viu: allow building it with COMPILE_TEST")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/fsl-viu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 691be788e38b3..b74e4f50d7d9f 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -32,7 +32,7 @@
 #define VIU_VERSION		"0.5.1"
 
 /* Allow building this driver with COMPILE_TEST */
-#ifndef CONFIG_PPC
+#if !defined(CONFIG_PPC) && !defined(CONFIG_MICROBLAZE)
 #define out_be32(v, a)	iowrite32be(a, (void __iomem *)v)
 #define in_be32(a)	ioread32be((void __iomem *)a)
 #endif
-- 
2.20.1



