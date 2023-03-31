Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE45C6D1E26
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 12:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjCaKh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 06:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjCaKhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 06:37:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4061A95A;
        Fri, 31 Mar 2023 03:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0363CB82E4C;
        Fri, 31 Mar 2023 10:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFF1C433D2;
        Fri, 31 Mar 2023 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680259038;
        bh=dWyWOIVj1SDA63kPOq2AZvxwTmgsi+yXkOt75ifTxnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3jEO53zGo6fMMXI1G8vyajMLtx3QGWLDUxqpbgU9KhUN2Wo+wff1KfOrTsQ2hoyf
         bxtrqr1eGU6Ny4XJv7KlJ9KJW83ZD6l0NLx7KUx0oH2MLQMuxwt5qefUNTsyxkG85n
         BrVy4PnfuBF3C2Hz8hg7AV2T5PQC8t4ho/jAMHbBOaYyxANeNU5XX6k52SdIOmNy1c
         oEoVb+fQmT1y7UENmmeJaWaHsx70UsIWcqirMuj65SP4H6WdZXpHJkYB6Ee+GrRuMw
         WwyVJCYj6jT5EZyAYF1ymLKk0nSptwt03/XEFIl49utgtRfRkmEjtIzoQg0my+aci8
         rGwDeF9ulECZQ==
From:   Christian Brauner <brauner@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] fs: drop peer group ids under namespace lock
Date:   Fri, 31 Mar 2023 12:36:06 +0200
Message-Id: <20230331-angler-enjoyer-820f825d7646@brauner>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330-vfs-mount_setattr-propagation-fix-v1-1-37548d91533b@kernel.org>
References: <20230330-vfs-mount_setattr-propagation-fix-v1-1-37548d91533b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=481; i=brauner@kernel.org; h=from:subject:message-id; bh=gzgJPQ/tJyke88n1gF9CwJBXokKvoTocUw+rhclugD8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSobTeziTIqqmI6G33g1X7ujabubtEHK6P9jSvs9p+Mfmm/ 9tPljlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInoxjIyXPFT/CF6dsPh/bfW67zfn/ 9loUDfvuvngmICTBd7/Dl7tpyR4XSH9yOzNtOjhuri6x9mzzuydJ6Z2o4aLSUO7phdm09nsgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Thu, 30 Mar 2023 09:13:16 +0200, Christian Brauner wrote:
> When cleaning up peer group ids in the failure path we need to make sure
> to hold on to the namespace lock. Otherwise another thread might just
> turn the mount from a shared into a non-shared mount concurrently.
> 
> 

Ok, syzbot is happy with this as well so let's get this fixed and backported,

tree: git://git.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping.git
branch: vfs.misc.fixes
[1/1] fs: drop peer group ids under namespace lock
      commit: cb2239c198ad9fbd5aced22cf93e45562da781eb
