Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FA6566E02
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiGEMbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbiGEM0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB244E8E;
        Tue,  5 Jul 2022 05:18:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A17A61983;
        Tue,  5 Jul 2022 12:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89099C341C7;
        Tue,  5 Jul 2022 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023504;
        bh=wraxMTguvxnPG3GTR6lwBTzZrcj2j30x7J86fvpGx5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7kQhz5EUFSLRdHZl/JTfAZbcrpIeb1PzTTQrQnY/VtRcGDnkOLjFc0pjeiW6soHb
         tmFPVsmjULUqdehB2y9gXIf9IN2bbbR7xsIcLB2R3IIyC+c3eFDzRBx6CNGXQOXLIF
         nq8Q1EAKgb8pBjAEMzcoS3XmzzkZMA/RlxJ8W16Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 043/102] net: ipv6: unexport __init-annotated seg6_hmac_net_init()
Date:   Tue,  5 Jul 2022 13:58:09 +0200
Message-Id: <20220705115619.633615794@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

commit 53ad46169fe2996fe1b623ba6c9c4fa33847876f upstream.

As of commit 5801f064e351 ("net: ipv6: unexport __init-annotated seg6_hmac_init()"),
EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

This remove the EXPORT_SYMBOL to fix modpost warning:

WARNING: modpost: vmlinux.o(___ksymtab+seg6_hmac_net_init+0x0): Section mismatch in reference from the variable __ksymtab_seg6_hmac_net_init to the function .init.text:seg6_hmac_net_init()
The symbol seg6_hmac_net_init is exported and annotated __init
Fix this by removing the __init annotation of seg6_hmac_net_init or drop the export.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20220628033134.21088-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_hmac.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -406,7 +406,6 @@ int __net_init seg6_hmac_net_init(struct
 
 	return rhashtable_init(&sdata->hmac_infos, &rht_params);
 }
-EXPORT_SYMBOL(seg6_hmac_net_init);
 
 void seg6_hmac_exit(void)
 {


