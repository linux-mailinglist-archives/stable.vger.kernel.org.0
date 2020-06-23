Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031752065DB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbgFWVeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388374AbgFWULB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED2A20707;
        Tue, 23 Jun 2020 20:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943061;
        bh=SaQqvQFMNTh+YxDu89iw6n8Oqci79i/uH0NDjdrZvCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+X7svdXPSwPRP+i6eIEuYxi9iM0WYYXsL1IImrhPOUWEc88W/viIDR8NtwRKTVYq
         Fppw2MxHKASPfgnJIgLMazbeg+3Ut4L0HTesCvXLu3Xva1hjYW+5yOHjt29DYY5zv3
         Ndzwzyk0ZxMxZWi8wiA0g6kl6pKtRdoyRvZ9m6Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 245/477] powerpc/powernv: add NULL check after kzalloc
Date:   Tue, 23 Jun 2020 21:54:02 +0200
Message-Id: <20200623195419.151216738@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit ceffa63acce7165c442395b7d64a11ab8b5c5dca ]

Fixes coccicheck warning:

./arch/powerpc/platforms/powernv/opal.c:813:1-5:
	alloc with no test, possible model on line 814

Add NULL check after kzalloc.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200509020838.121660-1-chenzhou10@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 2b3dfd0b6cdd8..d95954ad4c0af 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -811,6 +811,10 @@ static int opal_add_one_export(struct kobject *parent, const char *export_name,
 		goto out;
 
 	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	name = kstrdup(export_name, GFP_KERNEL);
 	if (!name) {
 		rc = -ENOMEM;
-- 
2.25.1



