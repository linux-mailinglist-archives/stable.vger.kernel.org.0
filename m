Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA2646240
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 21:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLGURW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 15:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLGURV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 15:17:21 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38F65D68C
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 12:17:18 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-144bd860fdbso9507548fac.0
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 12:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20210112.gappssmtp.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEx8KSd6M/54L2Poz9MZcu5n+KLYE7RdzT7Oy3ZvWZQ=;
        b=a5vOlXF4JUZQNcWlhUdUDAYIBDZv3IOLAFAohW2XoI9rwR2X/VY+H/ux3VztfMOa+R
         AZTbIM+LMvqOtkmZNUbuzrHzc9rHPn2VqNKudM3wOBvaEQiT37vQgwc0jv7fRDBwI/vL
         SwNgjOIPO8MEglyt8a/h6z6qaGa3NzUSXrp5R1DcJhgidyLvVmQ2kaKikujz3gP+arId
         ck3qW5vXsxcih8tDzy8OpjkC30cXzc0fSb9aG6ruDr/3+91ATWYscyGf0HQ9y0+bPnZC
         xLHa8eRRByKUoxkgvLRhlM6hcGSt3AZirBLPy7mNCncKundokUcQ5UhZ8KMjszYxA+8z
         1DIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEx8KSd6M/54L2Poz9MZcu5n+KLYE7RdzT7Oy3ZvWZQ=;
        b=scACuBsBt4OS6hFF0rzm2TBmhTjB7vxBwsnD6FO0/bHXqYM9G9o6ZuwWR+ZayCXFf6
         pDu2JEHl0VZFLYpu+ySPXMT7dPNkhQpR9QM7LiWvDBd1I+r6HQeJUvMOXqoTZvIgUOfk
         XBgMaWnoJIiglb9kzyv7aH+JI7PeYUktGJBTR5qn2youLuJUOcqRD8cAzjkmI84liNIF
         Ywe8xQAe3Qi6PLD2BF7PcXZvI4tX8cUnS7a5lR6l25kT4zh/L2Rhq3BLGBIftx4KaWT8
         eKxKpKY5uwfzOwI7PjogXlu6EDBPlHP6E7nt2o5bw87426jZJJtcm6M6Qh2UKKv10mMD
         5l5g==
X-Gm-Message-State: ANoB5pkItpHxbD2lQlGZxmjnS5DBazQIyBAzc0A2YiJrdOPKkx7GFk03
        EqsThCT74g8torHab92ExU94Eg==
X-Google-Smtp-Source: AA0mqf4Q6jcuI0xaALjHHV1uTyYpPiQ0FTylWK3YV4FrnqaTPAlVtnMeN9i8KLCvxpC5py5SmVmnvQ==
X-Received: by 2002:a05:6871:a6a1:b0:144:1f08:c66b with SMTP id wh33-20020a056871a6a100b001441f08c66bmr16700065oab.279.1670444237949;
        Wed, 07 Dec 2022 12:17:17 -0800 (PST)
Received: from smtpclient.apple (172-125-78-211.lightspeed.sntcca.sbcglobal.net. [172.125.78.211])
        by smtp.gmail.com with ESMTPSA id eo7-20020a056870ec8700b001446a45bb49sm7767366oab.23.2022.12.07.12.17.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Dec 2022 12:17:17 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2] hfsplus: Fix bug causing custom uid and gid being
 unable to be assigned with mount
From:   Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <C0264BF5-059C-45CF-B8DA-3A3BD2C803A2@live.com>
Date:   Wed, 7 Dec 2022 12:17:14 -0800
Cc:     "willy@infradead.org" <willy@infradead.org>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <082FE5D4-5B72-4B4F-AC00-E0D52C7F8758@dubeyko.com>
References: <93F5197D-2B61-4129-B5D4-771934F70577@live.com>
 <C0264BF5-059C-45CF-B8DA-3A3BD2C803A2@live.com>
To:     Aditya Garg <gargaditya08@live.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 6, 2022, at 7:05 PM, Aditya Garg <gargaditya08@live.com> wrote:
>=20
> From: Aditya Garg <gargaditya08@live.com>
>=20
> Despite specifying UID and GID in mount command, the specified UID and =
GID
> were not being assigned. This patch fixes this issue.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
> fs/hfsplus/hfsplus_fs.h | 2 ++
> fs/hfsplus/inode.c      | 4 ++--
> fs/hfsplus/options.c    | 4 ++++
> 3 files changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index a5db2e3b2..6aa919e59 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -198,6 +198,8 @@ struct hfsplus_sb_info {
> #define HFSPLUS_SB_HFSX		3
> #define HFSPLUS_SB_CASEFOLD	4
> #define HFSPLUS_SB_NOBARRIER	5
> +#define HFSPLUS_SB_UID		6
> +#define HFSPLUS_SB_GID		7
>=20
> static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block =
*sb)
> {
> diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
> index aeab83ed1..b675581aa 100644
> --- a/fs/hfsplus/inode.c
> +++ b/fs/hfsplus/inode.c
> @@ -192,11 +192,11 @@ static void hfsplus_get_perms(struct inode =
*inode,
> 	mode =3D be16_to_cpu(perms->mode);
>=20
> 	i_uid_write(inode, be32_to_cpu(perms->owner));
> -	if (!i_uid_read(inode) && !mode)
> +	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || =
(!i_uid_read(inode) && !mode))
> 		inode->i_uid =3D sbi->uid;
>=20
> 	i_gid_write(inode, be32_to_cpu(perms->group));
> -	if (!i_gid_read(inode) && !mode)
> +	if ((test_bit(HFSPLUS_SB_GID, &sbi->flags)) || =
(!i_gid_read(inode) && !mode))
> 		inode->i_gid =3D sbi->gid;
>=20
> 	if (dir) {
> diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
> index 047e05c57..c94a58762 100644
> --- a/fs/hfsplus/options.c
> +++ b/fs/hfsplus/options.c
> @@ -140,6 +140,8 @@ int hfsplus_parse_options(char *input, struct =
hfsplus_sb_info *sbi)
> 			if (!uid_valid(sbi->uid)) {
> 				pr_err("invalid uid specified\n");
> 				return 0;
> +			} else {
> +				set_bit(HFSPLUS_SB_UID, &sbi->flags);
> 			}
> 			break;
> 		case opt_gid:
> @@ -151,6 +153,8 @@ int hfsplus_parse_options(char *input, struct =
hfsplus_sb_info *sbi)
> 			if (!gid_valid(sbi->gid)) {
> 				pr_err("invalid gid specified\n");
> 				return 0;
> +			} else {
> +				set_bit(HFSPLUS_SB_GID, &sbi->flags);
> 			}
> 			break;
> 		case opt_part:
> --=20
> 2.38.1
>=20

Looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.


