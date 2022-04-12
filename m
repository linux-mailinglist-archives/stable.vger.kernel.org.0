Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6E34FD8B2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377601AbiDLHuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359413AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA2C2CE16;
        Tue, 12 Apr 2022 00:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E418B81B13;
        Tue, 12 Apr 2022 07:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D139AC385A5;
        Tue, 12 Apr 2022 07:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748180;
        bh=eMM8OKCs1XS4pP/lEvBAbkA9WBA3mZDUkQodzz0SW4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SP1eip46TXekRyvJDQyOy/NR7EtRRpNjqo1hqP5v7FI+6+9dxPh3ceo1C4lvW+o5R
         tMETEv+w0odddZCBx0H/YouejJVz7o4QIvIuK7LFBdzBimXyYI/QRFmv6bTIClER1/
         BRBrpfKppaWihHrMyqRybmNETehx4j3PkHkPNjV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Erhard F." <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.17 328/343] Revert "powerpc: Set max_mapnr correctly"
Date:   Tue, 12 Apr 2022 08:32:26 +0200
Message-Id: <20220412063000.787106591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 1ff5c8e8c835e8a81c0868e3050c76563dd56a2c upstream.

This reverts commit 602946ec2f90d5bd965857753880db29d2d9a1e9.

If CONFIG_HIGHMEM is enabled, no highmem will be added with max_mapnr
set to max_low_pfn, see mem_init():

  for (pfn = highmem_mapnr; pfn < max_mapnr; ++pfn) {
        ...
        free_highmem_page();
  }

Now that virt_addr_valid() has been fixed in the previous commit, we can
revert the change to max_mapnr.

Fixes: 602946ec2f90 ("powerpc: Set max_mapnr correctly")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: Erhard F. <erhard_f@mailbox.org>
[mpe: Update change log to reflect series reordering]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220406145802.538416-2-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -255,7 +255,7 @@ void __init mem_init(void)
 #endif
 
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
-	set_max_mapnr(max_low_pfn);
+	set_max_mapnr(max_pfn);
 
 	kasan_late_init();
 


