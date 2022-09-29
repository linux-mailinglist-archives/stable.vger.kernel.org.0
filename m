Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEDC5EF46D
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiI2Lhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 07:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiI2Lhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 07:37:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBFE14F8CD;
        Thu, 29 Sep 2022 04:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9DC6B8245F;
        Thu, 29 Sep 2022 11:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B99C433C1;
        Thu, 29 Sep 2022 11:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664451461;
        bh=uRl5cXPSzrgDgZEmBB96Z+bBbGLnVEN9hWoSXJsFsP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r9VdoM7VBo44GyTZ/Doqk0R4z7lK2DOILIkhkvdDQC8Yg/p0GfPUKcHWiLnbgxTvW
         AFQNfOyi8+DqJcoMBRrHREKi7r+4hJu27jdvbYeXPNmUC7zoq46TavZ2KvhjG9GXGX
         TUkUnv9vDZfP5wMNkH9mE9cohPSc8GejiwQv7LyB4SUuISiL4cL41MbCDWY9co9/Qc
         mQ3q/FuyII3Wqog9tNzaOg8ZaUHMtdTQeXT4Rapf2dB4arlLY4QBgPqAfqB1rtjJok
         MxANMkKHy7aqUdwNtn1IILfiSy8VX6VCqST26eppRlmNvLNB7rvoqn2ePcXAe5VRmr
         rstr/By0Jgbng==
Date:   Thu, 29 Sep 2022 13:37:35 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] ksmbd: Fix user namespace mapping
Message-ID: <20220929113735.7k6fdu75oz4jvsvz@wittgenstein>
References: <20220929100447.108468-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220929100447.108468-1-mic@digikod.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 29, 2022 at 12:04:47PM +0200, Mickaël Salaün wrote:
> A kernel daemon should not rely on the current thread, which is unknown
> and might be malicious.  Before this security fix,
> ksmbd_override_fsids() didn't correctly override FS UID/GID which means
> that arbitrary user space threads could trick the kernel to impersonate
> arbitrary users or groups for file system access checks, leading to
> file system access bypass.
> 
> This was found while investigating truncate support for Landlock:
> https://lore.kernel.org/r/CAKYAXd8fpMJ7guizOjHgxEyyjoUwPsx3jLOPZP=wPYcbhkVXqA@mail.gmail.com
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Link: https://lore.kernel.org/r/20220929100447.108468-1-mic@digikod.net
> ---

I think this is ok. The alternative would probably be to somehow use a
relevant userns when struct ksmbd_user is created when the session is
established. But these are deeper ksmbd design questions. The fix
proposed here itself seems good.
