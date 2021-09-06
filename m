Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C4C401C16
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbhIFND5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:03:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:59592 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242514AbhIFNDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 09:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1630933368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B09f0cMqWuGZ6asm4svnxt2+uit2qVuaeHqBUujlajU=;
        b=d6BRbZnFBQrFajQKz8YBeCVvB/PUt5E+zKnuSbLMazigqlkOloI7MxSrtbh3H+27za44id
        ZAKpGGc9ebFrhfC/nSFp/gO7AbeA0qC4KG5WmJrZ7qyPUHPxbARxWlXaKKWyj5+jz4az3e
        8TLEMn+i0WxOfxXFI+GmRQOGO1/lVNY=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-QclwmbKDNEao5rnoizbFhA-1; Mon, 06 Sep 2021 15:02:47 +0200
X-MC-Unique: QclwmbKDNEao5rnoizbFhA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxKfu8CtRzx8gxb2fnd0xlSWlWQt2OOjXyxM7xB0YcUMzYd7yiy7Mmn8iOoVHl/nyVM6d1+ComJhMsu0UpPR/UKbRbgeta7NHUanBn0b34PGZf02YZRdfpjq5EDceY51brrtYsAdllTQ+lpuJYYRYhWo1pQw5spvHn3AHO+ZGn5W3xMhr+w49+uwVoaMPPLcRCGHAF5qMFj7z5Vk5ACz6M22sj8JofJLqzItSNaYQ3ksQgGTuzrhXK1wCB6mb4TkZWdxvYCGfkl57z6TEEi7x6CMqludeVp12r3fb02U9CgZDA8xAk3yvRPn6qHQmiy6b/Lo2oCYrnwbX9wrrHzIug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uoXAR6IwBEQNyiDhhIZwZke07W6ttq94npf+r2Mw3+U=;
 b=KPvyMgt0guiD4SagV4hmL7bQxVSj0EfY2PEVV/mBVDzR8Y1GbUnD4Jj2e2Kf13P+/QvlMS2scyzIv9RRYhLMKU/4RMenInaVs/rqG2kotDyM4xuj0eaXT8rrdXfKucXxrszXHE6gCD61OnENPxxilqrDGQZNH/7e0xriyzRx+aSAw6m+ncVOd1N3RfiUFAYz7P1NOrsz00qV7U1nDBhDKw7thEz/24lzZFe5VyvaEPQlkkLEFulmfyTh8T2524rLrzIXArE1XxpDpLDmpe6mkRsgqfp7S7hK5KJ8xWiGlDhx2BepA5+74rDxuWEW+ssOp6WOeMzoCvDv0dBKKe48RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB5964.eurprd04.prod.outlook.com (2603:10a6:10:83::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Mon, 6 Sep
 2021 13:02:45 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::4cc0:191d:5c04:8ede]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::4cc0:191d:5c04:8ede%7]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 13:02:45 +0000
