Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBAC4A361E
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347029AbiA3MJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347001AbiA3MJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:09:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E464FC061714;
        Sun, 30 Jan 2022 04:09:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B692CE0E88;
        Sun, 30 Jan 2022 12:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A8FC340E4;
        Sun, 30 Jan 2022 12:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643544544;
        bh=Xt7rHWLP+Pg5zgGJ4Mjmq2j9/RO/6rcjJgV5H99Wv1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sZEoQPZHth0+6CWntqQtLgeo/242RR0LSmW7RjmjnRzheTH95mk4lrQw0aIgmfCNo
         73bVH/LttqZy7aD9ifweJtAK+ZU3UNLduX2y2wqf2U0oOVO9WxDf0S1A2O5ovDW7cl
         859wkZXhRYH4ZVuNGdWXkja8s9ISMh1QVtN5ZoNytesRhCA23yqxqEFu5LZZE4DY5Z
         XYzfKPNPft++slzBIR86RI3ioUFse3/9BAWOgwX2LevCEk6tu8jBLl7+96UNZgpSRO
         XT74bzX8Cx0LR7kGThCoqPGWRSnHVK5BqOylvI8faNeDoL9hQz3QYsjYt1v5Ajbgj3
         XLMJ4qfOTBzzA==
Date:   Sun, 30 Jan 2022 13:08:59 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Felipe Contreras <felipe.contreras@gmail.com>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sasha Levin <sashal@kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mt76: connac: introduce MCU_CE_CMD macro
Message-ID: <YfZ/25gQVWsMNfSR@lore-desk>
References: <20220130075837.5270-1-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UA9aW8DzF72q943g"
Content-Disposition: inline
In-Reply-To: <20220130075837.5270-1-felipe.contreras@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UA9aW8DzF72q943g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> [ Upstream commit 680a2ead741ad9b479a53adf154ed5eee74d2b9a ]
>=20
> Similar to MCU_EXT_CMD, introduce MCU_CE_CMD for CE commands.
>=20
> Upstream commit 547224024579 (mt76: connac: introduce MCU_UNI_CMD macro,
> 2021-12-09) introduced a bug by removing MCU_UNI_PREFIX, but not
> updating MCU_CMD_MASK accordingly, so when commands are compared in
> mt7921_mcu_parse_response() one has the extra bit __MCU_CMD_FIELD_UNI
> set and the comparison fails:
>=20
>   if (mcu_cmd !=3D event->cid)
>   if (20001 !=3D 1)
>=20
> The fix was sneaked by in the next commit 680a2ead741a (mt76: connac:
> introduce MCU_CE_CMD macro, 2021-12-09):
>=20
> -	int mcu_cmd =3D cmd & MCU_CMD_MASK;
> +	int mcu_cmd =3D FIELD_GET(__MCU_CMD_FIELD_ID, cmd);
>=20
> But it was never merged into linux-stable.
>=20
> We need either both commits, or none.

Ack, I agree, we need to backport 680a2ead741a too. I did not notice I upda=
ted
mcu_cmd in mt7921_mcu_parse_response() in a different patch, thx for bisect=
ing
this.

Regards,
Lorenzo

