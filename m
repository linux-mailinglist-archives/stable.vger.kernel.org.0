Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7F15FD371
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 05:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJMDJM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 12 Oct 2022 23:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJMDJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 23:09:07 -0400
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5F7122BCD;
        Wed, 12 Oct 2022 20:09:06 -0700 (PDT)
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CC78160D39;
        Thu, 13 Oct 2022 03:09:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 1916C20024;
        Thu, 13 Oct 2022 03:08:29 +0000 (UTC)
Message-ID: <60af3294445ba2d2289a32ef7e429111ff476b44.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 5.19 01/63] staging: r8188eu: do not spam the
 kernel log
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Michael Straube <straube.linux@gmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk, martin@kaiser.cx,
        paskripkin@gmail.com, gszymaszek@short.pl, fmdefrancesco@gmail.com,
        makvihas@gmail.com, saurav.girepunje@gmail.com,
        linux-staging@lists.linux.dev
Date:   Wed, 12 Oct 2022 20:08:58 -0700
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: uz6rxyxkf4cx3t8jwgm77puediit9i54
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 1916C20024
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+zvIBb+G3uLRkzWAgvUwCViVSfV01oEU4=
X-HE-Tag: 1665630509-244581
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-10-12 at 20:17 -0400, Sasha Levin wrote:
> From: Michael Straube <straube.linux@gmail.com>
> 
> [ Upstream commit 9a4d0d1c21b974454926c3b832b4728679d818eb ]
> 
> Drivers should not spam the kernel log if they work properly. Convert
> the functions Hal_EfuseParseIDCode88E() and _netdev_open() to use
> netdev_dbg() instead of pr_info() so that developers can still enable
> it if they want to see this information.

Why should this be backported?

> diff --git a/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
[]
> @@ -676,6 +676,7 @@ Hal_EfuseParseIDCode88E(
>  	)
>  {
>  	struct eeprom_priv *pEEPROM = &padapter->eeprompriv;
> +	struct net_device *netdev = padapter->pnetdev;
>  	u16			EEPROMId;
>  
>  	/*  Check 0x8129 again for making sure autoload status!! */
> @@ -687,7 +688,7 @@ Hal_EfuseParseIDCode88E(
>  		pEEPROM->bautoload_fail_flag = false;
>  	}
>  
> -	pr_info("EEPROM ID = 0x%04x\n", EEPROMId);
> +	netdev_dbg(netdev, "EEPROM ID = 0x%04x\n", EEPROMId);
>  }
>  
>  static void Hal_ReadPowerValueFromPROM_8188E(struct txpowerinfo24g *pwrInfo24G, u8 *PROMContent, bool AutoLoadFail)
> diff --git a/drivers/staging/r8188eu/os_dep/os_intfs.c b/drivers/staging/r8188eu/os_dep/os_intfs.c
[]
> @@ -636,7 +636,7 @@ int _netdev_open(struct net_device *pnetdev)
>  		if (status == _FAIL)
>  			goto netdev_open_error;
>  
> -		pr_info("MAC Address = %pM\n", pnetdev->dev_addr);
> +		netdev_dbg(pnetdev, "MAC Address = %pM\n", pnetdev->dev_addr);
>  
>  		status = rtw_start_drv_threads(padapter);
>  		if (status == _FAIL) {

