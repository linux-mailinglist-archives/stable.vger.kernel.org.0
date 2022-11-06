Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E6461E07E
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 07:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiKFGRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 01:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKFGRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 01:17:08 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E24DE98;
        Sat,  5 Nov 2022 23:17:06 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2A66GwOd032684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 6 Nov 2022 01:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1667715420; bh=sP0ybmGgYruTos8gDoWNUX5C6ji8NsMQXypakkdfDL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=pVVhRdYXG6pkhIxgAn5Vcta8ftCl2Jj1hmdwl332L+T+1i02F8gEMYyvt+vTNFwxf
         Q+9dG9d6Ry9iMon9Mr3mOj8orFskg71w019ozK28mIQGcBvQ0PGndYMkFwCcARVxdZ
         yEF5O8JEsk37MJLlu4WmPdS43jMLFifjQdtzDc8n9bgj9Akfbt/JAQLmeQxeh8mUGj
         N1TGPhUN4DGhUpAKbOPo647FkbkF/tK/elPhXP2SMTTZl3G/JngeX1Q/RiyQzz2Ncv
         AAjPrckdVTBQLGpVq1XA8JRqSpyxYVPellKK0UGN28urhr52l7wUUjXm7uTL1k1ZXU
         FQcKYT3fPW4Gw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 127DD15C45B9; Sun,  6 Nov 2022 01:16:58 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix BUG_ON() when directory entry has invalid rec_len
Date:   Sun,  6 Nov 2022 01:16:51 -0500
Message-Id: <166771539910.127460.13255978172835793776.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20221012131330.32456-1-lhenriques@suse.de>
References: <20221010142035.2051-1-lhenriques@suse.de> <20221012131330.32456-1-lhenriques@suse.de>
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

On Wed, 12 Oct 2022 14:13:30 +0100, Luís Henriques wrote:
> The rec_len field in the directory entry has to be a multiple of 4.  A
> corrupted filesystem image can be used to hit a BUG() in
> ext4_rec_len_to_disk(), called from make_indexed_dir().
> 
>  ------------[ cut here ]------------
>  kernel BUG at fs/ext4/ext4.h:2413!
>  ...
>  RIP: 0010:make_indexed_dir+0x53f/0x5f0
>  ...
>  Call Trace:
>   <TASK>
>   ? add_dirent_to_buf+0x1b2/0x200
>   ext4_add_entry+0x36e/0x480
>   ext4_add_nondir+0x2b/0xc0
>   ext4_create+0x163/0x200
>   path_openat+0x635/0xe90
>   do_filp_open+0xb4/0x160
>   ? __create_object.isra.0+0x1de/0x3b0
>   ? _raw_spin_unlock+0x12/0x30
>   do_sys_openat2+0x91/0x150
>   __x64_sys_open+0x6c/0xa0
>   do_syscall_64+0x3c/0x80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> [...]

Applied, thanks!

[1/1] ext4: fix BUG_ON() when directory entry has invalid rec_len
      commit: 17a0bc9bd697f75cfdf9b378d5eb2d7409c91340

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
