Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57CB1FDBA0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgFRBNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgFRBNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A80121974;
        Thu, 18 Jun 2020 01:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442810;
        bh=3FCVTIUBK2FrT/pFejJuUW8MW0xWwlLn2woVgszM86s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GItDV1A18buH7DxTDQVPKPpFe26FGjQlqE5zh6cl0jeDMGzv2WQjZviOclyJzuDwS
         ZwIva4l75sxWWNo/+h9+IN+vMPn76871NDY9moTNu6RVFm2tMZNow3l/GrZflhrcaH
         TP7Feb1gOIXjxbafTXIA04xSdm/DVf+UcaQWiadM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 249/388] powerpc/powernv: add NULL check after kzalloc
Date:   Wed, 17 Jun 2020 21:05:46 -0400
Message-Id: <20200618010805.600873-249-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2b3dfd0b6cdd..d95954ad4c0a 100644
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

