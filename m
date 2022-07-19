Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF1579AFA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiGSMWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbiGSMWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:22:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C24F5C376;
        Tue, 19 Jul 2022 05:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3C4B81B1A;
        Tue, 19 Jul 2022 12:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E902EC341C6;
        Tue, 19 Jul 2022 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232461;
        bh=UWyRdUbZ+4+sGFdCn0lE/K6GVaJrH++vlaoIujAs+NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tF1ZQkEAe1UubSCOOw9VzxYF7j+OAjLc0RohMODG/6N6KYsIt46kp61e0UQRFMkHE
         OXtp63YTgDpl0M9/wjFkWTurLQByhlH7fXvpWZ+I3MRcQGsjmCjPRSAElD+ZKfNECN
         xlf8d0TRF3SiF/9S2YMLQ60pMW03l/e75DoOSZuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/112] ima: Fix potential memory leak in ima_init_crypto()
Date:   Tue, 19 Jul 2022 13:53:59 +0200
Message-Id: <20220719114632.864305701@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
index f6a7e9643b54..b1e5e7749e41 100644
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



