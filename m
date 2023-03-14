Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3139B6B8EB7
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCNJ2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCNJ2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:28:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C0B9AA0A;
        Tue, 14 Mar 2023 02:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42E57B8169E;
        Tue, 14 Mar 2023 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C3C433D2;
        Tue, 14 Mar 2023 09:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678786114;
        bh=+y+PFZkCMafTCp1MlMbYHe/bAWt9i0iX1AntFEuCFrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBpekMWNmWJz0SQJle/kgkEso9oXcZ5cowr1XU6aK+OJkTcK0e9BuQMchHwOkphYV
         ByaAVlxXZfvw7VR9s1jSKZMAW2D9b5QFXtK6f/UvTPUc7C7o4y8ZUDdXmsqhC/Pv1c
         5kk8utcsdbwmn7Px9/oL+9JRiLHRIfKT6duHwK6XtZWQuWqzf5dYVCPfEmqOGWmaDO
         aljLWrVHKMY36QFMBZfurk+ycuD71DZhvVXcyEqfNf99OlXKlnl/hUXnui6uCVBox4
         XWO118CHPv7f+yISza8MUz7b7TnP1Ff77P7SVaI6+syAERkhLD3PiSKXAsFhVb7zlE
         CM9bT/VQ5ofaQ==
Date:   Tue, 14 Mar 2023 10:28:29 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        syzbot+93e495f6a4f748827c88@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/3] fscrypt: destroy keyring after security_sb_delete()
Message-ID: <20230314092829.l2sx7vck2amiq74a@wittgenstein>
References: <20230313221231.272498-1-ebiggers@kernel.org>
 <20230313221231.272498-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230313221231.272498-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 03:12:29PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt_destroy_keyring() must be called after all potentially-encrypted
> inodes were evicted; otherwise it cannot safely destroy the keyring.
> Since inodes that are in-use by the Landlock LSM don't get evicted until
> security_sb_delete(), this means that fscrypt_destroy_keyring() must be
> called *after* security_sb_delete().
> 
> This fixes a WARN_ON followed by a NULL dereference, only possible if
> Landlock was being used on encrypted files.
> 
> Fixes: d7e7b9af104c ("fscrypt: stop using keyrings subsystem for fscrypt_master_key")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+93e495f6a4f748827c88@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/00000000000044651705f6ca1e30@google.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
