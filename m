Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C121579C80
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241179AbiGSMkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241328AbiGSMjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B247A52FDF;
        Tue, 19 Jul 2022 05:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48AC56178A;
        Tue, 19 Jul 2022 12:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A91C341C6;
        Tue, 19 Jul 2022 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232944;
        bh=sXZL6Z37ACoS8mPQ/3ZughF+dsMb+90JYpKbHlk9Vzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0oA2wLBCByUtKMd5s7Eb5qjO2jYjiZFhOPoQT2DRw5l3eiVfOWkzg3sol6N1Lh5V
         8dw5GPULp6KcifDb305aU0jNZz9Wn3hO2TpnICTOglfi9sG+js4ml0mDiZAEU/0xNE
         9tH9Mu94cC/71F8WXji+Mjsp0/6g28HwKM0gxFig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/167] ima: Fix potential memory leak in ima_init_crypto()
Date:   Tue, 19 Jul 2022 13:53:48 +0200
Message-Id: <20220719114705.765300501@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 067d2521874135267e681c19d42761c601d503d6 ]

On failure to allocate the SHA1 tfm, IMA fails to initialize and exits
without freeing the ima_algo_array. Add the missing kfree() for
ima_algo_array to avoid the potential memory leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Fixes: 6d94809af6b0 ("ima: Allocate and initialize tfm for each PCR bank")
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index a7206cc1d7d1..64499056648a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -205,6 +205,7 @@ int __init ima_init_crypto(void)
 
 		crypto_free_shash(ima_algo_array[i].tfm);
 	}
+	kfree(ima_algo_array);
 out:
 	crypto_free_shash(ima_shash_tfm);
 	return rc;
-- 
2.35.1



