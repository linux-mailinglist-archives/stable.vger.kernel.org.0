Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8496760771E
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 14:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJUMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 08:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJUMlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 08:41:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643502681F3;
        Fri, 21 Oct 2022 05:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845C7B82B66;
        Fri, 21 Oct 2022 12:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53564C433C1;
        Fri, 21 Oct 2022 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666356092;
        bh=TqgVDSS9DxuiWIHPFZ6jM+uoKNWWo4i2BhM1Zw++h/w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I/dfjI9brR5SLfBUxBrcP2z4vwsxifAH5Zo7haWJxqKZkbByUNG2klGiIbGWNFMAl
         RQUYq6mx93fDBvvBLzDO94T+rCvQ6Kw19gVbLjmS9ejdyBH/TPFOYZ/NC20OUHJVQN
         PmN8r7dBHj1YWzGzl2TUT5wkh9PCu/DFuU6tnLrm3/OacliqBhCGqiiR7/XAE8IbDj
         XWhByt8zQAUxSHTi1sggIgpARl17WIgM0LGbYWtJSHvuY4cix/3a/Gpk+9eRF+eedC
         FJvQyXuxp+O/UJjamiOe59mtX36QxsVTWAw+kKNtknm7MCHXSdefYZ/Yihpd2cghew
         de5gTt0KKKk3g==
Message-ID: <b9d370b063915c09ce2b2ff6bdc643ed1796ffb4.camel@kernel.org>
Subject: Re: [PATCH] isofs: prevent file time rollover after year 2038
From:   Jeff Layton <jlayton@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, Thomas Schmitt <scdbackup@gmx.net>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 21 Oct 2022 08:41:29 -0400
In-Reply-To: <20221020160037.4002270-1-arnd@kernel.org>
References: <20221020160037.4002270-1-arnd@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-10-20 at 18:00 +0200, Arnd Bergmann wrote:
> From: Thomas Schmitt <scdbackup@gmx.net>
>=20
> Change the return type of function iso_date() from int to time64_t,
> to avoid truncating to the 1902..2038 date range.
>=20
> After this patch, the reported timestamps should fall into the
> range reported in the s_time_min/s_time_max fields.
>=20
> Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
> Cc: stable@vger.kernel.org
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D800627
> Fixes: 34be4dbf87fc ("isofs: fix timestamps beyond 2027")
> Fixes: 5ad32b3acded ("isofs: Initialize filesystem timestamp ranges")
> [arnd: expand changelog text slightly]
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/isofs/isofs.h | 2 +-
>  fs/isofs/util.c  | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
> index dcdc191ed183..c3473ca3f686 100644
> --- a/fs/isofs/isofs.h
> +++ b/fs/isofs/isofs.h
> @@ -106,7 +106,7 @@ static inline unsigned int isonum_733(u8 *p)
>  	/* Ignore bigendian datum due to broken mastering programs */
>  	return get_unaligned_le32(p);
>  }
> -extern int iso_date(u8 *, int);
> +extern time64_t iso_date(u8 *, int);
> =20
>  struct inode;		/* To make gcc happy */
> =20
> diff --git a/fs/isofs/util.c b/fs/isofs/util.c
> index e88dba721661..348af786a8a4 100644
> --- a/fs/isofs/util.c
> +++ b/fs/isofs/util.c
> @@ -16,10 +16,10 @@
>   * to GMT.  Thus  we should always be correct.
>   */
> =20
> -int iso_date(u8 *p, int flag)
> +time64_t iso_date(u8 *p, int flag)
>  {
>  	int year, month, day, hour, minute, second, tz;
> -	int crtime;
> +	time64_t crtime;
> =20
>  	year =3D p[0];
>  	month =3D p[1];

Reviewed-by: Jeff Layton <jlayton@kernel.org>
