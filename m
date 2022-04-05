Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE66F4F3FFE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354046AbiDEMJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358078AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B701ED57;
        Tue,  5 Apr 2022 03:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67410B81BC5;
        Tue,  5 Apr 2022 10:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BEDC385A2;
        Tue,  5 Apr 2022 10:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153690;
        bh=UBmK10rXj2XHwAB4O1S/H943HEeDYiGEUvojg+iDfW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTp0YRh04ImH4gMrWnj4BFBuOtuTrIKzg8mro+jpHNIOYmootJKIXjCByfRFq+yNz
         0ZpU2PcqmD87LvzmmdkYjQTqLbBQa5oXbeD/3Nvict2Osb/w5BerrhxYH4X5AvQbpj
         noW+9NBlVP+H9zFULo2wAy6llqGIRarvtfvSaxnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/599] KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
Date:   Tue,  5 Apr 2022 09:29:39 +0200
Message-Id: <20220405070307.315987169@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 527c205d5a5f..38b7a3491aac 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5752,8 +5752,11 @@ static int kvmppc_book3s_init_hv(void)
 	if (r)
 		return r;
 
-	if (kvmppc_radix_possible())
+	if (kvmppc_radix_possible()) {
 		r = kvmppc_radix_init();
+		if (r)
+			return r;
+	}
 
 	/*
 	 * POWER9 chips before version 2.02 can't have some threads in
-- 
2.34.1



