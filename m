Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B3C648C72
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLJB5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 20:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLJB5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 20:57:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7825B4B9A2;
        Fri,  9 Dec 2022 17:57:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26EF1B82A10;
        Sat, 10 Dec 2022 01:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79397C433EF;
        Sat, 10 Dec 2022 01:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670637428;
        bh=dvjlzdS44RuljlbbdBTVkDuGixoXT1Nurmf7l9sdQCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AU3gcHjlu1K7/nqcP0qw2upsrfRuwYjwGYCEDM1WmXjAyWLoArL+/vj6A5eSXIOjU
         XBXXVW+eEhyZj/i4pg9iQU8lECIDahlX+M/RSPNsmjzePzaUZy5EuagVqEIOAvOAHP
         AdLuHaS3aUq/ReZJKKjVmfgx5n+p2e2qCQ/ScOot6m8iGm8xwURDmhy2+3iFa850HU
         Ve3QRhyjdBXEjJb4y6htm4zpnguoOIsHq6Yy6n+QJ1BJlKW4Q74HzP9NFZxZwFnNSO
         iJO+RyZiKS8Fwlkzjgx4228P1HtQsY95kBalXWag51nn8j9ZCvJGF6xFjT8AofLn2d
         SepSsuc64JKKA==
Date:   Sat, 10 Dec 2022 01:57:05 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jan =?utf-8?B?RMSFYnJvxZs=?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Message-ID: <Y5PnceyKQgBlcEUs@kernel.org>
References: <20221128195651.322822-1-Jason@zx2c4.com>
 <Y4zTnhgunXuwVXHe@kernel.org>
 <Y4zUotH0UeHlRBGP@kernel.org>
 <Y4zxly0XABDg1OhU@zx2c4.com>
 <Y5Gs9jaSIGTNdRbV@kernel.org>
 <6d13f2ba-7598-4522-e0e6-32f1577a2655@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d13f2ba-7598-4522-e0e6-32f1577a2655@suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 11:51:24AM +0100, Vlastimil Babka wrote:
> On 12/8/22 10:23, Jarkko Sakkinen wrote:
> > On Sun, Dec 04, 2022 at 08:14:31PM +0100, Jason A. Donenfeld wrote:
> >> > 
> >> > Applied to  git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
> >> 
> >> Oh thank goodness. You'll send this in for rc8 today?
> > 
> > for 6.2-rc1
> 
> Linus took it directly to rc8, so it would conflict now.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.1-rc8&id=23393c6461422df5bf8084a086ada9a7e17dc2ba

Thanks for the remark!

BR, Jarkko
