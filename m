Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0CD566B1C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiGEMEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiGEMD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C98CEB;
        Tue,  5 Jul 2022 05:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0457B61840;
        Tue,  5 Jul 2022 12:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CA2C341C7;
        Tue,  5 Jul 2022 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022604;
        bh=FKkgouZZjBPUrb7Wvw9iFLZz7PIMsh/l6Yr1v91nFWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBvAv5cnJbMnaOGgCcmaYLY1+hR9WV2mnCsSwQiAsDk0WGmtIA3bWqpFI1HCARFu+
         ZRjh5xcBWrUDRcwJj9jzm6ywTnfAC2M/E+PcbgdtcLaTSAJ8ch49WA7X1mXq/+/3B5
         yUuT4dCqEqm+mW4opCtNRNgLAWuwE2oXq8iqCgEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 28/33] xen/netfront: fix leaking data in shared pages
Date:   Tue,  5 Jul 2022 13:58:20 +0200
Message-Id: <20220705115607.537718504@linuxfoundation.org>
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
 drivers/net/xen-netfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -261,7 +261,7 @@ static struct sk_buff *xennet_alloc_one_
 	if (unlikely(!skb))
 		return NULL;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO);
 	if (!page) {
 		kfree_skb(skb);
 		return NULL;


