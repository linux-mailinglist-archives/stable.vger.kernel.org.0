Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6046DEEFE
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjDLIqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjDLIqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141CD8A5E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 413AC630FF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508F6C433D2;
        Wed, 12 Apr 2023 08:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289150;
        bh=+Z6jPUfrCEHRld+QaS2VOUXo7Ti+2BxTspgq9hlnlOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyv5hDV7o8bhpEIBTpKqmGLhsgck2Swx34xp5ELbNOV6XeYeXg+/6NRvMe1LEYtxs
         20D5+n55mNZgfBn5tqEquTlq1qmBTjQQwdfC0T9FZmX4eOmUwiTfKSG2+EfIYARvwP
         NB1IORmNDDRXVLvm+IMitJgCt3grm6mhnBVerVuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.1 155/164] maple_tree: fix handle of invalidated state in mas_wr_store_setup()
Date:   Wed, 12 Apr 2023 10:34:37 +0200
Message-Id: <20230412082843.233118104@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 1202700c3f8cc5f7e4646c3cf05ee6f7c8bc6ccf upstream.

If an invalidated maple state is encountered during write, reset the maple
state to MAS_START.  This will result in a re-walk of the tree to the
correct location for the write.

Link: https://lore.kernel.org/all/20230107020126.1627-1-sj@kernel.org/
Link: https://lkml.kernel.org/r/20230120162650.984577-6-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5594,6 +5594,9 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (unlikely(mas_is_paused(wr_mas->mas)))
+		mas_reset(wr_mas->mas);
+
 	if (!mas_is_start(wr_mas->mas)) {
 		if (mas_is_none(wr_mas->mas)) {
 			mas_reset(wr_mas->mas);


