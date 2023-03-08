Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87866AFDEE
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 05:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCHEeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 23:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCHEdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 23:33:55 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B7E9EF69
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 20:33:53 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 3284XTvr021510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Mar 2023 23:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678250011; bh=5pMWU6jII+CDzJ3zfBYzkUuOg2Vxa1wRZCqfVcF9NJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fQhdRuF0Ca9IEXfQKd+n1CWjT4/CljpFoikCFVl7AO2kkLJZ1QrGEPJcagh7ta2rY
         BGXxUedt75uaQKW7xU1cgPnuBe//MVsbHRA6aCnxEuj6oWspQ7Z91SvYoXoqIpbliP
         hMhV7kimgU4zNhgCardZfP3GqqqajPTIRl8j0b2pfjDWL38Ye2Kl8FAzgS4Xc5ImWD
         OUMXf52s2nH5CtbxDuU+VwC5StYHrIWm9lLlRnsPvWemVDXhTNlIagqLz5YSZthj4X
         Ru2u5eR7BMIj+DqlkfW+7Fpm47kjVB9Eo3HseBZnt6KVmCZYKTwjCBbGDoOmC8fzNP
         FbaBkJ14wWcVg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id CF9E715C3444; Tue,  7 Mar 2023 23:33:29 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix cgroup writeback accounting with fs-layer encryption
Date:   Tue,  7 Mar 2023 23:33:22 -0500
Message-Id: <167824999281.2129363.12204207098890359786.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230203005503.141557-1-ebiggers@kernel.org>
References: <20230203005503.141557-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 Feb 2023 16:55:03 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When writing a page from an encrypted file that is using
> filesystem-layer encryption (not inline encryption), ext4 encrypts the
> pagecache page into a bounce page, then writes the bounce page.
> 
> It also passes the bounce page to wbc_account_cgroup_owner().  That's
> incorrect, because the bounce page is a newly allocated temporary page
> that doesn't have the memory cgroup of the original pagecache page.
> This makes wbc_account_cgroup_owner() not account the I/O to the owner
> of the pagecache page as it should.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix cgroup writeback accounting with fs-layer encryption
      commit: ffec85d53d0f39ee4680a2cf0795255e000e1feb

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
