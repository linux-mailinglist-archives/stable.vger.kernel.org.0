Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216EF59D35E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbiHWIOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242229AbiHWINJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:13:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B2E6C13E;
        Tue, 23 Aug 2022 01:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAFEB6123D;
        Tue, 23 Aug 2022 08:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65144C433D6;
        Tue, 23 Aug 2022 08:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242151;
        bh=gyk0DIlacszwxhUgLMZ0yJZSzHV8SnJZoaqZaniVh88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oc72Y6XsoRwU1v/sVhCT2QSY9BVv83xHt69dDSmuslfqXcAjF1ZDaMNtSnjpNNiqi
         /lU1v3+RJBiCXN8yeDB4eRx/TJLFTd77BvNeL6J5ac/DJCTl6rbVY8PHvzmj+moFJR
         Wbrf/vFKBl3O5AVdiHrQFrEGQGUtp+0YAvrY0T7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 064/365] bpf: Acquire map uref in .init_seq_private for array map iterator
Date:   Tue, 23 Aug 2022 09:59:25 +0200
Message-Id: <20220823080120.882381491@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -649,6 +649,11 @@ static int bpf_iter_init_array_map(void
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
@@ -657,6 +662,7 @@ static void bpf_iter_fini_array_map(void
 {
 	struct bpf_iter_seq_array_map_info *seq_info = priv_data;
 
+	bpf_map_put_with_uref(seq_info->map);
 	kfree(seq_info->percpu_value_buf);
 }
 


