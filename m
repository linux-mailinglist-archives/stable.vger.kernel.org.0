Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D1769CEAF
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjBTOBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbjBTOBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FF040D1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8033A60EA9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687F6C4339B;
        Mon, 20 Feb 2023 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901665;
        bh=sjgsz3c8n70ksdfQZ9ZS5upurlZUOxiLckSJ6GVoooA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wV6CvF/GE2nVV9Wkjs9hrFTujeIgs/9E2gxg6oU5WgOUa2jxlq1HgjfPI141o7Bry
         V9E0flu2aGvv7ZwH5RbgHRRgJ92IBpbkxhk764K2ys+i69ej3txHCf8DoIMrnCihe8
         8UPwwmi5cyBqsewG/SR6IjVbC7NUfyanRT9tgjQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        Alistair Popple <apopple@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Andrew Yang <andrew.yang@mediatek.com>,
        Chinwen Chang <chinwen.chang@mediatek.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 105/118] mm/gup: add folio to list when folio_isolate_lru() succeed
Date:   Mon, 20 Feb 2023 14:37:01 +0100
Message-Id: <20230220133604.597795638@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>

commit aa1e6a932ca652a50a5df458399724a80459f521 upstream.

If we call folio_isolate_lru() successfully, we will get return value 0.
We need to add this folio to the movable_pages_list.

Link: https://lkml.kernel.org/r/20230131063206.28820-1-Kuan-Ying.Lee@mediatek.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Yang <andrew.yang@mediatek.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1978,7 +1978,7 @@ static unsigned long collect_longterm_un
 			drain_allow = false;
 		}
 
-		if (!folio_isolate_lru(folio))
+		if (folio_isolate_lru(folio))
 			continue;
 
 		list_add_tail(&folio->lru, movable_page_list);


