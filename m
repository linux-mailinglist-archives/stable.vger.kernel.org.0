Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491205FD0CC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiJMAaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiJMA2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C57125733;
        Wed, 12 Oct 2022 17:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CE9E61704;
        Thu, 13 Oct 2022 00:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35A7C433C1;
        Thu, 13 Oct 2022 00:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620679;
        bh=AXV8WayF6SRNoHjpF1h6M2UZCdBH6WNv/Z0eu0mm7Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzdtEkC0vaMpvWLCmPw/WfGyAs45JUgsTrMCv3mBdXrVsEb40hDS1NGhzfZON+ZsM
         EOKe26PZhJIumxoaYEG6lSQluE2lwjcwGq6FloonMgHwwVT5QuVg+/uFzb8nbQCub6
         s45cSPDM5qznKZhidhsjWbbbScWEoiWpDnap/ZLgEqngwUV5RG4MvPF0soNrlBTE7g
         iSk9H4A7/R+oe9A4QSWKZPYYqN0PVvprjNyEYZxWdWwUSzqFLpqAdo5Kq7XVZL8Abp
         hPGnRroQPMNDIIhfF7FsKWgP9YWLOjVA+FYJ6Fv9VT0blY2eK6ID42pXCjAC6Pqtbs
         r7a6mctXM60Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>, llvm@lists.linux.dev,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        ztong0001@gmail.com, dave@stgolabs.net,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 26/33] staging: rtl8192u: Fix return type of ieee80211_xmit
Date:   Wed, 12 Oct 2022 20:23:25 -0400
Message-Id: <20221013002334.1894749-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 2851349ac351010a2649e0ff86a1e3d68fe5d683 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of ieee80211_xmit should be changed from int to
netdev_tx_t.

Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Link: https://lore.kernel.org/r/20220914210750.423048-1-nhuck@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h    | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 39f4ddd86796..4658e79d50f7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2178,7 +2178,7 @@ int ieee80211_set_encryption(struct ieee80211_device *ieee);
 int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
 			       struct sk_buff *frag, int hdr_len);
 
-int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t ieee80211_xmit(struct sk_buff *skb, struct net_device *dev);
 void ieee80211_txb_free(struct ieee80211_txb *txb);
 
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 63a561ab4a76..50d536a4c382 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -526,7 +526,7 @@ static void ieee80211_query_seqnum(struct ieee80211_device *ieee,
 	}
 }
 
-int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	struct ieee80211_txb *txb = NULL;
@@ -822,13 +822,13 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 			if ((*ieee->hard_start_xmit)(txb, dev) == 0) {
 				stats->tx_packets++;
 				stats->tx_bytes += __le16_to_cpu(txb->payload_size);
-				return 0;
+				return NETDEV_TX_OK;
 			}
 			ieee80211_txb_free(txb);
 		}
 	}
 
-	return 0;
+	return NETDEV_TX_OK;
 
  failed:
 	spin_unlock_irqrestore(&ieee->lock, flags);
-- 
2.35.1

