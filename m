Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D869BE9F
	for <lists+stable@lfdr.de>; Sun, 19 Feb 2023 06:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjBSFlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Feb 2023 00:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBSFlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Feb 2023 00:41:12 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3951351A
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 21:41:07 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 31J5etXY024839
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Feb 2023 00:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1676785257; bh=a/1o90U/Eo0pu6pJam+ftya3XtlH4wiMRvKXpc1KQ/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=beHFnNU4Umq/5gz4++svkestXJbi57W9NtKQZtP/kaujKP9E/n3HRIsQqBFbyJahx
         E0yOIc4FENmgc8hpSF7t9cMZgAwsia+PL9iLd56NXKa3rQyRWX0+gkeXVfJH42lwcw
         tI3R4uaj5msWylowAmwt8yv3mbHzaZEbwn9tio8Nk5WsA3gTa+6muFkluEeZhCBhbX
         iWtVq+RSVhfyjZXJrlaTQnT6Za+BrSHt0GPo1Y+3/9WPlBBJUOXLuJt3Cf/5rh28IQ
         6+DcOpBW9IRwYOUuRgKjpm6eKCVssAuoah+zqqFqHivfefbovTTuoXjqoITyz/wFj+
         3ycD7BRecl+qQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C585515C35A5; Sun, 19 Feb 2023 00:40:55 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix possible corruption when moving a directory
Date:   Sun, 19 Feb 2023 00:40:45 -0500
Message-Id: <167678522174.2723470.1416925836426052894.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230126112221.11866-1-jack@suse.cz>
References: <20230126112221.11866-1-jack@suse.cz>
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

On Thu, 26 Jan 2023 12:22:21 +0100, Jan Kara wrote:
> When we are renaming a directory to a different directory, we need to
> update '..' entry in the moved directory. However nothing prevents moved
> directory from being modified and even converted from the inline format
> to the normal format. When such race happens the rename code gets
> confused and we crash. Fix the problem by locking the moved directory.
> 
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix possible corruption when moving a directory
      commit: 98c8afa3038a32bcd062efd0b4b7009436049b7d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
