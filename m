Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46DC566E29
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbiGEMbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbiGEM0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D837C19029;
        Tue,  5 Jul 2022 05:19:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57725619A6;
        Tue,  5 Jul 2022 12:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65579C341C7;
        Tue,  5 Jul 2022 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023540;
        bh=pyhdauLBoqSjSiGXmzPG8RWnckzy4jcB2XZZJLH8K1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCYfO4Lj18bsox+Nbdr/ZGRd1MKrHQO3C8/YZD2CS6e3VeL9uLLd70/IQJRGaNs1c
         7RQAWBtJIa1CWDloaE/j9SsUPkD3mT4xlxckNbGBt0VR1x5zDjvH6xsC12jnlHLbRI
         N8kQKSm5108Zn6+nvOiQCi78IbcPX7XYBj+9N0Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.18 098/102] xen/netfront: fix leaking data in shared pages
Date:   Tue,  5 Jul 2022 13:59:04 +0200
Message-Id: <20220705115621.199811906@linuxfoundation.org>
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

From: Roger Pau Monne <roger.pau@citrix.com>

commit 307c8de2b02344805ebead3440d8feed28f2f010 upstream.

When allocating pages to be used for shared communication with the
backend always zero them, this avoids leaking unintended data present
on the pages.

This is CVE-2022-33740, part of XSA-403.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -273,7 +273,8 @@ static struct sk_buff *xennet_alloc_one_
 	if (unlikely(!skb))
 		return NULL;
 
-	page = page_pool_dev_alloc_pages(queue->page_pool);
+	page = page_pool_alloc_pages(queue->page_pool,
+				     GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO);
 	if (unlikely(!page)) {
 		kfree_skb(skb);
 		return NULL;


