Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2123A707
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHCMVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgHCMVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63BB72076B;
        Mon,  3 Aug 2020 12:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457294;
        bh=SI4guhhE2Hhs6w+Ur05GGFq95nzWVWAWKAnbRaNmCxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnPdun6rxGy5vAm9xJxKkf9j1gATCtLKRyTfcwvfblAuBwJrLn8oXomZql91f1/Yn
         f/v8SPRGsfZiEhbOVItpwMEdqBOvUUvO/6xAK2wCO0D87OvaXdkLnoZAb71yS9wmmJ
         c8303Ca3RPWyNB2JdN0XHlVrirQNzWaa+23LygKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>,
        Robin Murphy <robin.mruphy@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.7 016/120] ARM: 8987/1: VDSO: Fix incorrect clock_gettime64
Date:   Mon,  3 Aug 2020 14:17:54 +0200
Message-Id: <20200803121903.649075309@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaedon Shin <jaedon.shin@gmail.com>

commit 4405bdf3c57ec28d606bdf5325f1167505bfdcd4 upstream.

__vdso_*() should be removed and fallback used if CNTCVT is not
available by cntvct_functional(). __vdso_clock_gettime64 when added
previous commit is using the incorrect CNTCVT value in that state.
__vdso_clock_gettime64 is also added to remove it's symbol.

Cc: stable@vger.kernel.org
Fixes: 74d06efb9c2f ("ARM: 8932/1: Add clock_gettime64 entry point")
Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Tested-by: Robin Murphy <robin.mruphy@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/vdso.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -184,6 +184,7 @@ static void __init patch_vdso(void *ehdr
 	if (!cntvct_ok) {
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
 	}
 }
 


