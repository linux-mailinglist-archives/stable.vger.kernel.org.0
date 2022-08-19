Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12059A90A
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 01:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbiHSXFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 19:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239401AbiHSXFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 19:05:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16EB90809;
        Fri, 19 Aug 2022 16:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89962B8280F;
        Fri, 19 Aug 2022 23:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2A3C433B5;
        Fri, 19 Aug 2022 23:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660950304;
        bh=AZL0aSK7Iwf8Lk3JbnO6+H4YnWrrROAZWLMPh5Hm/5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEKPV7mXRXYXHkT9CiejWuOCLLKp1h4nrKuXEyG9QfdzXQt68jqr2caGZI6WJkxYe
         gweaJaYGJxoiXNQ/zrX2WoI6U/KcRK9bU+n+c+FdQ4N7q8ZT6XDaK3aTCC13thOEMd
         qEuLyoVfoMM/6ghLjJlAtzmjZsmiH6Sg8by3zhFwGPnf/q/S50i5qDAHn5RPrYs9rS
         uwy8ylu3fm6KGo4LvMOLItxclMgd1WZK5VYUVUoToWPjzRve8+/WhFwaWAfZ2iS6Re
         hIgFMFZzjaa01DTi4ploFElFllt+QnNoPtJjTRDMH3nmrZZTYEgwor0R5msDqt+53d
         kR10UUa28lbqA==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     SeongJae Park <sj@kernel.org>, gregkh@linuxfoundation.org,
        badari.pulavarty@intel.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/dbgfs: avoid duplicate context directory creation
Date:   Fri, 19 Aug 2022 23:05:01 +0000
Message-Id: <20220819230501.16830-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819154451.9f424d9d563969d9cc6437f7@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022 15:44:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 19 Aug 2022 21:16:31 +0000 SeongJae Park <sj@kernel.org> wrote:
> 
> > > It would be simpler (and less racy) to check the debugfs_create_dir()
> > > return value for IS_ERR()?
> > 
> > I was merely following Greg's previous advice for ignoring the return value[1]
> > of the function, but I might misunderstanding his intention, so CC-ing Greg.
> > Greg, may I ask your opinion?
> > 
> > [1] https://lore.kernel.org/linux-mm/YB1kZaD%2F7omxXztF@kroah.com/
> 
> Thing is, the correct functioning of the debugfs interfaces is utterly
> critical to damon.  And that's apart from these memory leak and
> oops-we-killed-damon issues.
> 
> So damon simply cannot ignore the state of its debugfs interfaces and
> keep going along - because if something goes wrong at the debugfs
> layer, damon is dead and useless and the machine needs a reboot.
> 
> Perhaps this means that damon should not be using debugfs for its
> interfaces at all.  Or it means that the debugfs interfaces are
> misdesigned.  I go with the latter, which, alas, also affirms the
> former.

I'd save my word about the latter, but agreed on the former.  Fortunately we
already have an alternative (DAMON sysfs interface), and the debugfs interface
deprecation plan was announced for a while ago.  Not sure if the deprecation
will be well as hoped, though.

> 
> From a quick scan it appears that a significant minority (20%?) of
> drivers are checking the debugfs_create_dir() return value.

Maybe partly owing to Greg's previous efforts for removing the checks[1,2]?
Anyway, based on the previous discussions, I'd expect Greg might prefer not
checking the return code.

Anyway, waiting for his opinion.

[1] https://lore.kernel.org/all/20190122152151.16139-14-gregkh@linuxfoundation.org/
[2] https://lore.kernel.org/lkml/20190122152151.16139-7-gregkh@linuxfoundation.org/


Thanks,
SJ
