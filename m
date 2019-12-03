Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D136111E46
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfLCXAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729663AbfLCW6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7C620674;
        Tue,  3 Dec 2019 22:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413886;
        bh=KPDAVAKouFyIEFHXh9DD1GFKn0HUaQo3/0x6ooC9+u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09U03Vet6tmzWgQb1WvRHG4ePbTN0CPUdATTQFu8flNuNG5Y79Polp800h+Y9yIla
         4V3ZRNReMUWptmohGaCL/DIRnAEtVNiZzKmVQ/9e4puyM4ID6yHJIpAX3t2c+IGDfj
         6X3N6CwzGgLjYh7xm53BrqCH9bpTPOsaxG7BUfD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 260/321] powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()
Date:   Tue,  3 Dec 2019 23:35:26 +0100
Message-Id: <20191203223440.658123571@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index e3010b14aea51..c5ffcadab7302 100644
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



