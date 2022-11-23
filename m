Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965E8635934
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiKWKJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbiKWKIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:08:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2440F56D42
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A026B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE4AC433D6;
        Wed, 23 Nov 2022 09:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197485;
        bh=524KJ0GvA9MOIvlIeW3/G8LyQQ3ZrlW2tM5Z43f4KK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrdyYntrYsMEtHyeAkxLZNe/Vabj6S6qFKITxS8NgHHpPaYTs2aU8s5l1uKIOLjBt
         6lXh5DDoE5hgdP6I2PkjHVlnQLMPMO4CxE7DP1xA5CJ8j4hCos6eDroRFjZFJpzaZn
         x8GN9w1OTACxOEvb89Rx9bh1558HXGM1Ltoo0xc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Borys=20Pop=C5=82awski?= <borysp@invisiblethingslab.com>,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.0 277/314] x86/sgx: Add overflow check in sgx_validate_offset_length()
Date:   Wed, 23 Nov 2022 09:52:02 +0100
Message-Id: <20221123084638.078879506@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit f0861f49bd946ff94fce4f82509c45e167f63690 upstream.

sgx_validate_offset_length() function verifies "offset" and "length"
arguments provided by userspace, but was missing an overflow check on
their addition. Add it.

Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Signed-off-by: Borys Popławski <borysp@invisiblethingslab.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -356,6 +356,9 @@ static int sgx_validate_offset_length(st
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
 
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >= encl->size)
 		return -EINVAL;
 


