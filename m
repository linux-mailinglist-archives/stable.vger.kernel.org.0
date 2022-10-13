Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90C65FD014
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiJMAYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiJMAXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE94A52443;
        Wed, 12 Oct 2022 17:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DC22B81CC4;
        Thu, 13 Oct 2022 00:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC3DC433C1;
        Thu, 13 Oct 2022 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620436;
        bh=c7RVjqcmClAXhrEggnXFpKNhPPpv6Yk6Q3YUARexdQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViCy2ZxNvNOZZL8pW0iV4XI70qCUDmvchWQXAPZJga84WOJrPkyJ9EUb1q437+vsW
         Vwiub8uat/yBCShe8SwFFjBcsIfRYQXZWB68gTLgl5ZY7WONMW4fiHJVVTFRYEorSI
         WJMir6JnlWdazRLNKtTuSOSHr3dBLvgI52tQlx9OzWZBNbEfYOCFegWZ/Xa6icfHc7
         qRU9Iky9g+lr2or5i4PkwI7TW+M2F8Kxe7bAV4ZnQBF4sARAfhhL5V6sgrIeV10IZp
         L3c4jcb78+EDVpekVxe4VtPqXQXuchzBUH35VsX+2qIhftwUQlEs+ApiAPT7ufFoVc
         DcTZ0tU7/7dfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>, llvm@lists.linux.dev,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, ndesaulniers@google.com,
        ztong0001@gmail.com, dave@stgolabs.net,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 45/63] staging: rtl8192u: Fix return type of ieee80211_xmit
Date:   Wed, 12 Oct 2022 20:18:19 -0400
Message-Id: <20221013001842.1893243-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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
index b577f9c81f85..9cd4b1896745 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2178,7 +2178,7 @@ int ieee80211_set_encryption(struct ieee80211_device *ieee);
 int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
 			       struct sk_buff *frag, int hdr_len);
 
-int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t ieee80211_xmit(struct sk_buff *skb, struct net_device *dev);
 void ieee80211_txb_free(struct ieee80211_txb *txb);
 
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 8602e3a6c837..e4b6454809a0 100644
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

