Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4D3111E76
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbfLCWxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbfLCWxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E26520863;
        Tue,  3 Dec 2019 22:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413592;
        bh=+MPkf+/1ZgSXTTcyRZTaHbIWLFnK7BZRQH9Tcq5LrlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQTSl5p4IAoCxM0u6O9oS7WXzyoLFN4csTVRAhG9pXlzv/mJC9CE5pbACAG6jqS+C
         c7JKT07qJvA5vcz8XGHXiICTe0gRzYp2+r01f6bRn6RRbKGtfJ7C/9U1/f9aqfnwuW
         fS7/799ZI+zg+IZ+lcbyfdssioVz05H8HD1SEtS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/321] um: Make GCOV depend on !KCOV
Date:   Tue,  3 Dec 2019 23:34:14 +0100
Message-Id: <20191203223436.901129745@linuxfoundation.org>
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

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 550ed0e2036663b35cec12374b835444f9c60454 ]

Both do more or less the same thing and are mutually exclusive.
If both are enabled the build will fail.
Sooner or later we can kill UML's GCOV.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig.debug b/arch/um/Kconfig.debug
index 2014597605ea9..85726eeec3451 100644
--- a/arch/um/Kconfig.debug
+++ b/arch/um/Kconfig.debug
@@ -16,6 +16,7 @@ config GPROF
 config GCOV
 	bool "Enable gcov support"
 	depends on DEBUG_INFO
+	depends on !KCOV
 	help
 	  This option allows developers to retrieve coverage data from a UML
 	  session.
-- 
2.20.1



