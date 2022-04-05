Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642EF4F32B6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiDEJLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244704AbiDEIwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E7D18E24;
        Tue,  5 Apr 2022 01:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B174B609D0;
        Tue,  5 Apr 2022 08:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B576C385A1;
        Tue,  5 Apr 2022 08:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148141;
        bh=YQar6ezHZkPY8X6SYpKiX/qtDQj2Nb/lf+/JJVypKo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruQKorjoV32pU39DqmwNgMmTSWyTIew6GNyb5YXkNdhOMPzG+HkcfhR7LfiWR9dZE
         iF34rM5Egm5c+mApDleQUXP7EM6wjRzcWuiMFZqyO+E7xJVMM5GGGsQtKNesRitkJV
         4W0FnMbcA9b3jT+mOMhZk8D8D/YVtKQqXHeMSP6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0248/1017] KEYS: trusted: Avoid calling null function trusted_key_exit
Date:   Tue,  5 Apr 2022 09:19:21 +0200
Message-Id: <20220405070401.621647117@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit c5d1ed846e15090bc90dfdaafc07eac066e070bb ]

If one loads and unloads the trusted module, trusted_key_exit can be
NULL. Call it through static_call_cond() to avoid a kernel trap.

Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-integrity@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 5b35f1b87644..9b9d3ef79cbe 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -351,7 +351,7 @@ static int __init init_trusted(void)
 
 static void __exit cleanup_trusted(void)
 {
-	static_call(trusted_key_exit)();
+	static_call_cond(trusted_key_exit)();
 }
 
 late_initcall(init_trusted);
-- 
2.34.1



