Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB69659BCF
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 21:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiL3UHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 15:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3UHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 15:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E69D1A83E;
        Fri, 30 Dec 2022 12:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5044B81C06;
        Fri, 30 Dec 2022 20:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECF2C433D2;
        Fri, 30 Dec 2022 20:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672430838;
        bh=CzogiAjhL4DuL/nHxlTU3rMK1OkNXJmD0GC4sgYlGRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hGtHN1KDMxv5opnQs7Y3ceAgE0qoqBzp62nMP0l0IT+T3CgsyzTgp78UK3tfTvMo1
         G8vHWplNMe60VpdE0b4U+hxhB9/yl8kXBgcT8Yn9lwo7RVSn2zOxrk8Ven5P42H3SS
         4VNsw/iM+H4LeAqHON0BBj+UMF225Kqcv+bMsaClsZx34LjWetFYJnnYakVQqS0rKN
         EdYuEU2g8xvJYJgCqxIvSkl/wbctMcHo7Ral1VdmsndfBOvPGaifKO8tKZZ+DCUDWY
         zqz0ECE5Y7PRihQI53wGcwi5lSyUkb2gSKWgOHEZzpcs1OXX2RTMainA++G6oBKrHL
         nc79XePL9qsnw==
Date:   Fri, 30 Dec 2022 12:07:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com,
        syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix possible use-after-free in ext4_find_extent
Message-ID: <Y69E9DMEk+yEFDNQ@sol.localdomain>
References: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
 <Y66LkPumQjHC2U7d@sol.localdomain>
 <cf1be149-392d-afa0-092a-c3426868f852@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1be149-392d-afa0-092a-c3426868f852@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 01:42:45PM +0200, Tudor Ambarus wrote:
> 
> Seems that __ext4_iget() is not called on writes.

It is called when the inode is first accessed.  Usually that's when the file is
opened.

So the question is why didn't it validate the inode's extent header, or
alternatively how did the inode's extent header get corrupted afterwards.

> You can find below the sequence of calls that leads to the bug.

A stack trace is not a reproducer.  Things must have happened before that point.

- Eric
