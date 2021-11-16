Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7FC45252F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354007AbhKPBrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381781AbhKPBoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 20:44:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB1B61251;
        Tue, 16 Nov 2021 01:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637026879;
        bh=xwrmsNTr3mvybHMNARrNpY2D2kUEn2m1m28fKw7JXEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TMRdg8IV9MXiudilaeW44/GYCGsOgxAMeIrO+gmHVai5Fn3onLvKvDYcS8Tj3rIn/
         FVQIFi6UgmduY95cHDomqrrta6omLDap+HCRgCK2zMFmE9zX0BwTKFHyejDMKIYfFz
         cud0C8KqWQBLwPlbUXCc5hpbxafElXT4oTsAIVMXTs1rRtaznNCh9CE0Y1rFoFpdDf
         W9XUN4YzWMh9dN+iPNPB0ruIU3lwkDSzE4jQgNUGV6WG3enk+qOsfUKJwVSIS4KKyt
         Fz4LRz1ngnd+wo+368hIfMoUT9XLFxgGiVzuF1bRqTMSrfZpTDqrr8ZerP1CDulSZn
         R8nkPSM9sGaWQ==
Date:   Mon, 15 Nov 2021 20:41:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.15 291/917] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Message-ID: <YZMMPfG74Zi4MEq+@sashalap>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165438.632409127@linuxfoundation.org>
 <20211115233547.bduho7ej5ft52cmd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211115233547.bduho7ej5ft52cmd@skbuf>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:35:47PM +0000, Vladimir Oltean wrote:
>On Mon, Nov 15, 2021 at 05:56:26PM +0100, Greg Kroah-Hartman wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> [ Upstream commit 49753a75b9a32de4c0393bb8d1e51ea223fda8e4 ]
>>
>> Looking at the code, the GSWIP switch appears to hold bridging service
>> structures (VLANs, FDBs, forwarding rules) in PCE table entries.
>> Hardware access to the PCE table is non-atomic, and is comprised of
>> several register reads and writes.
>>
>> These accesses are currently serialized by the rtnl_lock, but DSA is
>> changing its driver API and that lock will no longer be held when
>> calling ->port_fdb_add() and ->port_fdb_del().
>>
>> So this driver needs to serialize the access to the PCE table using its
>> own locking scheme. This patch adds that.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
>>  1 file changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
>> index dbd4486a173ff..1a96df70d1e85 100644
>> --- a/drivers/net/dsa/lantiq_gswip.c
>> +++ b/drivers/net/dsa/lantiq_gswip.c
>> @@ -276,6 +276,7 @@ struct gswip_priv {
>>  	int num_gphy_fw;
>>  	struct gswip_gphy_fw *gphy_fw;
>>  	u32 port_vlan_filter;
>> +	struct mutex pce_table_lock;
>>  };
>>
>>  struct gswip_pce_table_entry {
>> @@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
>>  	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
>>  					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
>>
>> +	mutex_lock(&priv->pce_table_lock);
>> +
>>  	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>>  				     GSWIP_PCE_TBL_CTRL_BAS);
>> -	if (err)
>> +	if (err) {
>> +		mutex_unlock(&priv->pce_table_lock);
>>  		return err;
>> +	}
>>
>>  	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
>>  	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
>> @@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
>>
>>  	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>>  				     GSWIP_PCE_TBL_CTRL_BAS);
>> -	if (err)
>> +	if (err) {
>> +		mutex_unlock(&priv->pce_table_lock);
>>  		return err;
>> +	}
>>
>>  	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
>>  		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
>> @@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
>>  	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
>>  	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
>>
>> +	mutex_unlock(&priv->pce_table_lock);
>> +
>>  	return 0;
>>  }
>>
>> @@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
>>  	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
>>  					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
>>
>> +	mutex_lock(&priv->pce_table_lock);
>> +
>>  	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>>  				     GSWIP_PCE_TBL_CTRL_BAS);
>> -	if (err)
>> +	if (err) {
>> +		mutex_unlock(&priv->pce_table_lock);
>>  		return err;
>> +	}
>>
>>  	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
>>  	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
>> @@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
>>  	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
>>  	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
>>
>> -	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>> -				      GSWIP_PCE_TBL_CTRL_BAS);
>> +	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>> +				     GSWIP_PCE_TBL_CTRL_BAS);
>> +
>> +	mutex_unlock(&priv->pce_table_lock);
>> +
>> +	return err;
>>  }
>>
>>  /* Add the LAN port into a bridge with the CPU port by
>> @@ -2106,6 +2123,7 @@ static int gswip_probe(struct platform_device *pdev)
>>  	priv->ds->priv = priv;
>>  	priv->ds->ops = priv->hw_info->ops;
>>  	priv->dev = dev;
>> +	mutex_init(&priv->pce_table_lock);
>>  	version = gswip_switch_r(priv, GSWIP_VERSION);
>>
>>  	np = dev->of_node;
>> --
>> 2.33.0
>>
>>
>>
>
>As discussed on the v5.14 backport, this patch can be dropped.

Dropped, thanks!

-- 
Thanks,
Sasha
