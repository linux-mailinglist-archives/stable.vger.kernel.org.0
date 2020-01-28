Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8914B947
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgA1O3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbgA1O3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620BD246A1;
        Tue, 28 Jan 2020 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221790;
        bh=6lpWIcc88biLNAPyYFo1TaYDUDDhUz3rViWY/n2XOkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOL7jM06OcD1Kd2Lnd5a9HlAOCFul8+v2Cc7cJOrJN0aerEOoYrdskGSRVya0IFNE
         4FC7aztm22c4eZwDeBEnvokndKcNA2wVsFQ+cAgYc2swkE2E7b9lsnhRC6fpU+J5kq
         bgkIB51jzAnvqLVSM/ypLdGPYYRRV32/fkyrf5JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yang <richard.weiyang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Seth Jennings <sjenning@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 4.19 72/92] drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS
Date:   Tue, 28 Jan 2020 15:08:40 +0100
Message-Id: <20200128135818.638247131@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yang <richard.weiyang@gmail.com>

commit 3b6fd6ffb27c2efa003c6d4d15ca72c054b71d7c upstream.

In cb5e39b8038b ("drivers: base: refactor add_memory_section() to
add_memory_block()"), add_memory_block() is introduced, which is only
invoked in memory_dev_init().

When combining these two loops in memory_dev_init() and
add_memory_block(), they looks like this:

    for (i = 0; i < NR_MEM_SECTIONS; i += sections_per_block)
        for (j = i;
	    (j < i + sections_per_block) && j < NR_MEM_SECTIONS;
	    j++)

Since it is sure the (i < NR_MEM_SECTIONS) and j sits in its own memory
block, the check of (j < NR_MEM_SECTIONS) is not necessary.

This patch just removes this check.

Link: http://lkml.kernel.org/r/20181123222811.18216-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -691,7 +691,7 @@ static int add_memory_block(int base_sec
 	int i, ret, section_count = 0, section_nr;
 
 	for (i = base_section_nr;
-	     (i < base_section_nr + sections_per_block) && i < NR_MEM_SECTIONS;
+	     i < base_section_nr + sections_per_block;
 	     i++) {
 		if (!present_section_nr(i))
 			continue;


