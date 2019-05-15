Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29531F39C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfEOMQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfEOLCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DC6420644;
        Wed, 15 May 2019 11:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918174;
        bh=fBqlloFfPp0VUbFf7RR1Xs02R46J1Husg8dIuPEhGz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WELtjBGXOP/B32ZFCTl/JiGVSjLuYvk+46yjLdRghCoLOSl0qHAHQ3HpsDFZXASZ8
         vId711f5EpOXeYtPlxJ+74QQJU/j8UX9FeVxSNOF4Wx4AoJPt8QZWer9kPxqzJ/7cS
         RVscLQvv04l9VxRclfrnkviqAEj5U5ZiyjaU1vKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 034/266] powerpc/pseries: Restore default security feature flags on setup
Date:   Wed, 15 May 2019 12:52:21 +0200
Message-Id: <20190515090723.680607363@linuxfoundation.org>
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

From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

commit 6232774f1599028a15418179d17f7df47ede770a upstream.

After migration the security feature flags might have changed (e.g.,
destination system with unpatched firmware), but some flags are not
set/clear again in init_cpu_char_feature_flags() because it assumes
the security flags to be the defaults.

Additionally, if the H_GET_CPU_CHARACTERISTICS hypercall fails then
init_cpu_char_feature_flags() does not run again, which potentially
might leave the system in an insecure or sub-optimal configuration.

So, just restore the security feature flags to the defaults assumed
by init_cpu_char_feature_flags() so it can set/clear them correctly,
and to ensure safe settings are in place in case the hypercall fail.

Fixes: f636c14790ea ("powerpc/pseries: Set or clear security feature flags")
Depends-on: 19887d6a28e2 ("powerpc: Move default security feature flags")
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -502,6 +502,10 @@ static void __init find_and_init_phbs(vo
 
 static void init_cpu_char_feature_flags(struct h_cpu_char_result *result)
 {
+	/*
+	 * The features below are disabled by default, so we instead look to see
+	 * if firmware has *enabled* them, and set them if so.
+	 */
 	if (result->character & H_CPU_CHAR_SPEC_BAR_ORI31)
 		security_ftr_set(SEC_FTR_SPEC_BAR_ORI31);
 
@@ -541,6 +545,13 @@ void pseries_setup_rfi_flush(void)
 	bool enable;
 	long rc;
 
+	/*
+	 * Set features to the defaults assumed by init_cpu_char_feature_flags()
+	 * so it can set/clear again any features that might have changed after
+	 * migration, and in case the hypercall fails and it is not even called.
+	 */
+	powerpc_security_features = SEC_FTR_DEFAULT;
+
 	rc = plpar_get_cpu_characteristics(&result);
 	if (rc == H_SUCCESS)
 		init_cpu_char_feature_flags(&result);


