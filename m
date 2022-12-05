Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6B6432BE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbiLET3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbiLET2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3451A25C5D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA2B6B81200
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60393C433D6;
        Mon,  5 Dec 2022 19:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268317;
        bh=BkEZKgXllA52vZ77M4FQfDqc4jcwy1Tb6bN02v+Xo4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezrg/N2Vhe+UP/z+d/OKqPJIoYIk0e9aMQjc0ga9CB+/+KQrKMX6xbyA1CaXAudgA
         TB+pdLt2vAyBDX07PdmbcvfuOeuwA+8as8VHqHfn1CF8ZmzIrVA8ii7NRkV0wfXVnR
         ldNjCuSmXhzjeKTeBilbviNzVxBYaAXeJ4vcWqds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 057/124] net: wwan: iosm: fix crash in peek throughput test
Date:   Mon,  5 Dec 2022 20:09:23 +0100
Message-Id: <20221205190810.044479317@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 2290a1d46bf30f9e0bcf49ad20d5c30d0e099989 ]

Peek throughput UL test is resulting in crash. If the UL
transfer block free list is exhaust, the peeked skb is freed.
In the next transfer freed skb is referred from UL list which
results in crash.

Don't free the skb if UL transfer blocks are unavailable. The
pending skb will be picked for transfer on UL transfer block
available.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index c16365123660..738420bd14af 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -1207,10 +1207,9 @@ static int mux_ul_dg_update_tbl_index(struct iosm_mux *ipc_mux,
 				 qlth_n_ql_size, ul_list);
 	ipc_mux_ul_adb_finish(ipc_mux);
 	if (ipc_mux_ul_adb_allocate(ipc_mux, adb, &ipc_mux->size_needed,
-				    IOSM_AGGR_MUX_SIG_ADBH)) {
-		dev_kfree_skb(src_skb);
+				    IOSM_AGGR_MUX_SIG_ADBH))
 		return -ENOMEM;
-	}
+
 	ipc_mux->size_needed = le32_to_cpu(adb->adbh->block_length);
 
 	ipc_mux->size_needed += offsetof(struct mux_adth, dg);
-- 
2.35.1



