Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAD640AB52
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 12:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhINKEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 06:04:34 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:55457 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhINKEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 06:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631613795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbVzIVpBB61/hP9zrzJNjmoAVsNi4+VAMLBrf30cmuU=;
        b=bfrRYkcFfqMLZKUACVBEF7Ibb/9gG4R/OxGQjskQ9l5XBqrQrXsiBq/560ifeKyRdBcJaB
        ZDHJ/wDnI/xbCMx18FvbcTr9wtVUZf2LPf85eggrRg7KRcmTiGRYE8mJ9fP2o16oBfRWaT
        uK7jlLlCpFCjSLprpRERfKnlVuRpbic=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-3TH0sG1pP_6Oj4xn8ib1sQ-1;
 Tue, 14 Sep 2021 12:03:14 +0200
X-MC-Unique: 3TH0sG1pP_6Oj4xn8ib1sQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3PySqpBAmR2HV4T55YbBaYLvt01cuer0C10+1K6byE8ABKYj8DZuWADoJmzqoAcTbDIYy0IqynZitRrinRjYfQg5ZjdSVMseY/e6x/5kHFOcZbgRsNsmHh9dvXKkhun4hThTyXNuBCHbixA+1YSA2GigosS1Gmv+s7Ct9z4MCKbJYmZUL3aZLIJUC8g8rI9Hhc1OJOTvBifsUtdeova5pzouq5jepELPrh0JtWP6Ip0+sQ4DNbROnI/Ypt/u5h7/nIZ68VwwlzJRCp3qDo88ps5wTRJUjFUkDRZL3zPIC8/dVzBs3IhIWSo0kc3/eL0FU0IxJynNRfdBfriW/MRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EqBK0cRHouKDe5d/+3aETfwWbIfY1VeZMfnMmP8EH4U=;
 b=R+0ue9VshgzLTJZ73Bm5ZM8ZVkOgt+uO1xfp7CbHAnSlO98pYpR9x8K2YVZNhsUQ3k/CWahU+HjKDxCZdyHJl2xzauNGfQPmX85YgO3H5NPFRfQEylhH4l6mF01ahXnP33kd7kDbVouFAAK9W3m8Yfak42o5wB7Js7M0OJGCvQtP3uLK9ZqBOrc74BcWZ5ETUWa6tBfI0rTA80edjOzN7QydEg6uvIzYiK1UIf6te+q+veprMct7YbJQXJ5TGiF0Mxy6Nib7bY1XgL3sYrNf5cTuab0QX4ZGptHyL9IE3KC3sbxgpN3CiQA2ZeyIC4MRwWL0gx+HJ+2507B65bZk1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB6861.eurprd04.prod.outlook.com (2603:10a6:803:13c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 10:03:12 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 10:03:12 +0000
Subject: Re: [PATCH] x86/setup: call early_reserve_memory() earlier
To:     Juergen Gross <jgross@suse.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210914094108.22482-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <b15fa98e-f9a8-abac-2d16-83c29dafc517@suse.com>
Date:   Tue, 14 Sep 2021 12:03:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20210914094108.22482-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR0P264CA0115.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::31) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR0P264CA0115.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 10:03:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f949dfa-944d-46d8-63f0-08d97766dc86
X-MS-TrafficTypeDiagnostic: VI1PR04MB6861:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB68610DAC24243B423B90D33CB3DA9@VI1PR04MB6861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AVHLEHqXXO7cD2boiJp4xDg0bKys7q9Ga4+yWTfBpr4RQxTKXqiwn9Q9tqttestWnsmDHDEw9mnNMI/agrQ8sXInuzwsjy5D1nmUWeXhAa1rWQzhgxLKDN96fN1PHSIcu9/nAvnJ4XAPEC9xQm9x2sMAOBR1nBo20KAk+E4Jr7Cd8S7QrI/2QfZKNDWiAeTREACVCLPV+z3jgTJ810N7EgUCnrAhXzjT+El53QUQgNinOxtjclQsNIy7cdd6643FNAK+qAPhFodpQGt2WhqijO614YbxDXCw4Z+L1OV7bImfbITYXaUr9HqHsl7HbBjdxyU9tkIiMVa3tZbVtRZUZxZ8jh9f0Bm/jjUpkW01FxcTiABvkmWiK5fBrnBNPpr/58mf0uoxa79QgUsgc8I/9LPH1F7XfiYkI1k/OXvwd2455fYd4FolGjLYMjrTmCbUylhRpaoe8KOvZpHvBgywV0JPMHPxJLIfwlsGYqDxvllR4gzEaJwBpUE1lTQ2JTLR9AiAumm/+khdV1JrPyf03IOb9R3q5hwy2xUU1q5bqYRT/HhWskQ9J2LG/Sqdn0mphZZ4PXGbZKAru0p78J834VsOlCMznHA5ZZTtUtA0/h2MFuYVb1UVYpwsq6hbM/83/qcFqcf/VVwmXwIJnQ7zdbDiUan64VOigCW+YY+Ssi6+Vb1ZxxGtf3FnYDO4iQQLp5qUYVwjtKCQmfm+SmcxlJrfwL8AltIw7Ot2zkBUlimi+l6pNZB4l+7KmBR8/KCq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(478600001)(5660300002)(186003)(83380400001)(26005)(6636002)(2616005)(86362001)(8676002)(37006003)(36756003)(38100700002)(956004)(8936002)(31696002)(6486002)(2906002)(54906003)(53546011)(66574015)(316002)(16576012)(31686004)(66946007)(6862004)(66476007)(4326008)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4bsuIGN23zE62g4XGv3OYz1WrkL/Tqx/3cZf+DvNaCIPQUtNyS/eKhlkHxLV?=
 =?us-ascii?Q?FvbMcvOAqEjfmRutQsoTIYBVka8y099ZfpV4+yBy829nImdN/ULjrA89rWpW?=
 =?us-ascii?Q?uKCeuJJxNPBvhX5ovbJzTWHwyRxUZV36PTlFvs6YKeXkevHNTZte7YdEdM7o?=
 =?us-ascii?Q?z6tqlofd3mI3TCVkL4tka72OS61i0sQTy2wXQjMTdkpi/pkpk5LjZDar/6RC?=
 =?us-ascii?Q?XS5p6tQhP8LJpA6ZNXCuV/v6fY1lDjotsYG7GtFHsDkj8+Xd0RqWbDtsCXOI?=
 =?us-ascii?Q?dSQVdTMZnMTmrCsNnK99EXhU3e4T3HJoOjnuxZYSTOfu4RWYOobvSl9CUjUl?=
 =?us-ascii?Q?KLvSHa2z6T0uXsASv2WlJ88yq9fYNwck+8PEUkCExZxnvRyX9P5Vb7EX6xJy?=
 =?us-ascii?Q?Lc2pySGcRCZQDYfRnDH6EJfaKxZY46V7OlGojttYpV9gXA4bDEHtJoYSKbH0?=
 =?us-ascii?Q?RenTCx5OeSO3y488gVRdywskIkklte7UYxYFmYUVOHwosSXlBX2yAL3WnQoZ?=
 =?us-ascii?Q?V7ijhJhE71fu1OQNH+UCkFYSg2ljiYkKBlEHdxWTOTGyn07v2zCbev5RwfvR?=
 =?us-ascii?Q?yuiPeP7FcAn96zddHXsuR5ol8qTa0Rwe6QoDIQsX7HBqUnOpp1+TUk+iha5m?=
 =?us-ascii?Q?HZzWi6SU6TsaDhuRURFLTsDmLMwNACsROou5zeaTeApZdjf6nZz3ZWvVo9Ok?=
 =?us-ascii?Q?QeCcK3AChY/2fIACmRkLSLgdnf/yG131XR4RqUs9teqZLy79B6ngDU9IMa87?=
 =?us-ascii?Q?k5sNLjdScFpuB8u91Xj7herYup598vysQCKNdath/BxLigZoP2sIyXihTiqj?=
 =?us-ascii?Q?Kp9u7xIkD6xRXC3Ggsob4QFTf9Bgo6dzdGBCqlurc32jhDSPT7R8TiZsQaew?=
 =?us-ascii?Q?aPOowntwF5xuzLQ+EvOIEQY7t2i09KiATe6i61ENW3t1WhnpBz8lhT4kkZgr?=
 =?us-ascii?Q?XeqwZ2qAj0/qS9wuohSTW0/H3A9rf7ACVkHCvKKBssUZWvhWPf2HZY7Adu9F?=
 =?us-ascii?Q?5Qu/FvYI9FL8sYDs7Shqeeid+pts4hgq9oBfd+dVcZaoomCJagpvzxJ38SYv?=
 =?us-ascii?Q?zP/Ttg8AO48It4MEoViK6BLy7psZu39o4LxlDL2dL/FUSxCo6b/NhXjUlT6b?=
 =?us-ascii?Q?GEkC3c1lk+oZzpnliBhM4H1XO/Ak94NNo6eR3V/730z+pEDVLoF+M9A3ZFtF?=
 =?us-ascii?Q?JfoVmdQd9wSbpkC7cWooLGCdp0CdvihzlfDlqmN+TaXSjEy79LbemtGz+Vin?=
 =?us-ascii?Q?RWJdgSe8WSx/TTzpZ2x+BODDaf+h2WG5sLWoN8yHsvGoz/45TYvndwXXbunI?=
 =?us-ascii?Q?jeiLB+Yi86JviVSvidR5ujD6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f949dfa-944d-46d8-63f0-08d97766dc86
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 10:03:12.1859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9E8pt84bA3zBI531mdFxixUuI0E+cAwwcPEeujDAH0G1L/upd8MsFg7RDMMVVv9c6h/2PNcP7jN92oGoTw/UAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6861
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.09.2021 11:41, Juergen Gross wrote:
> Commit a799c2bd29d19c565 ("x86/setup: Consolidate early memory
> reservations") introduced early_reserve_memory() to do all needed
> initial memblock_reserve() calls in one function. Unfortunately the
> call of early_reserve_memory() is done too late for Xen dom0, as in
> some cases a Xen hook called by e820__memory_setup() will need those
> memory reservations to have happened already.
>=20
> Move the call of early_reserve_memory() to the beginning of
> setup_arch() in order to avoid such problems.
>=20
> Cc: stable@vger.kernel.org
> Fixes: a799c2bd29d19c565 ("x86/setup: Consolidate early memory reservatio=
ns")
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/kernel/setup.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 79f164141116..f369c51ec580 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -757,6 +757,18 @@ dump_kernel_offset(struct notifier_block *self, unsi=
gned long v, void *p)
> =20
>  void __init setup_arch(char **cmdline_p)
>  {
> +	/*
> +	 * Do some memory reservations *before* memory is added to
> +	 * memblock, so memblock allocations won't overwrite it.
> +	 * Do it after early param, so we could get (unlikely) panic from
> +	 * serial.

Hmm, this part of the comment is not only stale now, but gets actively
undermined. No idea how likely such a panic() would be, and hence how
relevant it is to retain this particular property.

Jan

> +	 * After this point everything still needed from the boot loader or
> +	 * firmware or kernel text should be early reserved or marked not
> +	 * RAM in e820. All other memory is free game.
> +	 */
> +	early_reserve_memory();
> +
>  #ifdef CONFIG_X86_32
>  	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
> =20
> @@ -876,18 +888,6 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	parse_early_param();
> =20
> -	/*
> -	 * Do some memory reservations *before* memory is added to
> -	 * memblock, so memblock allocations won't overwrite it.
> -	 * Do it after early param, so we could get (unlikely) panic from
> -	 * serial.
> -	 *
> -	 * After this point everything still needed from the boot loader or
> -	 * firmware or kernel text should be early reserved or marked not
> -	 * RAM in e820. All other memory is free game.
> -	 */
> -	early_reserve_memory();
> -
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  	/*
>  	 * Memory used by the kernel cannot be hot-removed because Linux
>=20

