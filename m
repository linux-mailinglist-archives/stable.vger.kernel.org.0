Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E384ABD8D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385628AbiBGLo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385260AbiBGLb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65167C043188;
        Mon,  7 Feb 2022 03:30:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 249E1B8111C;
        Mon,  7 Feb 2022 11:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63342C004E1;
        Mon,  7 Feb 2022 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233401;
        bh=FaEL32L8jTCbwx8zIa5szTEouuCoK0lO5+KhZu49YAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGCaFEE1G06lONpwzqXvhSJgLx0fu01TramK9skQMrk0LDYLhW8L1cnaVGjeCiBt7
         jL+0ksWb9hAtgC6G2sr8fWcbPLjYCkPpYINmJuQYVFsQJoqbDVugviLAZaEA0mA3WH
         TvOhHrgZ3G1LSSvUAA0/MAH8sSn6COkn1jYiJeDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com,
        Hou Tao <houtao1@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.15 086/110] bpf: Use VM_MAP instead of VM_ALLOC for ringbuf
Date:   Mon,  7 Feb 2022 12:06:59 +0100
Message-Id: <20220207103805.316988910@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Hou Tao <hotforest@gmail.com>

commit b293dcc473d22a62dc6d78de2b15e4f49515db56 upstream.

After commit 2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages
after mapping"), non-VM_ALLOC mappings will be marked as accessible
in __get_vm_area_node() when KASAN is enabled. But now the flag for
ringbuf area is VM_ALLOC, so KASAN will complain out-of-bound access
after vmap() returns. Because the ringbuf area is created by mapping
allocated pages, so use VM_MAP instead.

After the change, info in /proc/vmallocinfo also changes from
  [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
to
  [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220202060158.6260-1-houtao1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/ringbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_a
 	}
 
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
-		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
+		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
 		kmemleak_not_leak(pages);
 		rb->pages = pages;


