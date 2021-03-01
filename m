Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8793B32897C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhCAR51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238941AbhCARvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:51:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9F964F5C;
        Mon,  1 Mar 2021 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618041;
        bh=AILuiiJz2E4g9lh2Umst2pD5abNWxIQz3SJ8yvZQKfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ackiTZLC1YvNLbRj0pIBPtpb259ek5eyNGO+E8pV6FhJckEQfSfwetWzLuXWvWqmF
         I3DlLfFSXjFBQZX8/M5jC6B6mAQscKIVN1tgfECWwPBK6Utw+aVNv7CzBsqEE50TXm
         M9A6byZmF6w6RasxypiKwoYfHcQPrn/RWVT8wDZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 286/340] powerpc/prom: Fix "ibm,arch-vec-5-platform-support" scan
Date:   Mon,  1 Mar 2021 17:13:50 +0100
Message-Id: <20210301161102.365968218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit ed5b00a05c2ae95b59adc3442f45944ec632e794 upstream.

The "ibm,arch-vec-5-platform-support" property is a list of pairs of
bytes representing the options and values supported by the platform
firmware. At boot time, Linux scans this list and activates the
available features it recognizes : Radix and XIVE.

A recent change modified the number of entries to loop on and 8 bytes,
4 pairs of { options, values } entries are always scanned. This is
fine on KVM but not on PowerVM which can advertises less. As a
consequence on this platform, Linux reads extra entries pointing to
random data, interprets these as available features and tries to
activate them, leading to a firmware crash in
ibm,client-architecture-support.

Fix that by using the property length of "ibm,arch-vec-5-platform-support".

Fixes: ab91239942a9 ("powerpc/prom: Remove VLA in prom_check_platform_support()")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210122075029.797013-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/prom_init.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1305,14 +1305,10 @@ static void __init prom_check_platform_s
 		if (prop_len > sizeof(vec))
 			prom_printf("WARNING: ibm,arch-vec-5-platform-support longer than expected (len: %d)\n",
 				    prop_len);
-		prom_getprop(prom.chosen, "ibm,arch-vec-5-platform-support",
-			     &vec, sizeof(vec));
-		for (i = 0; i < sizeof(vec); i += 2) {
-			prom_debug("%d: index = 0x%x val = 0x%x\n", i / 2
-								  , vec[i]
-								  , vec[i + 1]);
-			prom_parse_platform_support(vec[i], vec[i + 1],
-						    &supported);
+		prom_getprop(prom.chosen, "ibm,arch-vec-5-platform-support", &vec, sizeof(vec));
+		for (i = 0; i < prop_len; i += 2) {
+			prom_debug("%d: index = 0x%x val = 0x%x\n", i / 2, vec[i], vec[i + 1]);
+			prom_parse_platform_support(vec[i], vec[i + 1], &supported);
 		}
 	}
 


