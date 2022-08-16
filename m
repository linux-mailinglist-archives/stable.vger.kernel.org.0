Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0377595A20
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiHPLaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiHPL3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052D1D31DB;
        Tue, 16 Aug 2022 03:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E85CB8169E;
        Tue, 16 Aug 2022 10:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9CAC433C1;
        Tue, 16 Aug 2022 10:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646807;
        bh=qTgkAUd/vi2DE12y645WmWS69rJJiMlcQOUJOELNr/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fOIjjW1Yqm4cTqTpyRsnRW3lWfVjjJwTxpyTo7LRNDNe5hSLt8b9/0BAjmYquA79q
         l9ZOUb1oVHb8JpwDUg8Jjfo91bZOTuYeSvdAfskaraN+s+VAEfQINbn0t/6RnKpMxT
         ZIDeHm3ccKD9C9E+b4feK0rgRxLRTyM/ilNYo/r7ZRpHQcYZAC7MEiRYig4IZmN7dx
         QNHSXCvpwORccOR739Z1brNpB6GzviQ7wJDGnURXv4EMth+DCA/gmegw+//qJH+7zK
         wYcwgb2kFeOPywg5lPjOe2QNJYMq7hM7tTq1LdZHzFDcW05Ld7fqDKElU6nD/xlpnu
         Yvbgnmg6KtlNQ==
Date:   Tue, 16 Aug 2022 12:46:42 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, Jiacheng Xu <stitch@zju.edu.cn>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: fix UAF/GPF bug in nilfs_mdt_destroy
Message-ID: <20220816104642.qmjegdtthyzy5xbv@wittgenstein>
References: <20220816040859.659129-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220816040859.659129-1-dzm91@hust.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 12:08:58PM +0800, Dongliang Mu wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> In alloc_inode, inode_init_always() could return -ENOMEM if
> security_inode_alloc() fails, which causes inode->i_private
> uninitialized. Then nilfs_is_metadata_file_inode() returns
> true and nilfs_free_inode() wrongly calls nilfs_mdt_destroy(),
> which frees the uninitialized inode->i_private
> and leads to crashes(e.g., UAF/GPF).
> 
> Fix this by moving security_inode_alloc just prior to
> this_cpu_inc(nr_inodes)
> 
> Link: https://lkml.kernel.org/r/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ@mail.gmail.com
> Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Reported-by: Jiacheng Xu <stitch@zju.edu.cn>
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> ---

Looks good to me,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
