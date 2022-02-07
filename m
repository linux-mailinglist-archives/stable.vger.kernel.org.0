Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A4E4ABC9E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386971AbiBGLiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385667AbiBGLcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE31EC0401C1;
        Mon,  7 Feb 2022 03:31:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C2A60B5B;
        Mon,  7 Feb 2022 11:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAA8C004E1;
        Mon,  7 Feb 2022 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233495;
        bh=5kuKbyyGYmLTOSeoatF/Dlu5tcSfSUYM07uZYakDJNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLU+MzoFYkCueOsp8BwjQH5MdVdoq8ML8zoDLHy2NZWCAhm2KuG2y2ewCYqcaRE02
         RClKM2bBVhLcPQHR3ygRk90N+V6/Vs/j3Fw3UQveiHm5eJQ0kSiZ+RSbzeCv0+/sSs
         /e5XWaeNmcmm81NjPmrtehJHirtJJxRIbKdXHfXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Christian Dietrich <stettberger@dokucode.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 031/126] mm/pgtable: define pte_index so that preprocessor could recognize it
Date:   Mon,  7 Feb 2022 12:06:02 +0100
Message-Id: <20220207103805.216538888@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Mike Rapoport <rppt@linux.ibm.com>

commit 314c459a6fe0957b5885fbc65c53d51444092880 upstream.

Since commit 974b9b2c68f3 ("mm: consolidate pte_index() and
pte_offset_*() definitions") pte_index is a static inline and there is
no define for it that can be recognized by the preprocessor.  As a
result, vm_insert_pages() uses slower loop over vm_insert_page() instead
of insert_pages() that amortizes the cost of spinlock operations when
inserting multiple pages.

Link: https://lkml.kernel.org/r/20220111145457.20748-1-rppt@kernel.org
Fixes: 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*() definitions")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Christian Dietrich <stettberger@dokucode.de>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pgtable.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -62,6 +62,7 @@ static inline unsigned long pte_index(un
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
+#define pte_index pte_index
 
 #ifndef pmd_index
 static inline unsigned long pmd_index(unsigned long address)


