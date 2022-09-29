Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3185EF610
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 15:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiI2NI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 09:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiI2NI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 09:08:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CEA17D40D;
        Thu, 29 Sep 2022 06:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4459FB8247F;
        Thu, 29 Sep 2022 13:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EED9C433C1;
        Thu, 29 Sep 2022 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664456901;
        bh=riOAsm3lzQkj+cjEbWOHZ+nQBRpg7+2HkYLykZVpJt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lbpTyBJOwrg3CdQD1AH16Y7w0WKGK2Z3OZOiqpxC9VQQ6sXhVxiJ7qVYqoA9KrqFs
         LRBFqfHBIs1OJR1rfaPWJaAUJ+tQ7IGH7QOkaw6YdvKC+R4ToawBGf7LBKs0oC2O+G
         he3hOjdMbemI/iEVfIGPKZwK46vbKavKz+znEFjh8IxLqy6OlY7fMawHWDPu3nwN8e
         uD645Ghd5Bu5onkVImKZY+VnqUD9bUepB8c8gNiA3O6AWrv6Gr1Y4HDP+UaOsOviGT
         Jyg92XcjkxCsti7RcJf6Uw845H5extGQEyud20saGH1IKXy/ZYREqcZHJqPdan5aRR
         DERfbERDsfakw==
Date:   Thu, 29 Sep 2022 15:08:15 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] ksmbd: Fix user namespace mapping
Message-ID: <20220929130815.3l5piy446jyynpwa@wittgenstein>
References: <20220929100447.108468-1-mic@digikod.net>
 <20220929113735.7k6fdu75oz4jvsvz@wittgenstein>
 <75d077ca-4f1d-50c4-10d2-0fb31fcd0c86@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75d077ca-4f1d-50c4-10d2-0fb31fcd0c86@digikod.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 29, 2022 at 02:18:43PM +0200, Mickaël Salaün wrote:
> 
> On 29/09/2022 13:37, Christian Brauner wrote:
> > On Thu, Sep 29, 2022 at 12:04:47PM +0200, Mickaël Salaün wrote:
> > > A kernel daemon should not rely on the current thread, which is unknown
> > > and might be malicious.  Before this security fix,
> > > ksmbd_override_fsids() didn't correctly override FS UID/GID which means
> > > that arbitrary user space threads could trick the kernel to impersonate
> > > arbitrary users or groups for file system access checks, leading to
> > > file system access bypass.
> > > 
> > > This was found while investigating truncate support for Landlock:
> > > https://lore.kernel.org/r/CAKYAXd8fpMJ7guizOjHgxEyyjoUwPsx3jLOPZP=wPYcbhkVXqA@mail.gmail.com
> > > 
> > > Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> > > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > > Cc: Namjae Jeon <linkinjeon@kernel.org>
> > > Cc: Steve French <smfrench@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > > Link: https://lore.kernel.org/r/20220929100447.108468-1-mic@digikod.net
> > > ---
> > 
> > I think this is ok. The alternative would probably be to somehow use a
> > relevant userns when struct ksmbd_user is created when the session is
> > established. But these are deeper ksmbd design questions. The fix
> > proposed here itself seems good.
> 
> That would be better indeed. I guess ksmbd works whenever the netlink peer
> is not in a user namespace with mapped UID/GID, but it should result in
> obvious access bugs otherwise (which is already the case anyway). It seems
> that the netlink peer must be trusted because it is the source of truth for
> account/user mapping anyway. This change fixes the more critical side of the
> issue and it should fit well for backports.

Sorry, I also forgot,
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
