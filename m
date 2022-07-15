Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B945F5769C4
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 00:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiGOWQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 18:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiGOWQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 18:16:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72628262;
        Fri, 15 Jul 2022 15:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1185161701;
        Fri, 15 Jul 2022 22:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C99AC34115;
        Fri, 15 Jul 2022 22:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657923390;
        bh=5/bcyrjFpp5Iuv4UCuUwJcz8BDDH3Jj7t4EoceoC5iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvfK/jLzTa/S0wO9Yu7D5Jj5Fqj2YFjk1gi1svN5MtA8ehbFBJQc2RMO9X4ScthVs
         QsizMcGJn7zk4W0Q3qGAkYt5Xj7DUH3MiVecJWCNDWVTicNQBpujr5kpgNbSeEotZJ
         OL7a0dy1v8P4oiwQ2lzX1fSSWGN5aJz9TvIhxB8GxpoV6utwwratBETIkCoPtKgB8G
         zgF1NCIytZlL2WQlSg6UoeibjYVBrB6HeYMze2quwYG0Tc0fnlsZ57dLrUSVvRgN9V
         m/k5ebjsanBpcE15qxEz7qp7QPV+iB5uoCnQDAXTMlzemLomd7+ODKbJzYMRAGSxkc
         peojgDaJNTxsQ==
From:   SeongJae Park <sj@kernel.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     roger.pau@citrix.com, axboe@kernel.dk, boris.ostrovsky@oracle.com,
        jgross@suse.com, olekstysh@gmail.com, andrii.chepurnyi82@gmail.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Fix persistent grants negotiation with a behavior change
Date:   Fri, 15 Jul 2022 22:16:27 +0000
Message-Id: <20220715221627.127648-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715181226.126714-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On Fri, 15 Jul 2022 18:12:26 +0000 SeongJae Park <sj@kernel.org> wrote:

> Hi all,
> 
> On Fri, 15 Jul 2022 17:55:19 +0000 SeongJae Park <sj@kernel.org> wrote:
> 
> > The first patch of this patchset fixes 'feature_persistent' parameter
> > handling in 'blkback' to respect the frontend's persistent grants
> > support always.  The fix makes a behavioral change, so the second patch
> > makes the counterpart of 'blkfront' to consistently follow the behavior
> > change.
> 
> I made the behavior change as requested by Andrii[1].  I therefore made similar
> behavior change to blkfront and Cc-ed stable for the second change, too.

Now I realize that commit aac8a70db24b ("xen-blkback: add a parameter for
disabling of persistent grants") introduced two issues.  One is what Max
reported with his patch, and the second one is unintended behavioral change
that broke Andrii's use case.

That is, Andrii's use case should had no problem at all before the introduction
of 'feature_persistent', as at that time 'blkback' checked if the frontend
support the persistent grants for every 'reconnect()' and enables it if so.
However, introduction of the parameter made it behaves differently.

Yes, we intended to make the prameter to make effects to newly created devices.
But, as it breaks user workflows, this should be fixed.  Same for the
'blkfront' side 'feature_persistent'.

> 
> To make the change history clear and reduce the stable side overhead, however,
> it might be better to apply the v2, which don't make behavior change but only
> fix the issue, Cc stable@ for it, make the behavior change commits for both
> blkback and blkfront, update the documents, and don't Cc stable@ for the
> behavior change and documents update commits.

I'd say having one patch for each issue would be the right way to go, and all
fixes should Cc stable@.

> 
> One downside of that would be that it will make a behavioral difference in
> pre-5.19.x and post-5.19.x.

The unintended behavioral fix should also be considered fix and therefore
should be merged into stable@, so above concern is not valid.

I will send the next spin soon.


Thanks,
SJ

[...]
