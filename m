Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DFB35437B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbhDEPfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 11:35:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47818 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbhDEPfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 11:35:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2AFE51C0B7D; Mon,  5 Apr 2021 17:34:53 +0200 (CEST)
Date:   Mon, 5 Apr 2021 17:34:52 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 047/126] ath10k: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
Message-ID: <20210405153452.GC32232@amd>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085032.596054465@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <20210405085032.596054465@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Fix ath10k_wmi_tlv_op_pull_peer_stats_info() to hold RCU lock before it
> calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
> pointer is no longer needed.

It does that. But is also does the unlock even if it did not take the
lock:

> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> @@ -576,13 +576,13 @@ static void ath10k_wmi_event_tdls_peer(struct ath10=
k *ar, struct sk_buff *skb)
>  	case WMI_TDLS_TEARDOWN_REASON_TX:
>  	case WMI_TDLS_TEARDOWN_REASON_RSSI:
>  	case WMI_TDLS_TEARDOWN_REASON_PTR_TIMEOUT:
> +		rcu_read_lock();
>  		station =3D ieee80211_find_sta_by_ifaddr(ar->hw,
>  						       ev->peer_macaddr.addr,
>  						       NULL);
>  		if (!station) {
>  			ath10k_warn(ar, "did not find station from tdls peer event");
> -			kfree(tb);
> -			return;
> +			goto exit;
>  		}
>  		arvif =3D ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
>  		ieee80211_tdls_oper_request(
> @@ -593,6 +593,9 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k =
*ar, struct sk_buff *skb)
>  					);
>  		break;
>  	}
> +
> +exit:
> +	rcu_read_unlock();
>  	kfree(tb);
>  }

The switch only takes the lock in 3 branches, but it is released
unconditionally at the end.

Something like this?

Best regards,
								Pavel

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wirele=
ss/ath/ath10k/wmi-tlv.c
index e7072fc4f487..e03ff56d938b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -582,20 +582,19 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k =
*ar, struct sk_buff *skb)
 						       NULL);
 		if (!station) {
 			ath10k_warn(ar, "did not find station from tdls peer event");
-			goto exit;
-		}
-		arvif =3D ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
-		ieee80211_tdls_oper_request(
+		} else {
+			arvif =3D ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
+			ieee80211_tdls_oper_request(
 					arvif->vif, station->addr,
 					NL80211_TDLS_TEARDOWN,
 					WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE,
 					GFP_ATOMIC
 					);
+		}
+		rcu_read_unlock();
 		break;
 	}
=20
-exit:
-	rcu_read_unlock();
 	kfree(tb);
 }
=20


--=20
http://www.livejournal.com/~pavelmachek

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBrLhwACgkQMOfwapXb+vKkJACfX2IZWhZgB25cUE0Z9ij0EH75
eOAAnAnqYgGWEgn9M4c0O1zko9JRR4DE
=QVpV
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
