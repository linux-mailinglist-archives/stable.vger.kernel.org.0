Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F045355807E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiFWQqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiFWQqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD444993A;
        Thu, 23 Jun 2022 09:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A723E61F93;
        Thu, 23 Jun 2022 16:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A2AC3411B;
        Thu, 23 Jun 2022 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002772;
        bh=c5tXv7Sm5AN8vh85CRQru6QUw77VvvZ6qZ96H1GaVwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvMtM/q+j6TB8SONrVriTcnm9UGxrY3IL8njoWf32FwNFfJ1mZ5DLEhTtS3EBG18w
         2N5cgRYQxwb6ISUz+0jZ004Yah8D6AJiVfRbYlBD/Yfe2X1JOTOne5Wi7jw22ub5hz
         qQktkI6CFFrkAU0oEKgfu82FnZVfzDlpMUkAu/+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 020/264] random: rate limit unseeded randomness warnings
Date:   Thu, 23 Jun 2022 18:40:13 +0200
Message-Id: <20220623164344.637708538@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 4e00b339e264802851aff8e73cde7d24b57b18ce upstream.

On systems without sufficient boot randomness, no point spamming dmesg.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1637,8 +1637,9 @@ static void _warn_unseeded_randomness(co
 #ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
 	print_once = true;
 #endif
-	pr_notice("random: %s called from %pS with crng_init=%d\n",
-		  func_name, caller, crng_init);
+	if (__ratelimit(&unseeded_warning))
+		pr_notice("random: %s called from %pS with crng_init=%d\n",
+			  func_name, caller, crng_init);
 }
 
 /*


