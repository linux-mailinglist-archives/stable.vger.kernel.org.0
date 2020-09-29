Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE227C700
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbgI2Lu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731238AbgI2Ltg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37D0206F7;
        Tue, 29 Sep 2020 11:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380175;
        bh=QhpylXSovAr803ccce08lA6goq2bd3jxBCSOdP7ETj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gdhzx97zi+7o9+RE7vkoVfRL0xZRUT4URnp459iyuwZLtD3Y4O9lfrWuhp4vLek8
         GLQfu9LwVk5b67Dxd9Z7oVAw0kltDgtgEHvxzksPTXVCvpKAvOI2nJnMV/h+uKDe0M
         /QQKXgcPQ6LCKKsaNoOIFarM8qJB1e3ukcJ+ea/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.8 89/99] MIPS: Loongson2ef: Disable Loongson MMI instructions
Date:   Tue, 29 Sep 2020 13:02:12 +0200
Message-Id: <20200929105934.120324540@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit b13812ddea615b6507beef24f76540c0c1143c5c upstream.

It was missed when I was forking Loongson2ef from Loongson64 but
should be applied to Loongson2ef as march=loongson2f
will also enable Loongson MMI in GCC-9+.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Fixes: 71e2f4dd5a65 ("MIPS: Fork loongson2ef from loongson64")
Reported-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/loongson2ef/Platform |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/loongson2ef/Platform
+++ b/arch/mips/loongson2ef/Platform
@@ -22,6 +22,10 @@ ifdef CONFIG_CPU_LOONGSON2F_WORKAROUNDS
   endif
 endif
 
+# Some -march= flags enable MMI instructions, and GCC complains about that
+# support being enabled alongside -msoft-float. Thus explicitly disable MMI.
+cflags-y += $(call cc-option,-mno-loongson-mmi)
+
 #
 # Loongson Machines' Support
 #


