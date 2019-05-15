Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A816C1F3EF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfEOLCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfEOLCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6738F20881;
        Wed, 15 May 2019 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918123;
        bh=eps0wC4V8dUVTWuAxqEzfJG8jA45lfAepcQRQ4nX61c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHnhlJZskNwUNuLkgxEiGNupBIKUYA+yX6MKfw8Fjv7x7n+WpdQwhuUvYbW6G4jPL
         tGeG5YvvcJ95wmWW27V9+h38CcLs32FUNqQ/rAd2Ugpp+6fnbUYzTQK+0Kqikl3NMZ
         0cPJ9myV1LRBq8lvGxq2euCmYbw6A67IlUWoQFJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 015/266] powerpc/pseries: Support firmware disable of RFI flush
Date:   Wed, 15 May 2019 12:52:02 +0200
Message-Id: <20190515090723.143583801@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 582605a429e20ae68fd0b041b2e840af296edd08 upstream.

Some versions of firmware will have a setting that can be configured
to disable the RFI flush, add support for it.

Fixes: 8989d56878a7 ("powerpc/pseries: Query hypervisor for RFI flush settings")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -522,7 +522,8 @@ static void pseries_setup_rfi_flush(void
 		if (types == L1D_FLUSH_NONE)
 			types = L1D_FLUSH_FALLBACK;
 
-		if (!(result.behaviour & H_CPU_BEHAV_L1D_FLUSH_PR))
+		if ((!(result.behaviour & H_CPU_BEHAV_L1D_FLUSH_PR)) ||
+		    (!(result.behaviour & H_CPU_BEHAV_FAVOUR_SECURITY)))
 			enable = false;
 	} else {
 		/* Default to fallback if case hcall is not available */


