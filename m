Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479FB4F0A6B
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 16:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiDCOz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 10:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiDCOz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 10:55:26 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB89FF4;
        Sun,  3 Apr 2022 07:53:31 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 233ErMCs020996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 3 Apr 2022 10:53:22 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 1FBF915C003E; Sun,  3 Apr 2022 10:53:22 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-ext4@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] ext4: limit length to bitmap_maxbytes - blocksize in punch_hole
Date:   Sun,  3 Apr 2022 10:53:17 -0400
Message-Id: <164899700423.964485.7890254685030914129.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220331200515.153214-1-tadeusz.struk@linaro.org>
References: <20220331200515.153214-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 31 Mar 2022 13:05:15 -0700, Tadeusz Struk wrote:
> Syzbot found an issue [1] in ext4_fallocate().
> The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
> and offset 0x1000000ul, which, when added together exceed the
> bitmap_maxbytes for the inode. This triggers a BUG in
> ext4_ind_remove_space(). According to the comments in this function
> the 'end' parameter needs to be one block after the last block to be
> removed. In the case when the BUG is triggered it points to the last
> block. Modify the ext4_punch_hole() function and add constraint that
> caps the length to satisfy the one before laster block requirement.
> 
> [...]

Applied, thanks!

[1/1] ext4: limit length to bitmap_maxbytes - blocksize in punch_hole
      commit: dfc99c5e84e46c610a7bf81dc4a3a126253be459

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
