Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DF65EF58D
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiI2MiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiI2MiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 08:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72434156266;
        Thu, 29 Sep 2022 05:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CEF61115;
        Thu, 29 Sep 2022 12:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D590C433C1;
        Thu, 29 Sep 2022 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664455091;
        bh=mRrUNM7+p72pJHqPnykKn/Zt/oesC8M/2In8IrJGsLQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FWs8l1n+nGsj9uyCTcVdBRgadHP/lNF7/cYpscLyXBI6Ni8BPTr48JTMBXR0mB53U
         sb+FUD6kdxIrjYMWOlKn0/8IujhlLeSQ0i0UJ8ZH1fBaxx2lvAya9HkP4cJp1SsLlZ
         aRk4j2e2VBvgfVoof05l1E1gu+bX2Xou3kRL82UmNQ8+rkFXZnn5j+0YUeL6mWHhQh
         BbfdgILOggMugxwhUEAlYU4Mfb27tdE7l1RLBuVp6fO/7tP821rUjKzli3kHzLdtIN
         +zrUUnLfbmUUZ2EN6Vf+pzPLq9tf5GrHJGWr9MUEuEXB1CmLJfaiHvby9Wfaljg3Io
         /gYBtA4YijvKg==
Received: by mail-oo1-f45.google.com with SMTP id r136-20020a4a378e000000b004755953bc6cso151572oor.13;
        Thu, 29 Sep 2022 05:38:11 -0700 (PDT)
X-Gm-Message-State: ACrzQf0N8zyrp4F6F3u2lVOUZArYzRE02YzM9RcsrQxDGD1W255Ul8A/
        2UQ1qX4Tp1/suLmXb2YwTJMKvHXcg/KwHjH7j3I=
X-Google-Smtp-Source: AMsMyM5jlcRVB2xGG/IWxGYEtQj5ECfAkQRZDkwKW6ZB0NyWkXTZWKSP4dTYjccZUcWlluJZoXZ/MrOLDzLtTqpDWx4=
X-Received: by 2002:a4a:2243:0:b0:44a:e5cf:81e5 with SMTP id
 z3-20020a4a2243000000b0044ae5cf81e5mr1230487ooe.44.1664455090474; Thu, 29 Sep
 2022 05:38:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 29 Sep 2022 05:38:10
 -0700 (PDT)
In-Reply-To: <20220929100447.108468-1-mic@digikod.net>
References: <20220929100447.108468-1-mic@digikod.net>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 29 Sep 2022 21:38:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ahoFm-A7DbQHAjODvvzdVPnvAQM+PcSz5GNUtq_sJKg@mail.gmail.com>
Message-ID: <CAKYAXd8ahoFm-A7DbQHAjODvvzdVPnvAQM+PcSz5GNUtq_sJKg@mail.gmail.com>
Subject: Re: [PATCH v1] ksmbd: Fix user namespace mapping
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-09-29 19:04 GMT+09:00, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>:
> A kernel daemon should not rely on the current thread, which is unknown
> and might be malicious.  Before this security fix,
> ksmbd_override_fsids() didn't correctly override FS UID/GID which means
> that arbitrary user space threads could trick the kernel to impersonate
> arbitrary users or groups for file system access checks, leading to
> file system access bypass.
>
> This was found while investigating truncate support for Landlock:
> https://lore.kernel.org/r/CAKYAXd8fpMJ7guizOjHgxEyyjoUwPsx3jLOPZP=3DwPYcb=
hkVXqA@mail.gmail.com
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20220929100447.108468-1-mic@digikod.net
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
