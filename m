Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55A6B82CF
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 21:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCMUeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 16:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCMUd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 16:33:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AD518152;
        Mon, 13 Mar 2023 13:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=tbb20uIFyWqo9nThJPQCwFWeu9XvOL/qUHrC9xMBsms=;
        t=1678739596; x=1679949196; b=q8y1rf08QeMSZ81uZBYVC1orwcIOwlOqd5b3u6d/A2vtnU/
        bKEWtsY8K4h7M+whRIu/t1sS6zvZUhpkqHlC/1IQtJ+ecEm7uJaNUxwjaI6U+3zRRHQ9fX3Hc6NdZ
        7RzNJv3uc6VRyYdGjYvXWk7cQebvlel2JXhQnUaKlgq/rExK7t6qh/pOS4EYafFHYD5TA1ugJcu/4
        61ULDz7MjcPE4LkkXZTlmhnMarKoav59UW2tNzNg7MvXQbmgiIzyIpHmGbbpTADAvUjuRID1bShWy
        nY+MFbbTOoRtFSxamVWwpqih+CQY8aKWqHfblHnS3cNpuwz7p6JaJPfAuGyBW6Xw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pbor2-002LqN-0F;
        Mon, 13 Mar 2023 21:33:12 +0100
Message-ID: <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Thomas Mann <rauchwolke@gmx.net>, stable@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Mon, 13 Mar 2023 21:33:10 +0100
In-Reply-To: <20230313201542.72325-1-alexander@wetzel-home.de>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-03-13 at 21:15 +0100, Alexander Wetzel wrote:
>=20
> While drivers with native iTXQ support are able to handle that,=C2=A0
>=20

questionable. Looking at iwlwifi:

void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
                               struct ieee80211_txq *txq)
{
        struct iwl_mvm *mvm =3D IWL_MAC80211_GET_MVM(hw);
...
        list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
...
}

which might explain some rare and hard to debug list corruptions in the
driver that we've seen reports of ...

> To avoid what seems to be a not needed distinction between native and
> drivers using ieee80211_handle_wake_tx_queue(), the serialization is
> done for drv_wake_tx_queue() here.

So probably no objection to that, at least for now, though in the common
path (what I showed above was the 'first use' path), iwlwifi actually
hits different HW resources, so it _could_ benefit from concurrent TX
after fixing that bug.

> The serialization works by detecting and blocking concurrent calls into
> drv_wake_tx_queue() and - when needed - restarting all queues after the
> wake_tx_queue ops returned from the driver.

This seems ... overly complex? It feels like you're implementing a kind
of spinlock (using atomic bit ops) with very expensive handling of
contention?

Since drivers are supposed to handle concurrent TX per AC, you could
almost just do something like this:

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f07a3c1b4d9a..1946e28868ea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7108,10 +7108,8 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee=
80211_hw *hw, u8 ac);
  */
 void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac);
=20
-/* (deprecated) */
-static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 =
ac)
-{
-}
+/** ... */
+void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac);
=20
 void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq, bool force);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1fae44fb1be6..606ca8620d20 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4250,11 +4250,17 @@ void ieee80211_txq_schedule_start(struct ieee80211_=
hw *hw, u8 ac)
 	} else {
 		local->schedule_round[ac] =3D 0;
 	}
-
-	spin_unlock_bh(&local->active_txq_lock[ac]);
 }
 EXPORT_SYMBOL(ieee80211_txq_schedule_start);
=20
+void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local =3D hw_to_local(hw);
+
+	spin_unlock_bh(&local->active_txq_lock[ac]);
+}
+EXPORT_SYMBOL(ieee80211_txq_schedule_end);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,



assuming that TXQ drivers actually still call
ieee80211_txq_schedule_end() which says it's deprecated.

That even has _bh() so the tasklet can't be running anyway ...

So if the concurrency really is only TX vs. tasklet, then you could even
just keep the BHs disabled (in _start spin_unlock only and then in _end
local_bh_disable)?

> Which may also be the solution for the regression in 6.2:
> Do it now for ieee80211_handle_wake_tx_queue() and apply this patch
> to the development tree only.

I'd argue the other way around - do it for all to fix these issues, and
then audit drivers such as iwlwifi or even make concurrency here opt-in.

Felix did see some benefits of the concurrency I think though, so he
might have a different opinion.

johannes
