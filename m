Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27604F2832
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiDEILQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiDEIFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:05:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1474A68336;
        Tue,  5 Apr 2022 01:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5AE2B81B90;
        Tue,  5 Apr 2022 08:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116EBC340EE;
        Tue,  5 Apr 2022 08:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145678;
        bh=3DLPFpwpBfYmtbHQR4E9B3L8j/zW8+jMh4WpLzPmq9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIkjv8ypOekBuxRklTmctCq5ObYlAzJeOx0zl9TsWOJ8VkQDlxxQr7PYu5bPwhvGB
         /ufPDRBi8ies6N9djrApxe6+CCEYa3nNMpM/QApAbdsxjF743tJ37NHbXCy5pxjT45
         d6zHX9RHeqr+VpT1YdTy9maN0V/NRdfvpqHCLoRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0490/1126] KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
Date:   Tue,  5 Apr 2022 09:20:37 +0200
Message-Id: <20220405070422.010412441@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit 69ab6ac380a00244575de02c406dcb9491bf3368 ]

The return of the function is being shadowed by the call to
kvmppc_uvmem_init.

Fixes: ca9f4942670c ("KVM: PPC: Book3S HV: Support for running secure guests")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220125155735.1018683-2-farosas@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 84c89f08ae9a..791db769080d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6137,8 +6137,11 @@ static int kvmppc_book3s_init_hv(void)
 	if (r)
 		return r;
 
-	if (kvmppc_radix_possible())
+	if (kvmppc_radix_possible()) {
 		r = kvmppc_radix_init();
+		if (r)
+			return r;
+	}
 
 	r = kvmppc_uvmem_init();
 	if (r < 0)
-- 
2.34.1



