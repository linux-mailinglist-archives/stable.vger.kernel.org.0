Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A55963DE17
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiK3SeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiK3Sde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9459208A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E8E61D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F8FC433D6;
        Wed, 30 Nov 2022 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833212;
        bh=SZsgRfaC9zLo3t82Oxv9SwbwRO9UQeL7U0vMYqQwdNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ORJ4RnksCWtydc+5gSqTCgsI2fLoDTIzJnPay7rC/TvXOXKHBfhaNyGAr1qgubYH
         oBPNTd4xx7nAl028Ji5ziAhOnbcJHXkPwOXVbJWqrGf3cKLcKCHD/aM6hgNhwtQ7ks
         bifNT0JmTXVbAbZPMwWeQAbXNVfe0yR0gJMz/4PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Borys=20Pop=C5=82awski?= <borysp@invisiblethingslab.com>,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/206] x86/sgx: Add overflow check in sgx_validate_offset_length()
Date:   Wed, 30 Nov 2022 19:21:19 +0100
Message-Id: <20221130180533.685757627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borys Popławski <borysp@invisiblethingslab.com>

[ Upstream commit f0861f49bd946ff94fce4f82509c45e167f63690 ]

sgx_validate_offset_length() function verifies "offset" and "length"
arguments provided by userspace, but was missing an overflow check on
their addition. Add it.

Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Signed-off-by: Borys Popławski <borysp@invisiblethingslab.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index a66795e0b685..217777c029ee 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -386,6 +386,9 @@ static int sgx_validate_offset_length(struct sgx_encl *encl,
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
 
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >= encl->size)
 		return -EINVAL;
 
-- 
2.35.1



