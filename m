Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A338D6DEEE6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjDLIqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjDLIqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A6729B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B16630EE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E259DC433D2;
        Wed, 12 Apr 2023 08:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289143;
        bh=rhi6J++f4rqhiv07r2vO90Cjq/oKDhsF+YByW6JLAHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyZG7Ew0HpWxJVCEIabDvzHu0Gyx/zVc7oslgGlWbNJPko0Ymymodpud3O5Chk+Er
         FHntRb9vpeOI28g2oEkOMcfjuCJiDVyU8k6OanIqjJUpCCPr/5cqvmPJB2sU/q4Flr
         0RmBONVgVRcq0Iv9r4bkUMeIoQPTQB3nCJNXnhSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 153/164] maple_tree: fix potential rcu issue
Date:   Wed, 12 Apr 2023 10:34:35 +0200
Message-Id: <20230412082843.137992966@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 65be6f058b0eba98dc6c6f197ea9f62c9b6a519f upstream.

Ensure the node isn't dead after reading the node end.

Link: https://lkml.kernel.org/r/20230120162650.984577-3-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4650,13 +4650,13 @@ static inline void *mas_next_nentry(stru
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	count = ma_data_end(node, type, pivots, mas->max);
 	if (ma_dead_node(node))
 		return NULL;
 
 	if (mas->index > max)
 		return NULL;
 
-	count = ma_data_end(node, type, pivots, mas->max);
 	if (mas->offset > count)
 		return NULL;
 


