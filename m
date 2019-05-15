Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534F51F395
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfEOMPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbfEOLDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5D932084F;
        Wed, 15 May 2019 11:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918216;
        bh=QnGRBBOKsC3EgzmdCurkiDL3HEHZU7zxAVd+0MEfDx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp5WL4A0pJsc2Y0AeFBnmhudYQJ1pA1DStFIaR4rvLyxdVgmLyJanguONORU5x3QB
         4+aAv6tiQTkLD0iaYGnOM7tGAbikTSoKMPHZIfplmK2+5YiHly8pwr0rB59H8hsXtB
         AorOLn2cOqTrb0AjIIYpI+SRzMUPaZeUeCnHJ20Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 049/266] powerpc/64: Make meltdown reporting Book3S 64 specific
Date:   Wed, 15 May 2019 12:52:36 +0200
Message-Id: <20190515090724.109908692@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 406d2b6ae3420f5bb2b3db6986dc6f0b6dbb637b upstream.

In a subsequent patch we will enable building security.c for Book3E.
However the NXP platforms are not vulnerable to Meltdown, so make the
Meltdown vulnerability reporting PPC_BOOK3S_64 specific.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
[mpe: Split out of larger patch]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -93,6 +93,7 @@ static __init int barrier_nospec_debugfs
 device_initcall(barrier_nospec_debugfs_init);
 #endif /* CONFIG_DEBUG_FS */
 
+#ifdef CONFIG_PPC_BOOK3S_64
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	bool thread_priv;
@@ -125,6 +126,7 @@ ssize_t cpu_show_meltdown(struct device
 
 	return sprintf(buf, "Vulnerable\n");
 }
+#endif
 
 ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr, char *buf)
 {


