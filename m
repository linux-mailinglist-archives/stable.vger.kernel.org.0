Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE51F397
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEOMPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbfEOLDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC8C2084F;
        Wed, 15 May 2019 11:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918200;
        bh=9jayAmZ96Peb62ShEspgOKUl4shoum84QGi9NLtYeyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ilc1L3WoPp0K7cXPvNNfPmzKkDX0xGKzAGWqhlV8ICMx88IKPej7wBsJY5/PBJU1l
         hYHi1h+V3GG5FiZTKZIs6wy08Womsk5SB7ctzkrXo8aRXmvbmW73e7/aWpk2viBedl
         9R0w1Rl3i26mhGL0WeM32F+3+MHQ4PhzcJ5oWavs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 043/266] powerpc/64s: Enhance the information in cpu_show_spectre_v1()
Date:   Wed, 15 May 2019 12:52:30 +0200
Message-Id: <20190515090723.935013021@linuxfoundation.org>
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

From: Michal Suchanek <msuchanek@suse.de>

commit a377514519b9a20fa1ea9adddbb4129573129cef upstream.

We now have barrier_nospec as mitigation so print it in
cpu_show_spectre_v1() when enabled.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -121,6 +121,9 @@ ssize_t cpu_show_spectre_v1(struct devic
 	if (!security_ftr_enabled(SEC_FTR_BNDS_CHK_SPEC_BAR))
 		return sprintf(buf, "Not affected\n");
 
+	if (barrier_nospec_enabled)
+		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+
 	return sprintf(buf, "Vulnerable\n");
 }
 


