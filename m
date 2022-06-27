Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A355C31B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbiF0LyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbiF0Lw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8805BB49B;
        Mon, 27 Jun 2022 04:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E610E6125A;
        Mon, 27 Jun 2022 11:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0670DC3411D;
        Mon, 27 Jun 2022 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330309;
        bh=0/smJ2Sa+Gz1IrVE/v9XQNQbsuEP/ZS/Wm98OhSZgv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4+6vM/E/Ua/8K47JLWLHWDCjPPLTyotz+stZCWdhPgyPX8Ztik06M+LDMOgJc+mP
         Ambnb6iznq8TzCoF8SnRKfTP3E8Mlmn7MbkLYCqiUqj3gLMUIrZvxmpDqsQ5bNcVkk
         meysV+VcIyCRjHhF0Jf9UtoOGadF+zrKzEGyYTV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 154/181] parisc: Fix flush_anon_page on PA8800/PA8900
Date:   Mon, 27 Jun 2022 13:22:07 +0200
Message-Id: <20220627111949.148453471@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit e9ed22e6e5010997a2f922eef61ca797d0a2a246 upstream.

Anonymous pages are allocated with the shared mappings colouring,
SHM_COLOUR. Since the alias boundary on machines with PA8800 and
PA8900 processors is unknown, flush_user_cache_page() might not
flush all mappings of a shared anonymous page. Flushing the whole
data cache flushes all mappings.

This won't fix all coherency issues with shared mappings but it
seems to work well in practice.  I haven't seen any random memory
faults in almost a month on a rp3440 running as a debian buildd
machine.

There is a small preformance hit.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v5.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -722,7 +722,10 @@ void flush_anon_page(struct vm_area_stru
 		return;
 
 	if (parisc_requires_coherency()) {
-		flush_user_cache_page(vma, vmaddr);
+		if (vma->vm_flags & VM_SHARED)
+			flush_data_cache();
+		else
+			flush_user_cache_page(vma, vmaddr);
 		return;
 	}
 


