Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ED4551D9D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbiFTOEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347118AbiFTOC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEA13CA60;
        Mon, 20 Jun 2022 06:26:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B19BEB811C3;
        Mon, 20 Jun 2022 13:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031FEC385A5;
        Mon, 20 Jun 2022 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730670;
        bh=olGKnJi4hX2P6Qx9ZW0XwLZQztWNba/bvqtQILWDJq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A07hZQ+CPmtfRMExGd2Y7yQKuGkRaHktx4UUc8H0DDpOBR5sE7Rr6nsjQCXqk0NVb
         oZbK5m3Kx/90x1LiJ4mG39MTDbXLpgkFEIxTisksnHKKWukWRxhXNGHnxbW22ilqL3
         +WkvIDHK/mAh1i23GwecqpYvhjKW6GSy/AHDdfzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH 5.4 002/240] bpf: Fix incorrect memory charge cost calculation in stack_map_alloc()
Date:   Mon, 20 Jun 2022 14:48:23 +0200
Message-Id: <20220620124737.873774107@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuntao Wang <ytcoode@gmail.com>

commit b45043192b3e481304062938a6561da2ceea46a6 upstream.

This is a backport of the original upstream patch for 5.4/5.10.

The original upstream patch has been applied to 5.4/5.10 branches, which
simply removed the line:

  cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));

This is correct for upstream branch but incorrect for 5.4/5.10 branches,
as the 5.4/5.10 branches do not have the commit 370868107bf6 ("bpf:
Eliminate rlimit-based memory accounting for stackmap maps"), so the
bpf_map_charge_init() function has not been removed.

Currently the bpf_map_charge_init() function in 5.4/5.10 branches takes a
wrong memory charge cost, the

  attr->max_entries * (sizeof(struct stack_map_bucket) + (u64)value_size))

part is missing, let's fix it.

Cc: <stable@vger.kernel.org> # 5.4.y
Cc: <stable@vger.kernel.org> # 5.10.y
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/stackmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -117,7 +117,8 @@ static struct bpf_map *stack_map_alloc(u
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	err = bpf_map_charge_init(&mem, cost);
+	err = bpf_map_charge_init(&mem, cost + attr->max_entries *
+			   (sizeof(struct stack_map_bucket) + (u64)value_size));
 	if (err)
 		return ERR_PTR(err);
 


