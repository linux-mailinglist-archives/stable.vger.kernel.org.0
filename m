Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9943852E09C
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 01:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbiESXfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 19:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiESXfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 19:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88052111BAA;
        Thu, 19 May 2022 16:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 225566194E;
        Thu, 19 May 2022 23:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4ABC34113;
        Thu, 19 May 2022 23:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653003308;
        bh=JTKD7lDzN+7WJEF3W1PJ08Q0Pi2VzLP5ieKWHMWYS0s=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Y+efLnCyyITbboBHSDH4hMjueqOQOw7iLy/8y1hcRucyr+LQ7FWvCijvx+p5PDgkK
         dwsd5vnsQgcG47viXcwqu5FD0Ozbx2YHEQuBbTQru5Q2em2v/byJ3K/2SAG+GfhMIP
         GvL3ohB2EMf2qi1CjqvOptkROp6Q3BVRCn2FGbGNIa95xBiP1t4mk/p1jE8Sse4LFm
         zzmuuAA60/B64vPwStraUC7nDiHeTCub5PPXuceocmT8eGnYgdCGjsMR5aaHLRFJqu
         HNiQbd9NHveplKP/eaYnW17sbMlEDwDsJ+hZbmSfI7JQNexJR0mxEZje7kCfkEy4Vk
         LpfXGnuP4RnmA==
Received: by mail-wm1-f49.google.com with SMTP id k126so3719792wme.2;
        Thu, 19 May 2022 16:35:08 -0700 (PDT)
X-Gm-Message-State: AOAM533j6W8WQMYevRmjyC3gLyD69seK3fJkhAlbtdZA5EObzRmvbw1K
        ReqoXlmmKz/Hd2Stgk0ThI0UerTwUkvA5XVq6Xk=
X-Google-Smtp-Source: ABdhPJwk1rjCfjD4r8fAEM0eJPfx9vTdw06IQ2xHud/uzUEVRTLFn+5e7stmRxfG9FPdZi2mQATSa5hleL+Px7OmPJ8=
X-Received: by 2002:a05:600c:1906:b0:394:5365:6720 with SMTP id
 j6-20020a05600c190600b0039453656720mr6412247wmq.102.1653003306709; Thu, 19
 May 2022 16:35:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Thu, 19 May 2022 16:35:06
 -0700 (PDT)
In-Reply-To: <20220519130055.305767-1-hyc.lee@gmail.com>
References: <20220519130055.305767-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 20 May 2022 08:35:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd__mL760Maq4Lh2SQ=JfDMi+9SyGg4LSaTakNqyMcVfsA@mail.gmail.com>
Message-ID: <CAKYAXd__mL760Maq4Lh2SQ=JfDMi+9SyGg4LSaTakNqyMcVfsA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix outstanding credits related bugs
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>, stable@vger.kernel.org,
        Yufan Chen <wiz.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-05-19 22:00 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> outstanding credits must be initialized to 0,
> because it means the sum of credits consumed by
> in-flight requests.
> And outstanding credits must be compared with
> total credits in smb2_validate_credit_charge(),
> because total credits are the sum of credits
> granted by ksmbd.
>
> This patch fix the following error,
> while frametest with Windows clients:
>
> Limits exceeding the maximum allowable outstanding requests,
> given : 128, pending : 8065
>
> Fixes: b589f5db6d4a ("ksmbd: limits exceeding the maximum allowable
> outstanding requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Reported-by: Yufan Chen <wiz.chen@gmail.com>
> Tested-by: Yufan Chen <wiz.chen@gmail.com>
> ---
> changes from v1:
>  - Add "Fixes" and stable tags
>
>  fs/ksmbd/connection.c | 2 +-
>  fs/ksmbd/smb2misc.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index 7db87771884a..e8f476c5f189 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -62,7 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>  	atomic_set(&conn->req_running, 0);
>  	atomic_set(&conn->r_count, 0);
>  	conn->total_credits = 1;
> -	conn->outstanding_credits = 1;
> +	conn->outstanding_credits = 0;
You need to consider auto negotiation from windows client connection.
So it will cause integer underflow issue.

>
>  	init_waitqueue_head(&conn->req_running_q);
>  	INIT_LIST_HEAD(&conn->conns_list);
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 4a9460153b59..f8f456377a51 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -338,7 +338,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn
> *conn,
>  		ret = 1;
>  	}
>
> -	if ((u64)conn->outstanding_credits + credit_charge >
> conn->vals->max_credits) {
> +	if ((u64)conn->outstanding_credits + credit_charge > conn->total_credits)
> {
>  		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding
> requests, given : %u, pending : %u\n",
>  			    credit_charge, conn->outstanding_credits);
>  		ret = 1;
> --
> 2.25.1
>
>
