Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69D21577B0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgBJNBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:01:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbgBJMkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:42 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F196C2467C;
        Mon, 10 Feb 2020 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338442;
        bh=UrvypBgypcPzAr+C9fAiejRCLfVDQOskhpqRCz/HBgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dawMGupoQph8NiUk6i31ISe46326wnJ5IyD8v5xtELE131ZPMY+jLpJjvcbMGCh5s
         Z0w5uCpx46cO3H46fnqSXVRHDjO/blFl3ZOJi7qYBycpHy13BGcKxUmIIOIGVV2R7A
         aGGljKp7jpaH48eEPv+WcAygiyplo2pZeqAo8yto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 180/367] crypto: ccp - set max RSA modulus size for v3 platform devices as well
Date:   Mon, 10 Feb 2020 04:31:33 -0800
Message-Id: <20200210122441.392218501@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 11548f5a5747813ff84bed6f2ea01100053b0d8d upstream.

AMD Seattle incorporates a non-PCI version of the v3 CCP crypto
accelerator, and this version was left behind when the maximum
RSA modulus size was parameterized in order to support v5 hardware
which supports larger moduli than v3 hardware does. Due to this
oversight, RSA acceleration no longer works at all on these systems.

Fix this by setting the .rsamax property to the appropriate value
for v3 platform hardware.

Fixes: e28c190db66830c0 ("csrypto: ccp - Expand RSA support for a v5 ccp")
Cc: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-dev-v3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -586,6 +586,7 @@ const struct ccp_vdata ccpv3_platform =
 	.setup = NULL,
 	.perform = &ccp3_actions,
 	.offset = 0,
+	.rsamax = CCP_RSA_MAX_WIDTH,
 };
 
 const struct ccp_vdata ccpv3 = {


