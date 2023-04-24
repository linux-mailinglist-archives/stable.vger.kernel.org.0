Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E7A6ECE04
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjDXN2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjDXN2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C03A6E8F;
        Mon, 24 Apr 2023 06:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DF561C03;
        Mon, 24 Apr 2023 13:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C94C433EF;
        Mon, 24 Apr 2023 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342895;
        bh=tCCynyrnIJfQB2Eg5feIoBHwGYY3Vk1ymQA+xiDetCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10h13ytltXKD6Eqm7WJ7UHbF1PfEBaUjV9nwzD+Gawc/Xq9gdiSEfKIfP+3rnnc++
         5AGIqocdiuJNRBYAwhSru6JB1nhrSlww3qodVOMPO3TeUYpd0wF0JEhpumNCF2cLbt
         zKSOPrUIwHHjDvmr28g7qLgljBs9fsmzhyj6WMHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ekaterina Orlova <vorobushek.ok@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
        linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 98/98] ASN.1: Fix check for strdup() success
Date:   Mon, 24 Apr 2023 15:18:01 +0200
Message-Id: <20230424131137.698283414@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ekaterina Orlova <vorobushek.ok@gmail.com>

commit 5a43001c01691dcbd396541e6faa2c0077378f48 upstream.

It seems there is a misprint in the check of strdup() return code that
can lead to NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4520c6a49af8 ("X.509: Add simple ASN.1 grammar compiler")
Signed-off-by: Ekaterina Orlova <vorobushek.ok@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Link: https://lore.kernel.org/r/20230315172130.140-1-vorobushek.ok@gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/asn1_compiler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -625,7 +625,7 @@ int main(int argc, char **argv)
 	p = strrchr(argv[1], '/');
 	p = p ? p + 1 : argv[1];
 	grammar_name = strdup(p);
-	if (!p) {
+	if (!grammar_name) {
 		perror(NULL);
 		exit(1);
 	}


