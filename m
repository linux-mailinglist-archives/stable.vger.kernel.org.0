Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EA459D8C4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiHWJqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351867AbiHWJpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:45:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CFD208;
        Tue, 23 Aug 2022 01:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0178BCE1B50;
        Tue, 23 Aug 2022 08:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF05C433C1;
        Tue, 23 Aug 2022 08:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244152;
        bh=gRXOJdIGssNxS+kxPIDu1FjF/pzKNtVhwUjsxe9M6fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDb5JIx2zqETTGlPmFQeUY6W4VMqsjo5rLSZEZc14OQXbm05YZXzLicCK8TsM3R23
         cb1XSE91wySBHMzb5/p3wkRKjDxmq9Rstc96lD1Yyb/pQjeFM7LjIzAXXQUKCneiie
         Q/kpATAz02klIJzxIFpQIR4CO9gKLtfGdRAZd430=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 044/244] bpf: Acquire map uref in .init_seq_private for array map iterator
Date:   Tue, 23 Aug 2022 10:23:23 +0200
Message-Id: <20220823080100.536819994@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

commit f76fa6b338055054f80c72b29c97fb95c1becadc upstream.

bpf_iter_attach_map() acquires a map uref, and the uref may be released
before or in the middle of iterating map elements. For example, the uref
could be released in bpf_iter_detach_map() as part of
bpf_link_release(), or could be released in bpf_map_put_with_uref() as
part of bpf_map_release().

Alternative fix is acquiring an extra bpf_link reference just like
a pinned map iterator does, but it introduces unnecessary dependency
on bpf_link instead of bpf_map.

So choose another fix: acquiring an extra map uref in .init_seq_private
for array map iterator.

Fixes: d3cc2ab546ad ("bpf: Implement bpf iterator for array maps")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220810080538.1845898-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/arraymap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -620,6 +620,11 @@ static int bpf_iter_init_array_map(void
 		seq_info->percpu_value_buf = value_buf;
 	}
 
+	/* bpf_iter_attach_map() acquires a map uref, and the uref may be
+	 * released before or in the middle of iterating map elements, so
+	 * acquire an extra map uref for iterator.
+	 */
+	bpf_map_inc_with_uref(map);
 	seq_info->map = map;
 	return 0;
 }
@@ -628,6 +633,7 @@ static void bpf_iter_fini_array_map(void
 {
 	struct bpf_iter_seq_array_map_info *seq_info = priv_data;
 
+	bpf_map_put_with_uref(seq_info->map);
 	kfree(seq_info->percpu_value_buf);
 }
 


