Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9EF106409
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVGOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbfKVGOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:14:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F1C2071F;
        Fri, 22 Nov 2019 06:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403258;
        bh=9vNUBEm3iSdcJ3wWOLFUtnZXXvnk48gtvjt/MMCjFCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5oKORer1Pr0H4NpLsjGfbVzYi5/XHrDVPtuiKf0bZPN+hfH1PagZUSn4JWIAp4uZ
         WiWVi9ahOHomM9raI/4MvdqSZg1wnbn7F3JySc77hEF5C1jowfi1Y7vYyZquL9eb6a
         jTlNfy038566Rl39KrWoLaZmIovxlJBhMzMTNZIY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 67/68] powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()
Date:   Fri, 22 Nov 2019 01:13:00 -0500
Message-Id: <20191122061301.4947-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

[ Upstream commit efa9ace68e487ddd29c2b4d6dd23242158f1f607 ]

In dlpar_parse_cc_property(), 'prop->name' is allocated by kstrdup().
kstrdup() may return NULL, so it should be checked and handle error.
And prop should be freed if 'prop->name' is NULL.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/dlpar.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index a8efed3b46916..551ba5b35df9d 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -55,6 +55,10 @@ static struct property *dlpar_parse_cc_property(struct cc_workarea *ccwa)
 
 	name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
 	prop->name = kstrdup(name, GFP_KERNEL);
+	if (!prop->name) {
+		dlpar_free_cc_property(prop);
+		return NULL;
+	}
 
 	prop->length = be32_to_cpu(ccwa->prop_length);
 	value = (char *)ccwa + be32_to_cpu(ccwa->prop_offset);
-- 
2.20.1

