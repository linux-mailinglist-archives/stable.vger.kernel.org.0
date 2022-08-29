Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D7D5A4A66
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbiH2Lhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiH2LhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD36461B3C;
        Mon, 29 Aug 2022 04:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F0E561185;
        Mon, 29 Aug 2022 11:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771CAC433C1;
        Mon, 29 Aug 2022 11:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771966;
        bh=9TpFLjXDWWPGSkUHylnED8xi99Am0soBk1z8T1wdQ/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y21Qnk3E//3apmt8RiGP/5U+uWMfhdeGIQJJbzpKU1ZCNgo50Lk1faCmvr6/44Gkr
         GhtHIf7W9/+AkQo5clbL/2MXCVRKMAeKIpJkzHiptRzPc+VB9IvjELKui1+2jmBojl
         VbUxq1wgoNrM//Y1PyCLNHpziuh8H/CYsiaQOX2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 123/158] shmem: update folio if shmem_replace_page() updates the page
Date:   Mon, 29 Aug 2022 12:59:33 +0200
Message-Id: <20220829105814.269068045@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 9dfb3b8d655022760ca68af11821f1c63aa547c3 upstream.

If we allocate a new page, we need to make sure that our folio matches
that new page.

If we do end up in this code path, we store the wrong page in the shmem
inode's page cache, and I would rather imagine that data corruption
ensues.

This will be solved by changing shmem_replace_page() to
shmem_replace_folio(), but this is the minimal fix.

Link: https://lkml.kernel.org/r/20220730042518.1264767-1-willy@infradead.org
Fixes: da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1771,6 +1771,7 @@ static int shmem_swapin_folio(struct ino
 
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
+		folio = page_folio(page);
 		if (error)
 			goto failed;
 	}


