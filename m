Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB33ED6FD
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240857AbhHPNZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238898AbhHPNWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC28060F46;
        Mon, 16 Aug 2021 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119778;
        bh=6aBv2pSrJkl6CLCBzOkYwujCMC9Z6nZZvN454N3ncE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsFHL0xazThlSWM91/YtEK/9vo8zg0jMvmPXWTpH8msPoWmdwyaCIXBxy8dG+7PwV
         JKoukra+f516f0eIAAek+B7VgILwhynEedDTSvSvkj2KSWdT1kR4UVnclh8eM0rk+3
         7NTrAHvJ+WH20EX+VWtYVe8XXQa07PariQx8sucg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 137/151] powerpc/pseries: Fix update of LPAR security flavor after LPM
Date:   Mon, 16 Aug 2021 15:02:47 +0200
Message-Id: <20210816125448.570107497@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

commit c18956e6e0b95f78dad2773ecc8c61a9e41f6405 upstream.

After LPM, when migrating from a system with security mitigation enabled
to a system with mitigation disabled, the security flavor exposed in
/proc is not correctly set back to 0.

Do not assume the value of the security flavor is set to 0 when entering
init_cpu_char_feature_flags(), so when called after a LPM, the value is
set correctly even if the mitigation are not turned off.

Fixes: 6ce56e1ac380 ("powerpc/pseries: export LPAR security flavor in lparcfg")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210805152308.33988-1-ldufour@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -539,9 +539,10 @@ static void init_cpu_char_feature_flags(
 	 * H_CPU_BEHAV_FAVOUR_SECURITY_H could be set only if
 	 * H_CPU_BEHAV_FAVOUR_SECURITY is.
 	 */
-	if (!(result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY))
+	if (!(result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY)) {
 		security_ftr_clear(SEC_FTR_FAVOUR_SECURITY);
-	else if (result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY_H)
+		pseries_security_flavor = 0;
+	} else if (result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY_H)
 		pseries_security_flavor = 1;
 	else
 		pseries_security_flavor = 2;


