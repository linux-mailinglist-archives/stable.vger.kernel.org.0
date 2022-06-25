Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0B55A6CC
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 06:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiFYEKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 00:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiFYEKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 00:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801AC506D9;
        Fri, 24 Jun 2022 21:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BE60B819AC;
        Sat, 25 Jun 2022 04:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28E8C385A5;
        Sat, 25 Jun 2022 04:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656130223;
        bh=KvntBsRQ+a7tqPYKKwPyELxC4uT2n0mXrSnlbdOBc4c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=rReh3Ji7zZ3ymGFB4HyvC8gVtlkIRV7wvwSa9bEfCuyEtck2pHM5Xv+CBYtctTBJl
         UcqLiMQm4NMofJOZRv3oCWg8FuixiSRQwCSOER/S1kWO7J41SlCAnJ8HdhTfoYjv2Y
         Mm3beuXQib+yQIEVY4Ctq+AesgrtrlchO2iOTKy3WSbje9UjggOcXzAImWKat+I5WL
         1OhBwYjpJnWebojLDDsxlfdodeXNOjqKXJRJA1Au+EWUtU2lVcMps/ehN9YpszjOto
         Bp/emvhmnGPomM0aCvmJiVNIr3BdWyYETyJKqDsVv4lRyWiMoExIoqlOUp8TQwQyXK
         otPbzT/H3Erag==
Received: by mail-wm1-f44.google.com with SMTP id m184so2280064wme.1;
        Fri, 24 Jun 2022 21:10:23 -0700 (PDT)
X-Gm-Message-State: AJIora9G00skNE9pYq+PNtN1TqrRlG9B5BFf42g7nbGErEYBGQclTNHL
        CBMlRmItuYgaF6Yx1UW96QeV7iGHvIxsOwf47AA=
X-Google-Smtp-Source: AGRyM1taOVgJS6yKa1ur8skTuwbJGXAo87WjdcLBFPHrJVL2bmqRfL9e4MLKFR65JkrcoylEqd7a+SwtvU144eYw5fw=
X-Received: by 2002:a05:600c:1d96:b0:3a0:30b6:bb1a with SMTP id
 p22-20020a05600c1d9600b003a030b6bb1amr7127566wms.93.1656130222011; Fri, 24
 Jun 2022 21:10:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f805:0:0:0:0:0 with HTTP; Fri, 24 Jun 2022 21:10:21
 -0700 (PDT)
In-Reply-To: <20220624165631.2124632-2-Jason@zx2c4.com>
References: <20220624165631.2124632-1-Jason@zx2c4.com> <20220624165631.2124632-2-Jason@zx2c4.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Jun 2022 13:10:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Lc9+HUuVD-UDvk4ff0KAtMLqEWBs2syFzUszpSDb_Sw@mail.gmail.com>
Message-ID: <CAKYAXd_Lc9+HUuVD-UDvk4ff0KAtMLqEWBs2syFzUszpSDb_Sw@mail.gmail.com>
Subject: Re: [PATCH 1/6] ksmbd: use vfs_llseek instead of dereferencing NULL
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-06-25 1:56 GMT+09:00, Jason A. Donenfeld <Jason@zx2c4.com>:
> By not checking whether llseek is NULL, this might jump to NULL. Also,
> it doesn't check FMODE_LSEEK. Fix this by using vfs_llseek(), which
> always does the right thing.
>
> Fixes: f44158485826 ("cifsd: add file operations")
> Cc: stable@vger.kernel.org
> Cc: linux-cifs@vger.kernel.org
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Ronnie Sahlberg <lsahlber@redhat.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
