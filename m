Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE0C4A4279
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359745AbiAaLMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377284AbiAaLJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA60C0613AF;
        Mon, 31 Jan 2022 03:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 923C8B82A66;
        Mon, 31 Jan 2022 11:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66A3C340E8;
        Mon, 31 Jan 2022 11:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627214;
        bh=q4g6WrY1W9xY5WRkJbOfJqxiyiK4Xyb8TkSLTc0u194=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlxrGe1yE/96xQobXT3kniuWK2wV19XyqJiKOjsm5yNS56v09yQPx/TQrDORd2kKH
         SlpQafpNNgv1H1yyitruCOae4J7kwLhWnfsaho+xCvn0nE32c+KuOtNXMK/C1N3A24
         RiMFUWwQVftbG8X7aSWuitrpsujRwmPp+pRdpuv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 011/171] s390/nmi: handle vector validity failures for KVM guests
Date:   Mon, 31 Jan 2022 11:54:36 +0100
Message-Id: <20220131105230.381599988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit f094a39c6ba168f2df1edfd1731cca377af5f442 upstream.

The machine check validity bit tells about the context. If a KVM guest
was running the bit tells about the guest validity and the host state is
not affected. As a guest can disable the guest validity this might
result in unwanted host errors on machine checks.

Cc: stable@vger.kernel.org
Fixes: c929500d7a5a ("s390/nmi: s390: New low level handling for machine check happening in guest")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/nmi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -273,7 +273,14 @@ static int notrace s390_validate_registe
 		/* Validate vector registers */
 		union ctlreg0 cr0;
 
-		if (!mci.vr) {
+		/*
+		 * The vector validity must only be checked if not running a
+		 * KVM guest. For KVM guests the machine check is forwarded by
+		 * KVM and it is the responsibility of the guest to take
+		 * appropriate actions. The host vector or FPU values have been
+		 * saved by KVM and will be restored by KVM.
+		 */
+		if (!mci.vr && !test_cpu_flag(CIF_MCCK_GUEST)) {
 			/*
 			 * Vector registers can't be restored. If the kernel
 			 * currently uses vector registers the system is