Subject: Re: [PATCH] USB: cdc-acm: fix minor-number release
To:     Johan Hovold <johan@kernel.org>, Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
References: <20210906124339.22264-1-johan@kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <b0af8328-52c4-e5f8-5e11-36f95f32e735@suse.com>
Date:   Mon, 6 Sep 2021 15:02:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210906124339.22264-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: PR3P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::10) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2001:a61:3b08:ea01:c97d:6ea4:dece:ad44) by PR3P189CA0005.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 13:02:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33e49398-db9b-4c75-bbcc-08d971369ebd
X-MS-TrafficTypeDiagnostic: DB7PR04MB5964:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB596409E59E5D425597009094C7D29@DB7PR04MB5964.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Ia8ZZB93Y9rTx0tym+FO/8rzdtgibXjCM7dVQPzVD1UwiGzL1j27QGo3LdUQKXI/rrUrdGpUyooAzi+KoAC5plG0616Y8cYyTFvmGx3ziuVDjEYRvp1YaDqfC5q+T/GF0TD/1OsxpX4OmLNvRMgOCkHxZ7+PLpoWiDAWUqnUx83PCRvnE7pwoSJ8AWfOxkvarSXRWMXwi6xYojpDcaiqdOT6SOz5Y7rGDGV8/nYK7UkH0yeZaLXBWXaLp/BLMj7NDvrsy+Ig+FvYa+JTMirdfSNLEdtNU7Ds2ppOdsgis3+0RD20Q0mCJ15RpFnp3v+N5r3bS2h37Qv9DzYButQZMxTzEFP0/GwdyemJQsXH9AQLv0w2SoU8asv8ZT6GcR5fH6xRrG1JtV5P1bG/PM9J3BCIrblhPgOBmFrjNQtHxO1Mrafk/in0pCQAJhJm+vsCD/k/kwCE1/vIbhNis9D1hNJlB5AI4pkgMaMy0KNqMHqxplXta8dbfiFxObr+Hc/6l1v5HH3G1p01G7wm45KIZghx4e/ezZ9DCe2O+vidkNf9q/e5kXzFzQ5ThlH7+jCFSWp5Gu81azjOmyb/5M/7FoQwer5vE8fL0MZMfYBre0UB28SpMnlIqz9UJqNGx7PrRbeswZM9hGqtv6y9/w6DngUcvqK4bcJ0/KGeKttQunK3adraSkagsy6dZbiNdtG7Z81jXIGH9j6ZzWP3Yf7c/Hv/4gIk0Cxs9L8CMc+TC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(346002)(376002)(186003)(31696002)(5660300002)(66556008)(66476007)(38100700002)(316002)(8936002)(86362001)(4744005)(4326008)(83380400001)(6512007)(8676002)(478600001)(31686004)(53546011)(6506007)(66946007)(110136005)(6486002)(36756003)(2906002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R1tZw2tdFMo/LVpMI4H0PGYz1nK5UiebV4KZBsKRPXyUL1QLYU+CDIAahrG0?=
 =?us-ascii?Q?pqvJ92gvGGkTxRFJXygmowMOeg1Q9Cp0dgD19Wq6QKljLaNRmj0jmPwgOL/D?=
 =?us-ascii?Q?ggCVY9g6DLOfUxef5kWT/rUeHrDAcYaMcdOflTBSgcRhUTgm/tlh65249iVl?=
 =?us-ascii?Q?CCve7CBZ4Txt0S8YLWYKYbjL7uzQvissBV1jvX678mIbpnrKTZZfiyKIogo5?=
 =?us-ascii?Q?i0zSX/Whq93kvFYSSQrZXha74r4Tl4IerpG91VnIJJCvOmSBlVSpkM2Chz2H?=
 =?us-ascii?Q?XPH0fYO3oQrm1J/7DnWaJ2lpQXu2Dt7e27nbsUsLuLhBc9RoEw46uGtVNvhg?=
 =?us-ascii?Q?qsMzg46bTAL7MfG2cTWZapEtxbARp0RtCBInktLrssSr7AnRBAfxJkEWnQNa?=
 =?us-ascii?Q?Ci5c5QyTDi3D0FDqbWP2fvbTGIsD7QBjWweM7mw6n1Bj+yHU2vw7J0xEMjqH?=
 =?us-ascii?Q?QNbzgb4tmSOJWynR133rO+F7u1rdPfW01Kg5+czdy7CoIKb8c7F81i2ncH+z?=
 =?us-ascii?Q?t0rjj8KJ/vUBOVTOLHzvtGNVIk8vjd0Fibr9kvJBKJQFvCxZ6jXnEp4L2c+l?=
 =?us-ascii?Q?1UBRmQkts/fC5DaXAYFhHpzTcRgaOZ87qJYttBlYmlIJNy5NzACEz0SUQC6f?=
 =?us-ascii?Q?YzgaVf2iIJGAny04uz4hPKJsp4IpOxXWg+M+qunBYhSTjcbrmqf5HTBRHc7e?=
 =?us-ascii?Q?A7syLb7puPopq/oDFnu82rK/rs22Uze2lxrVUPo2y+xa730x1Dz9DqXbwGs2?=
 =?us-ascii?Q?jsswI38N7r8YB8b9JTjz9eIafKFcODDTaKlS2WRVSuIYBZUm5IAK9qvRjDJL?=
 =?us-ascii?Q?5MzK0g2xxtzM/MRJziaTexE+n9eEIiu+mHbKRpoDlncVpgAI+lDkcmr5ddrD?=
 =?us-ascii?Q?TTz3WQkxo5stSJkW/ERgOeSisU6Q7bew3LcoUbm9fIczmV6vtr6cfuH4P1i/?=
 =?us-ascii?Q?UELpe3ZwUaMPnBV/h2wcoMHYauuC5FU0PTKIVPWzOk7XDUrpZrvRM56wQ9Dz?=
 =?us-ascii?Q?+6RVf06KCbeKpVAc97Mqn3KI/3JjGbVv999ziDk/f7FwYuTw+G+d2v7NIgmM?=
 =?us-ascii?Q?xtIMjDbBA1CaMRwzT5KFIhudcER/ll+exFLHmX0pZOFaSQC/YdF1LWzHuNgG?=
 =?us-ascii?Q?p8izWQNMQoel5YDJkTIYlR9bCrHDKqfDGEDu/vs4USXIQaJWViCOr9HTzL2d?=
 =?us-ascii?Q?qny5XfN2QfinmTxAwDpP10U/KnfBvcdX/Bhg0zZR7rCV42nK8MJ/gn46kmCa?=
 =?us-ascii?Q?+NY8eKZ6jf4dS8ewbXXJHBowwwwLZZ4HhOJYmiMe5+94nGVNA95UNT1AYEfu?=
 =?us-ascii?Q?v4Z4HfvDt2Yj4LYB+H/TWcUoIGCoOgjWteB/wIIvZDYdUBUivBvlIypIVFDj?=
 =?us-ascii?Q?vJYi/4Wx0xUMCp+AiVYpOIdrKBp5?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e49398-db9b-4c75-bbcc-08d971369ebd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 13:02:45.6392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nahRkVBX/rl+oBdIYS7i56/moZFh0RRGclOdohXZPoSM0vRbJWDbishdrNMPJCEYvoJMrlTWCsaCTuw0tdjWdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5964
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06.09.21 14:43, Johan Hovold wrote:
> @@ -1323,8 +1324,10 @@ static int acm_probe(struct usb_interface *intf,
>  	usb_get_intf(acm->control); /* undone in destruct() */
> =20
>  	minor =3D acm_alloc_minor(acm);
> -	if (minor < 0)
> +	if (minor < 0) {
> +		acm->minor =3D ACM_TTY_MINORS;
>  		goto err_put_port;


Hi,

Congratulations for catching that one.

May I request to improve understandability of the code that you give
the constant a distinct name for this purpose? Something like

ACM_MINOR_POISON or ACM_INVALID_MINOR

so that normal people can understand the fixed code?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

