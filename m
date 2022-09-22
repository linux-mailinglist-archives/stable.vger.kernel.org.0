Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BE15E58E5
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 04:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiIVCw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 22:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIVCw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 22:52:57 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83093AD98F;
        Wed, 21 Sep 2022 19:52:56 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28M2qZNL005825
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 22:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1663815159; bh=8jY4dQ4ZAmSSjM5+e3rDL8Jjxr7wQ3GsYBDzAq/YJtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=atzomT162gZqvwFFEIy7GWO5ENwXQFaswgqxKk4Fq8CVFBNHMkxoOy6Vi9sYDpHb+
         5/dEWHp31KCoJ08xiieKtY47UX6ZYcaSym3jAxUolspn7WGyneuxJiZyL88UxBu1PZ
         1h28M9SNqBekiNvL/WoK45dNvnKkZTaQK+SpaLy9+uSOCsDcfqmtFYciYx/nLde21O
         0Q296mUE+B2cSOCMvQpBBtk8TjuwDeSO1GSw8o/0f2DGNG21WEsOy+65s4YEZBm9vu
         dCxCtMpxoadNxhbGFet3K4bi/LQHsjcEc0sAzci5aNLorUO9bloa6Kb0//QkTqMs6S
         xpIQcudV6d++w==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B8B2315C526C; Wed, 21 Sep 2022 22:52:35 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     jack@suse.cz
Cc:     "Theodore Ts'o" <tytso@mit.edu>, harshadshirwadkar@gmail.com,
        stable@vger.kernel.org, ritesh.list@gmail.com,
        stefan.wahren@i2se.com, ojaswin@linux.ibm.com,
        linux-ext4@vger.kernel.org, regressions@leemhuis.info
Subject: Re: [PATCH 1/5] ext4: Make mballoc try target group first even with mb_optimize_scan
Date:   Wed, 21 Sep 2022 22:52:34 -0400
Message-Id: <166381513758.2957616.15274082762134894004.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220908092136.11770-1-jack@suse.cz>
References: <20220908091301.147-1-jack@suse.cz> <20220908092136.11770-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 8 Sep 2022 11:21:24 +0200, Jan Kara wrote:
> One of the side-effects of mb_optimize_scan was that the optimized
> functions to select next group to try were called even before we tried
> the goal group. As a result we no longer allocate files close to
> corresponding inodes as well as we don't try to expand currently
> allocated extent in the same group. This results in reaim regression
> with workfile.disk workload of upto 8% with many clients on my test
> machine:
> 
> [...]

Applied, thanks!

[1/5] ext4: Make mballoc try target group first even with mb_optimize_scan
      commit: 4fca50d440cc5d4dc570ad5484cc0b70b381bc2a
[2/5] ext4: Avoid unnecessary spreading of allocations among groups
      commit: 1940265ede6683f6317cba0d428ce6505eaca944
[3/5] ext4: Make directory inode spreading reflect flexbg size
      commit: 613c5a85898d1cd44e68f28d65eccf64a8ace9cf
[4/5] ext4: Use locality group preallocation for small closed files
      commit: a9f2a2931d0e197ab28c6007966053fdababd53f
[5/5] ext4: Use buckets for cr 1 block scan instead of rbtree
      commit: 83e80a6e3543f37f74c8e48a5f305b054b65ce2a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
