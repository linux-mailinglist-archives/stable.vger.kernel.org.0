Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9669B11324A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfLDSHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730720AbfLDSHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:12 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2B720674;
        Wed,  4 Dec 2019 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482832;
        bh=5flbKH9/7SuKJsXQ0njpu5dTP+T8KsdOIIJV4h6GRxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4mJawuB+gfQdJNdfqFB2+UBM4TrX/STsd3+BahrOFhs+zBK6rMOp9DV9QltGX8N8
         7cvcnq0f44BjV5o0m7ZEcGfbqpblpEFW23YzaXUbecO33eLXJgok1vdy3ooiC/9CVK
         VjoCfUMsqtGrVDdaBJ3g5pEUw6mS3PlZ6rhW+bFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 153/209] powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()
Date:   Wed,  4 Dec 2019 18:56:05 +0100
Message-Id: <20191204175334.024557953@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f4e6565dd7a94..fb2876a84fbe6 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -63,6 +63,10 @@ static struct property *dlpar_parse_cc_property(struct cc_workarea *ccwa)
 
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



