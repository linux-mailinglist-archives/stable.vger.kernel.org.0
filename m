Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478C82621FA
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgIHVfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:35:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:43482 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726490AbgIHVff (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 17:35:35 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 407E8200C8;
        Tue,  8 Sep 2020 21:35:33 +0000 (UTC)
Received: from us4-mdac16-57.at1.mdlocal (unknown [10.110.50.149])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3E7538009B;
        Tue,  8 Sep 2020 21:35:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.6])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C04CC40072;
        Tue,  8 Sep 2020 21:35:32 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7ED40B00080;
        Tue,  8 Sep 2020 21:35:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep 2020
 22:35:25 +0100
Subject: Re: [PATCH 5.4 086/129] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Hyunsoon Kim <h10.kim@samsung.com>
References: <20200908152229.689878733@linuxfoundation.org>
 <20200908152234.000867723@linuxfoundation.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <70529b6c-7b00-d760-c0c0-42f0ea5784f3@solarflare.com>
Date:   Tue, 8 Sep 2020 22:35:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200908152234.000867723@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25652.007
X-TM-AS-Result: No-1.974400-8.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/v4ECMHJTM/ufZvT2zYoYOwC/ExpXrHizwZFDQxUvPcmL6Y
        VRYkPkYCSCF6HRRH3gIN25tj8sME0lpGtZpuPG16tKV49RpAH3tOxMIe1e/Q+lT4wXE1Q3+tocP
        Vrs+9l2WrarPPtIvi4uYoVJQ9TcQivz6xGurTfloBnSWdyp4eoWgU1o1xV13fYcgF3TR2TfI5pz
        FMSqNkwrysmJ3Ri+UacaFM17gO4IyR9GF2J2xqM4MbH85DUZXyseWplitmp0j6C0ePs7A07Sib6
        hcH39TzeqiyYsWDasnfZjOmAfXU7ARUs+MuSyMTpgHjzELc15CjObMcXmcytw5LZNIb/Wv0bMa8
        YIGFldTr/ToUHXs83CgS77Whwf5LUdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD8VsfdwUmMsnAvpL
        E+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.974400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25652.007
X-MDID: 1599600933-oajcFjSGPQmL
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/09/2020 16:25, Greg Kroah-Hartman wrote:
> From: Alexander Lobakin <alobakin@dlink.ru>
>
> commit 6570bc79c0dfff0f228b7afd2de720fb4e84d61d upstream.
>
> Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
> skbs") made use of listified skb processing for the users of
> napi_gro_frags().
> The same technique can be used in a way more common napi_gro_receive()
> to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
> including gro_cells and mac80211 users.
> This slightly changes the return value in cases where skb is being
> dropped by the core stack, but it seems to have no impact on related
> drivers' functionality.
> gro_normal_batch is left untouched as it's very individual for every
> single system configuration and might be tuned in manual order to
> achieve an optimal performance.
>
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> Acked-by: Edward Cree <ecree@solarflare.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Hyunsoon Kim <h10.kim@samsung.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
I'm not quite sure why this is stable material(it's a performance
 enhancement, rather than a fix).  But if you do want to take it,
 make sure you've also got
c80794323e82 ("net: Fix packet reordering caused by GRO and listified RX cooperation")
b167191e2a85 ("net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling")
 in your tree, particularly the latter as without it this commit
 triggers a severe regression in iwlwifi.

-ed
