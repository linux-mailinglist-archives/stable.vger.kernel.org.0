Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778E8566AEB
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiGEMDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiGEMCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BD6186E3;
        Tue,  5 Jul 2022 05:02:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCA196173E;
        Tue,  5 Jul 2022 12:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2138C341C7;
        Tue,  5 Jul 2022 12:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022546;
        bh=qia2sQbnPf7maq7rwyxNZhtZLSOraq0qbdQLQss+tPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZE9l6+ToJMv2ZSmqrgzYEpoZ2lwUcCF2xkbqOtB0Sb8MOsB0EznENPvt5KPmONMrD
         Tcm0pblbOIESosVoqiDHt+LcEJUujkwV/ubgbtfUb3HiywsFYhVFL1b1wyRMO0JVYv
         rJ7v55xZ/jknEM1+hJUo+aUY7dJBpfByvks1ZbW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 16/33] netfilter: nft_dynset: restore set element counter when failing to update
Date:   Tue,  5 Jul 2022 13:58:08 +0200
Message-Id: <20220705115607.185984810@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 05907f10e235680cc7fb196810e4ad3215d5e648 upstream.

This patch fixes a race condition.

nft_rhash_update() might fail for two reasons:

- Element already exists in the hashtable.
- Another packet won race to insert an entry in the hashtable.

In both cases, new() has already bumped the counter via atomic_add_unless(),
therefore, decrement the set element counter.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_hash.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -145,6 +145,7 @@ static bool nft_rhash_update(struct nft_
 	/* Another cpu may race to insert the element with the same key */
 	if (prev) {
 		nft_set_elem_destroy(set, he, true);
+		atomic_dec(&set->nelems);
 		he = prev;
 	}
 
@@ -154,6 +155,7 @@ out:
 
 err2:
 	nft_set_elem_destroy(set, he, true);
+	atomic_dec(&set->nelems);
 err1:
 	return false;
 }


