Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED06811AE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbjA3OQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbjA3OP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D64B3B677
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F157EB8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D18C433EF;
        Mon, 30 Jan 2023 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088154;
        bh=2BY6GzTK9RYrfOyad5chZwX5jIzkZJQd5mnrGsIhcGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ubj5Ese43I3qwHG61sgJ3tJqvBV8/euPH1vU/QBPMKu7PVXGRFKk5iknzw50n+KfH
         SLjvkAetD7Dd0c0PvLEhHfraANSveNGFJ0hMAWpFXaUnNxWHCUCnWYOGC0NwOFdFz9
         kyBN01oArTH6ZvOwjUsnM2Vqan4xICnci1nWQk64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/204] s390: expicitly align _edata and _end symbols on page boundary
Date:   Mon, 30 Jan 2023 14:51:09 +0100
Message-Id: <20230130134320.915532605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 45d619bdaf799196d702a9ae464b07066d6db2f9 ]

Symbols _edata and _end in the linker script are the
only unaligned expicitly on page boundary. Although
_end is aligned implicitly by BSS_SECTION macro that
is still inconsistent and could lead to a bug if a tool
or function would assume that _edata is as aligned as
others.

For example, vmem_map_init() function does not align
symbols _etext, _einittext etc. Should these symbols
be unaligned as well, the size of ranges to update
were short on one page.

Instead of fixing every occurrence of this kind in the
code and external tools just force the alignment on
these two symbols.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index b508ccad4856..8ce1615c1046 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -80,6 +80,7 @@ SECTIONS
 		_end_amode31_refs = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);
 	_edata = .;		/* End of data section */
 
 	/* will be freed after init */
@@ -194,6 +195,7 @@ SECTIONS
 
 	BSS_SECTION(PAGE_SIZE, 4 * PAGE_SIZE, PAGE_SIZE)
 
+	. = ALIGN(PAGE_SIZE);
 	_end = . ;
 
 	/*
-- 
2.39.0



