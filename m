Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9DF5EA4F1
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiIZL4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239208AbiIZLyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53D877EAB;
        Mon, 26 Sep 2022 03:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F4B360A55;
        Mon, 26 Sep 2022 10:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BF6C433D6;
        Mon, 26 Sep 2022 10:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189057;
        bh=nDbKPYGv0WWIC0OECH+w6mx4S1VD3cKtTgv94nJ/WmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mj9hKwcpn5688w6VqDuSsGdEPIxjeBBREbWp17NaAj6SnEXjRd/gK5xRdwPheX+Ll
         K0bxVVykpRp8a3bITvIMilhdni7iI+LCm0YHR+0hVgqZdT7tglaEaC0BEVoor0eKhY
         CN4azfgQ24FbyEFzemjWmU7NHtbCBXbg3u/+BdK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.19 059/207] kasan: call kasan_malloc() from __kmalloc_*track_caller()
Date:   Mon, 26 Sep 2022 12:10:48 +0200
Message-Id: <20220926100809.246523707@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 5373b8a09d6e037ee0587cb5d9fe4cc09077deeb upstream.

We were failing to call kasan_malloc() from __kmalloc_*track_caller()
which was causing us to sometimes fail to produce KASAN error reports
for allocations made using e.g. devm_kcalloc(), as the KASAN poison was
not being initialized. Fix it.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: <stable@vger.kernel.org> # 5.15
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4950,6 +4950,8 @@ void *__kmalloc_track_caller(size_t size
 	/* Honor the call site pointer we received. */
 	trace_kmalloc(caller, ret, size, s->size, gfpflags);
 
+	ret = kasan_kmalloc(s, ret, size, gfpflags);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
@@ -4981,6 +4983,8 @@ void *__kmalloc_node_track_caller(size_t
 	/* Honor the call site pointer we received. */
 	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
 
+	ret = kasan_kmalloc(s, ret, size, gfpflags);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);


