Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A93F542D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733210AbfKHSzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731291AbfKHSy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77FD214DB;
        Fri,  8 Nov 2019 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239298;
        bh=8p8jZg3yN5igrYUTflVjMBoMf3YS9M66ksHw9gzGKIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqHU1e8b1gCM23Oaif2AoOU9Qb0FaLpqQj/qFiOIck8JMtbdW5jx5YYdeITiPl1t+
         sgUQiN2ngZsc8Ecp8KtjsnRABsv2qqeEPl2NL6IKwAR0W8Ntz138NnFLEip8rnFvZY
         PsEnUrU8upvSdubZxHzkdY4YZLkqpDQhNEzug8FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Binderman <dcb314@hotmail.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 66/75] ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc
Date:   Fri,  8 Nov 2019 19:50:23 +0100
Message-Id: <20191108174808.089975969@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 5df7a99bdd0de4a0480320264c44c04543c29d5a upstream.

In vfp_preserve_user_clear_hwstate, ufp_exc->fpinst2 gets assigned to
itself. It should actually be hwstate->fpinst2 that gets assigned to the
ufp_exc field.

Fixes commit 3aa2df6ec2ca6bc143a65351cca4266d03a8bc41 ("ARM: 8791/1:
vfp: use __copy_to_user() when saving VFP state").

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -583,7 +583,7 @@ int vfp_preserve_user_clear_hwstate(stru
 	 */
 	ufp_exc->fpexc = hwstate->fpexc;
 	ufp_exc->fpinst = hwstate->fpinst;
-	ufp_exc->fpinst2 = ufp_exc->fpinst2;
+	ufp_exc->fpinst2 = hwstate->fpinst2;
 
 	/* Ensure that VFP is disabled. */
 	vfp_flush_hwstate(thread);


