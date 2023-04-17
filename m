Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2BF6E4E02
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 18:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjDQQHo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 17 Apr 2023 12:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjDQQHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 12:07:43 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB4E659D;
        Mon, 17 Apr 2023 09:07:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id F33EA64551BD;
        Mon, 17 Apr 2023 18:07:37 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id n1W0Qrtyq6yM; Mon, 17 Apr 2023 18:07:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 913E76431C58;
        Mon, 17 Apr 2023 18:07:37 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ln_Xl0bMsm8o; Mon, 17 Apr 2023 18:07:37 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 3DEF464551BD;
        Mon, 17 Apr 2023 18:07:37 +0200 (CEST)
Date:   Mon, 17 Apr 2023 18:07:37 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        eorge kennedy <eorge.kennedy@oracle.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        syzkaller <syzkaller@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        harshit m mogalapalli <harshit.m.mogalapalli@oracle.com>,
        kernel <kernel@pengutronix.de>, stable <stable@vger.kernel.org>
Message-ID: <1791587113.113210.1681747656999.JavaMail.zimbra@nod.at>
In-Reply-To: <20230417160102.lw6n7bdxwrlkluwj@pengutronix.de>
References: <ae901608-0580-010a-26e3-99d0b704b88b@oracle.com> <20230417160102.lw6n7bdxwrlkluwj@pengutronix.de>
Subject: Re: [Regression] Cannot overwrite VID header offset any more [Was:
 [PATCH] ubi: ensure that VID header offset + VID header size <= alloc,
 size]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Cannot overwrite VID header offset any more [Was: [PATCH] ubi: ensure that VID header offset + VID header size <= alloc, size]
Thread-Index: QZS7NxF6po442+3+qhw1upzn2ik3iw==
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Uwe,

----- Ursprüngliche Mail -----
> Von: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> This patch is in mainline as 1b42b1a36fc946f0d7088425b90d491b4257ca3e,
> and backported to various stable releases.
> 
> For me this breaks
> 
>	ubiattach -m 0 -O 2048
> 
> I think the check
> 
>	ubi->vid_hdr_offset + UBI_VID_HDR_SIZE > ubi->vid_hdr_alsize
> 
> is wrong. Without -O passed to ubiattach (and dynamic debug enabled) I
> get:
> 
> [ 5294.936762] UBI DBG gen (pid 9619): sizeof(struct ubi_ainf_peb) 56
> [ 5294.936769] UBI DBG gen (pid 9619): sizeof(struct ubi_wl_entry) 32
> [ 5294.936774] UBI DBG gen (pid 9619): min_io_size      2048
> [ 5294.936779] UBI DBG gen (pid 9619): max_write_size   2048
> [ 5294.936783] UBI DBG gen (pid 9619): hdrs_min_io_size 512
> [ 5294.936787] UBI DBG gen (pid 9619): ec_hdr_alsize    512
> [ 5294.936791] UBI DBG gen (pid 9619): vid_hdr_alsize   512
> [ 5294.936796] UBI DBG gen (pid 9619): vid_hdr_offset   512
> [ 5294.936800] UBI DBG gen (pid 9619): vid_hdr_aloffset 512
> [ 5294.936804] UBI DBG gen (pid 9619): vid_hdr_shift    0
> [ 5294.936808] UBI DBG gen (pid 9619): leb_start        2048
> [ 5294.936812] UBI DBG gen (pid 9619): max_erroneous    409
> 
> So the check would only pass for vid_hdr_offset <= 512 -
> UBI_VID_HDR_SIZE; note that even specifying the default value 512 (i.e.
> 
>	ubiattach -m 0 -O 512
> 
> ) fails the check.
> 
> A less strong check would be:
> 
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index 0904eb40c95f..69c28a862430 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -666,8 +666,8 @@ static int io_init(struct ubi_device *ubi, int
> max_beb_per1024)
> 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
> 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
> 
> -	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
> -	    ubi->vid_hdr_alsize)) {
> +	if (ubi->vid_hdr_offset &&
> +	    ubi->vid_hdr_offset + UBI_VID_HDR_SIZE > ubi->peb_size) {
> 		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
> 		return -EINVAL;
> 	}
> 
> But I'm unsure if this would be too lax?!

As written on IRC, 1e020e1b96af ("ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size") is supposed to fix that
and on it's way into stable.

Thanks,
//richard