>=20
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 16 +++----
>  .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 47 ++++++++++--------
>  .../wireless/mediatek/mt76/mt76_connac_mcu.h  | 48 ++++++++++---------
>  .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 24 +++++-----
>  .../wireless/mediatek/mt76/mt7921/testmode.c  |  4 +-
>  5 files changed, 73 insertions(+), 66 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7615/mcu.c
> index fcbcfc9f5a04..58be537adb1f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
> @@ -145,7 +145,7 @@ void mt7615_mcu_fill_msg(struct mt7615_dev *dev, stru=
ct sk_buff *skb,
>  	mcu_txd->cid =3D mcu_cmd;
>  	mcu_txd->ext_cid =3D FIELD_GET(__MCU_CMD_FIELD_EXT_ID, cmd);
> =20
> -	if (mcu_txd->ext_cid || (cmd & MCU_CE_PREFIX)) {
> +	if (mcu_txd->ext_cid || (cmd & __MCU_CMD_FIELD_CE)) {
>  		if (cmd & __MCU_CMD_FIELD_QUERY)
>  			mcu_txd->set_query =3D MCU_Q_QUERY;
>  		else
> @@ -193,7 +193,7 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, =
int cmd,
>  		skb_pull(skb, sizeof(*rxd));
>  		event =3D (struct mt7615_mcu_uni_event *)skb->data;
>  		ret =3D le32_to_cpu(event->status);
> -	} else if (cmd =3D=3D MCU_CMD_REG_READ) {
> +	} else if (cmd =3D=3D MCU_CE_QUERY(REG_READ)) {
>  		struct mt7615_mcu_reg_event *event;
> =20
>  		skb_pull(skb, sizeof(*rxd));
> @@ -2737,13 +2737,13 @@ int mt7615_mcu_set_bss_pm(struct mt7615_dev *dev,=
 struct ieee80211_vif *vif,
>  	if (vif->type !=3D NL80211_IFTYPE_STATION)
>  		return 0;
> =20
> -	err =3D mt76_mcu_send_msg(&dev->mt76, MCU_CMD_SET_BSS_ABORT, &req_hdr,
> -				sizeof(req_hdr), false);
> +	err =3D mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_BSS_ABORT),
> +				&req_hdr, sizeof(req_hdr), false);
>  	if (err < 0 || !enable)
>  		return err;
> =20
> -	return mt76_mcu_send_msg(&dev->mt76, MCU_CMD_SET_BSS_CONNECTED, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_BSS_CONNECTED),
> +				 &req, sizeof(req), false);
>  }
> =20
>  int mt7615_mcu_set_roc(struct mt7615_phy *phy, struct ieee80211_vif *vif,
> @@ -2762,6 +2762,6 @@ int mt7615_mcu_set_roc(struct mt7615_phy *phy, stru=
ct ieee80211_vif *vif,
> =20
>  	phy->roc_grant =3D false;
> =20
> -	return mt76_mcu_send_msg(&dev->mt76, MCU_CMD_SET_ROC, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_ROC),
> +				 &req, sizeof(req), false);
>  }
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drive=
rs/net/wireless/mediatek/mt76/mt76_connac_mcu.c
> index 7733c8fad241..1fb8432aa27c 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
> @@ -160,7 +160,8 @@ int mt76_connac_mcu_set_channel_domain(struct mt76_ph=
y *phy)
> =20
>  	memcpy(__skb_push(skb, sizeof(hdr)), &hdr, sizeof(hdr));
> =20
> -	return mt76_mcu_skb_send_msg(dev, skb, MCU_CMD_SET_CHAN_DOMAIN, false);
> +	return mt76_mcu_skb_send_msg(dev, skb, MCU_CE_CMD(SET_CHAN_DOMAIN),
> +				     false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_channel_domain);
> =20
> @@ -198,8 +199,8 @@ int mt76_connac_mcu_set_vif_ps(struct mt76_dev *dev, =
struct ieee80211_vif *vif)
>  	if (vif->type !=3D NL80211_IFTYPE_STATION)
>  		return -EOPNOTSUPP;
> =20
> -	return mt76_mcu_send_msg(dev, MCU_CMD_SET_PS_PROFILE, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(dev, MCU_CE_CMD(SET_PS_PROFILE),
> +				 &req, sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_vif_ps);
> =20
> @@ -1523,7 +1524,8 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, s=
truct ieee80211_vif *vif,
>  		req->scan_func |=3D SCAN_FUNC_RANDOM_MAC;
>  	}
> =20
> -	err =3D mt76_mcu_skb_send_msg(mdev, skb, MCU_CMD_START_HW_SCAN, false);
> +	err =3D mt76_mcu_skb_send_msg(mdev, skb, MCU_CE_CMD(START_HW_SCAN),
> +				    false);
>  	if (err < 0)
>  		clear_bit(MT76_HW_SCANNING, &phy->state);
> =20
> @@ -1551,8 +1553,8 @@ int mt76_connac_mcu_cancel_hw_scan(struct mt76_phy =
*phy,
>  		ieee80211_scan_completed(phy->hw, &info);
>  	}
> =20
> -	return mt76_mcu_send_msg(phy->dev, MCU_CMD_CANCEL_HW_SCAN, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(phy->dev, MCU_CE_CMD(CANCEL_HW_SCAN),
> +				 &req, sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_cancel_hw_scan);
> =20
> @@ -1638,7 +1640,8 @@ int mt76_connac_mcu_sched_scan_req(struct mt76_phy =
*phy,
>  		memcpy(skb_put(skb, sreq->ie_len), sreq->ie, sreq->ie_len);
>  	}
> =20
> -	return mt76_mcu_skb_send_msg(mdev, skb, MCU_CMD_SCHED_SCAN_REQ, false);
> +	return mt76_mcu_skb_send_msg(mdev, skb, MCU_CE_CMD(SCHED_SCAN_REQ),
> +				     false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_sched_scan_req);
> =20
> @@ -1658,8 +1661,8 @@ int mt76_connac_mcu_sched_scan_enable(struct mt76_p=
hy *phy,
>  	else
>  		clear_bit(MT76_HW_SCHED_SCANNING, &phy->state);
> =20
> -	return mt76_mcu_send_msg(phy->dev, MCU_CMD_SCHED_SCAN_ENABLE, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(phy->dev, MCU_CE_CMD(SCHED_SCAN_ENABLE),
> +				 &req, sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_sched_scan_enable);
> =20
> @@ -1671,8 +1674,8 @@ int mt76_connac_mcu_chip_config(struct mt76_dev *de=
v)
> =20
>  	memcpy(req.data, "assert", 7);
> =20
> -	return mt76_mcu_send_msg(dev, MCU_CMD_CHIP_CONFIG, &req, sizeof(req),
> -				 false);
> +	return mt76_mcu_send_msg(dev, MCU_CE_CMD(CHIP_CONFIG),
> +				 &req, sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_chip_config);
> =20
> @@ -1684,8 +1687,8 @@ int mt76_connac_mcu_set_deep_sleep(struct mt76_dev =
*dev, bool enable)
> =20
>  	snprintf(req.data, sizeof(req.data), "KeepFullPwr %d", !enable);
> =20
> -	return mt76_mcu_send_msg(dev, MCU_CMD_CHIP_CONFIG, &req, sizeof(req),
> -				 false);
> +	return mt76_mcu_send_msg(dev, MCU_CE_CMD(CHIP_CONFIG),
> +				 &req, sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_deep_sleep);
> =20
> @@ -1787,8 +1790,8 @@ int mt76_connac_mcu_get_nic_capability(struct mt76_=
phy *phy)
>  	struct sk_buff *skb;
>  	int ret, i;
> =20
> -	ret =3D mt76_mcu_send_and_get_msg(phy->dev, MCU_CMD_GET_NIC_CAPAB, NULL,
> -					0, true, &skb);
> +	ret =3D mt76_mcu_send_and_get_msg(phy->dev, MCU_CE_CMD(GET_NIC_CAPAB),
> +					NULL, 0, true, &skb);
>  	if (ret)
>  		return ret;
> =20
> @@ -2071,7 +2074,8 @@ mt76_connac_mcu_rate_txpower_band(struct mt76_phy *=
phy,
>  		memcpy(skb->data, &tx_power_tlv, sizeof(tx_power_tlv));
> =20
>  		err =3D mt76_mcu_skb_send_msg(dev, skb,
> -					    MCU_CMD_SET_RATE_TX_POWER, false);
> +					    MCU_CE_CMD(SET_RATE_TX_POWER),
> +					    false);
>  		if (err < 0)
>  			return err;
>  	}
> @@ -2163,8 +2167,8 @@ int mt76_connac_mcu_set_p2p_oppps(struct ieee80211_=
hw *hw,
>  		.bss_idx =3D mvif->idx,
>  	};
> =20
> -	return mt76_mcu_send_msg(phy->dev, MCU_CMD_SET_P2P_OPPPS, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(phy->dev, MCU_CE_CMD(SET_P2P_OPPPS),
> +				 &req, sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_p2p_oppps);
> =20
> @@ -2490,8 +2494,8 @@ u32 mt76_connac_mcu_reg_rr(struct mt76_dev *dev, u3=
2 offset)
>  		.addr =3D cpu_to_le32(offset),
>  	};
> =20
> -	return mt76_mcu_send_msg(dev, MCU_CMD_REG_READ, &req, sizeof(req),
> -				 true);
> +	return mt76_mcu_send_msg(dev, MCU_CE_QUERY(REG_READ), &req,
> +				 sizeof(req), true);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_reg_rr);
> =20
> @@ -2505,7 +2509,8 @@ void mt76_connac_mcu_reg_wr(struct mt76_dev *dev, u=
32 offset, u32 val)
>  		.val =3D cpu_to_le32(val),
>  	};
> =20
> -	mt76_mcu_send_msg(dev, MCU_CMD_REG_WRITE, &req, sizeof(req), false);
> +	mt76_mcu_send_msg(dev, MCU_CE_CMD(REG_WRITE), &req,
> +			  sizeof(req), false);
>  }
>  EXPORT_SYMBOL_GPL(mt76_connac_mcu_reg_wr);
> =20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drive=
rs/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> index 5c5fab9154e5..acb9a286d354 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> @@ -496,13 +496,11 @@ enum {
>  #define MCU_CMD_UNI_EXT_ACK			(MCU_CMD_ACK | MCU_CMD_UNI | \
>  						 MCU_CMD_QUERY)
> =20
> -#define MCU_CE_PREFIX				BIT(29)
> -#define MCU_CMD_MASK				~(MCU_CE_PREFIX)
> -
>  #define __MCU_CMD_FIELD_ID			GENMASK(7, 0)
>  #define __MCU_CMD_FIELD_EXT_ID			GENMASK(15, 8)
>  #define __MCU_CMD_FIELD_QUERY			BIT(16)
>  #define __MCU_CMD_FIELD_UNI			BIT(17)
> +#define __MCU_CMD_FIELD_CE			BIT(18)
> =20
>  #define MCU_CMD(_t)				FIELD_PREP(__MCU_CMD_FIELD_ID,		\
>  							   MCU_CMD_##_t)
> @@ -513,6 +511,10 @@ enum {
>  #define MCU_UNI_CMD(_t)				(__MCU_CMD_FIELD_UNI |			\
>  						 FIELD_PREP(__MCU_CMD_FIELD_ID,		\
>  							    MCU_UNI_CMD_##_t))
> +#define MCU_CE_CMD(_t)				(__MCU_CMD_FIELD_CE |			\
> +						 FIELD_PREP(__MCU_CMD_FIELD_ID,		\
> +							   MCU_CE_CMD_##_t))
> +#define MCU_CE_QUERY(_t)			(MCU_CE_CMD(_t) | __MCU_CMD_FIELD_QUERY)
> =20
>  enum {
>  	MCU_EXT_CMD_EFUSE_ACCESS =3D 0x01,
> @@ -589,26 +591,26 @@ enum {
> =20
>  /* offload mcu commands */
>  enum {
> -	MCU_CMD_TEST_CTRL =3D MCU_CE_PREFIX | 0x01,
> -	MCU_CMD_START_HW_SCAN =3D MCU_CE_PREFIX | 0x03,
> -	MCU_CMD_SET_PS_PROFILE =3D MCU_CE_PREFIX | 0x05,
> -	MCU_CMD_SET_CHAN_DOMAIN =3D MCU_CE_PREFIX | 0x0f,
> -	MCU_CMD_SET_BSS_CONNECTED =3D MCU_CE_PREFIX | 0x16,
> -	MCU_CMD_SET_BSS_ABORT =3D MCU_CE_PREFIX | 0x17,
> -	MCU_CMD_CANCEL_HW_SCAN =3D MCU_CE_PREFIX | 0x1b,
> -	MCU_CMD_SET_ROC =3D MCU_CE_PREFIX | 0x1d,
> -	MCU_CMD_SET_P2P_OPPPS =3D MCU_CE_PREFIX | 0x33,
> -	MCU_CMD_SET_RATE_TX_POWER =3D MCU_CE_PREFIX | 0x5d,
> -	MCU_CMD_SCHED_SCAN_ENABLE =3D MCU_CE_PREFIX | 0x61,
> -	MCU_CMD_SCHED_SCAN_REQ =3D MCU_CE_PREFIX | 0x62,
> -	MCU_CMD_GET_NIC_CAPAB =3D MCU_CE_PREFIX | 0x8a,
> -	MCU_CMD_SET_MU_EDCA_PARMS =3D MCU_CE_PREFIX | 0xb0,
> -	MCU_CMD_REG_WRITE =3D MCU_CE_PREFIX | 0xc0,
> -	MCU_CMD_REG_READ =3D MCU_CE_PREFIX | __MCU_CMD_FIELD_QUERY | 0xc0,
> -	MCU_CMD_CHIP_CONFIG =3D MCU_CE_PREFIX | 0xca,
> -	MCU_CMD_FWLOG_2_HOST =3D MCU_CE_PREFIX | 0xc5,
> -	MCU_CMD_GET_WTBL =3D MCU_CE_PREFIX | 0xcd,
> -	MCU_CMD_GET_TXPWR =3D MCU_CE_PREFIX | 0xd0,
> +	MCU_CE_CMD_TEST_CTRL =3D 0x01,
> +	MCU_CE_CMD_START_HW_SCAN =3D 0x03,
> +	MCU_CE_CMD_SET_PS_PROFILE =3D 0x05,
> +	MCU_CE_CMD_SET_CHAN_DOMAIN =3D 0x0f,
> +	MCU_CE_CMD_SET_BSS_CONNECTED =3D 0x16,
> +	MCU_CE_CMD_SET_BSS_ABORT =3D 0x17,
> +	MCU_CE_CMD_CANCEL_HW_SCAN =3D 0x1b,
> +	MCU_CE_CMD_SET_ROC =3D 0x1d,
> +	MCU_CE_CMD_SET_P2P_OPPPS =3D 0x33,
> +	MCU_CE_CMD_SET_RATE_TX_POWER =3D 0x5d,
> +	MCU_CE_CMD_SCHED_SCAN_ENABLE =3D 0x61,
> +	MCU_CE_CMD_SCHED_SCAN_REQ =3D 0x62,
> +	MCU_CE_CMD_GET_NIC_CAPAB =3D 0x8a,
> +	MCU_CE_CMD_SET_MU_EDCA_PARMS =3D 0xb0,
> +	MCU_CE_CMD_REG_WRITE =3D 0xc0,
> +	MCU_CE_CMD_REG_READ =3D 0xc0,
> +	MCU_CE_CMD_CHIP_CONFIG =3D 0xca,
> +	MCU_CE_CMD_FWLOG_2_HOST =3D 0xc5,
> +	MCU_CE_CMD_GET_WTBL =3D 0xcd,
> +	MCU_CE_CMD_GET_TXPWR =3D 0xd0,
>  };
> =20
>  enum {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7921/mcu.c
> index 484a8c57b862..4c6adbb96955 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
> @@ -163,8 +163,8 @@ mt7921_mcu_parse_eeprom(struct mt76_dev *dev, struct =
sk_buff *skb)
>  int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
>  			      struct sk_buff *skb, int seq)
>  {
> +	int mcu_cmd =3D FIELD_GET(__MCU_CMD_FIELD_ID, cmd);
>  	struct mt7921_mcu_rxd *rxd;
> -	int mcu_cmd =3D cmd & MCU_CMD_MASK;
>  	int ret =3D 0;
> =20
>  	if (!skb) {
> @@ -201,7 +201,7 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, =
int cmd,
>  		/* skip invalid event */
>  		if (mcu_cmd !=3D event->cid)
>  			ret =3D -EAGAIN;
> -	} else if (cmd =3D=3D MCU_CMD_REG_READ) {
> +	} else if (cmd =3D=3D MCU_CE_QUERY(REG_READ)) {
>  		struct mt7921_mcu_reg_event *event;
> =20
>  		skb_pull(skb, sizeof(*rxd));
> @@ -274,7 +274,7 @@ int mt7921_mcu_fill_message(struct mt76_dev *mdev, st=
ruct sk_buff *skb,
>  	mcu_txd->s2d_index =3D MCU_S2D_H2N;
>  	mcu_txd->ext_cid =3D FIELD_GET(__MCU_CMD_FIELD_EXT_ID, cmd);
> =20
> -	if (mcu_txd->ext_cid || (cmd & MCU_CE_PREFIX)) {
> +	if (mcu_txd->ext_cid || (cmd & __MCU_CMD_FIELD_CE)) {
>  		if (cmd & __MCU_CMD_FIELD_QUERY)
>  			mcu_txd->set_query =3D MCU_Q_QUERY;
>  		else
> @@ -883,8 +883,8 @@ int mt7921_mcu_fw_log_2_host(struct mt7921_dev *dev, =
u8 ctrl)
>  		.ctrl_val =3D ctrl
>  	};
> =20
> -	return mt76_mcu_send_msg(&dev->mt76, MCU_CMD_FWLOG_2_HOST, &data,
> -				 sizeof(data), false);
> +	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(FWLOG_2_HOST),
> +				 &data, sizeof(data), false);
>  }
> =20
>  int mt7921_run_firmware(struct mt7921_dev *dev)
> @@ -1009,8 +1009,8 @@ int mt7921_mcu_set_tx(struct mt7921_dev *dev, struc=
t ieee80211_vif *vif)
>  		e->timer =3D q->mu_edca_timer;
>  	}
> =20
> -	return mt76_mcu_send_msg(&dev->mt76, MCU_CMD_SET_MU_EDCA_PARMS, &req_mu,
> -				 sizeof(req_mu), false);
> +	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_MU_EDCA_PARMS),
> +				 &req_mu, sizeof(req_mu), false);
>  }
> =20
>  int mt7921_mcu_set_chan_info(struct mt7921_phy *phy, int cmd)
> @@ -1214,13 +1214,13 @@ mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, str=
uct ieee80211_vif *vif,
>  	if (vif->type !=3D NL80211_IFTYPE_STATION)
>  		return 0;
> =20
> -	err =3D mt76_mcu_send_msg(&dev->mt76, MCU_CMD_SET_BSS_ABORT, &req_hdr,
> -				sizeof(req_hdr), false);
> +	err =3D mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_BSS_ABORT),
> +				&req_hdr, sizeof(req_hdr), false);
>  	if (err < 0 || !enable)
>  		return err;
> =20
> -	return mt76_mcu_send_msg(&dev->mt76, MCU_CMD_SET_BSS_CONNECTED, &req,
> -				 sizeof(req), false);
> +	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_BSS_CONNECTED),
> +				 &req, sizeof(req), false);
>  }
> =20
>  int mt7921_mcu_sta_update(struct mt7921_dev *dev, struct ieee80211_sta *=
sta,
> @@ -1330,7 +1330,7 @@ int mt7921_get_txpwr_info(struct mt7921_dev *dev, s=
truct mt7921_txpwr *txpwr)
>  	struct sk_buff *skb;
>  	int ret;
> =20
> -	ret =3D mt76_mcu_send_and_get_msg(&dev->mt76, MCU_CMD_GET_TXPWR,
> +	ret =3D mt76_mcu_send_and_get_msg(&dev->mt76, MCU_CE_CMD(GET_TXPWR),
>  					&req, sizeof(req), true, &skb);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c b/drive=
rs/net/wireless/mediatek/mt76/mt7921/testmode.c
> index 8bd43879dd6f..bdec8684ce94 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
> @@ -66,7 +66,7 @@ mt7921_tm_set(struct mt7921_dev *dev, struct mt7921_tm_=
cmd *req)
>  	if (!mt76_testmode_enabled(phy))
>  		goto out;
> =20
> -	ret =3D mt76_mcu_send_msg(&dev->mt76, MCU_CMD_TEST_CTRL, &cmd,
> +	ret =3D mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(TEST_CTRL), &cmd,
>  				sizeof(cmd), false);
>  	if (ret)
>  		goto out;
> @@ -95,7 +95,7 @@ mt7921_tm_query(struct mt7921_dev *dev, struct mt7921_t=
m_cmd *req,
>  	struct sk_buff *skb;
>  	int ret;
> =20
> -	ret =3D mt76_mcu_send_and_get_msg(&dev->mt76, MCU_CMD_TEST_CTRL,
> +	ret =3D mt76_mcu_send_and_get_msg(&dev->mt76, MCU_CE_CMD(TEST_CTRL),
>  					&cmd, sizeof(cmd), true, &skb);
>  	if (ret)
>  		goto out;
> --=20
> 2.35.1
>=20

--UA9aW8DzF72q943g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYfZ/2wAKCRA6cBh0uS2t
rHt6AP9iVrxj60Pu2InwLbA9MbUv3oUztjAJnAuoJ89qdDmWDgEA6uyfFGhLPLb9
m2jrgsWuyh3xzuh4jAVt+OkySzCVPQo=
=65/V
-----END PGP SIGNATURE-----

--UA9aW8DzF72q943g--
