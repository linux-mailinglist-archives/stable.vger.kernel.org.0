Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88906627F11
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiKNMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbiKNMzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:55:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD031275E9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ABD9B80EBC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7035AC43470;
        Mon, 14 Nov 2022 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430504;
        bh=S8n8NR0RAELzsKraZRDDZDen1H7Fgh/Gvz/w5CFFM7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jig5GIca+7H7nRhVM8KeztzZO8+c+Tdxh0knVhwaB+vvGTi1uLnt46TKgQ5jifak6
         71ofxyWs1W0zlH5O59OIYflAdtsoxrd17Yde8J0WoizRLsXBfQFjZkWZkgONgCJvBw
         Xu9dmyLQrBa3RNQc9lPVLca8TzCiPRTHdoQC0XrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/131] net: tun: Fix memory leaks of napi_get_frags
Date:   Mon, 14 Nov 2022 13:44:59 +0100
Message-Id: <20221114124449.959978368@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 1118b2049d77ca0b505775fc1a8d1909cf19a7ec ]

kmemleak reports after running test_progs:

unreferenced object 0xffff8881b1672dc0 (size 232):
  comm "test_progs", pid 394388, jiffies 4354712116 (age 841.975s)
  hex dump (first 32 bytes):
    e0 84 d7 a8 81 88 ff ff 80 2c 67 b1 81 88 ff ff  .........,g.....
    00 40 c5 9b 81 88 ff ff 00 00 00 00 00 00 00 00  .@..............
  backtrace:
    [<00000000c8f01748>] napi_skb_cache_get+0xd4/0x150
    [<0000000041c7fc09>] __napi_build_skb+0x15/0x50
    [<00000000431c7079>] __napi_alloc_skb+0x26e/0x540
    [<000000003ecfa30e>] napi_get_frags+0x59/0x140
    [<0000000099b2199e>] tun_get_user+0x183d/0x3bb0 [tun]
    [<000000008a5adef0>] tun_chr_write_iter+0xc0/0x1b1 [tun]
    [<0000000049993ff4>] do_iter_readv_writev+0x19f/0x320
    [<000000008f338ea2>] do_iter_write+0x135/0x630
    [<000000008a3377a4>] vfs_writev+0x12e/0x440
    [<00000000a6b5639a>] do_writev+0x104/0x280
    [<00000000ccf065d8>] do_syscall_64+0x3b/0x90
    [<00000000d776e329>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue occurs in the following scenarios:
tun_get_user()
  napi_gro_frags()
    napi_frags_finish()
      case GRO_NORMAL:
        gro_normal_one()
          list_add_tail(&skb->list, &napi->rx_list);
          <-- While napi->rx_count < READ_ONCE(gro_normal_batch),
          <-- gro_normal_list() is not called, napi->rx_list is not empty
  <-- not ask to complete the gro work, will cause memory leaks in
  <-- following tun_napi_del()
...
tun_napi_del()
  netif_napi_del()
    __netif_napi_del()
    <-- &napi->rx_list is not empty, which caused memory leaks

To fix, add napi_complete() after napi_gro_frags().

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9909f430d723..4e77b269ef0a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1959,6 +1959,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		local_bh_disable();
 		napi_gro_frags(&tfile->napi);
+		napi_complete(&tfile->napi);
 		local_bh_enable();
 		mutex_unlock(&tfile->napi_mutex);
 	} else if (tfile->napi_enabled) {
-- 
2.35.1



