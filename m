Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3291159A8BF
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 00:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiHSWo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 18:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHSWo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 18:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694DA10D5A2;
        Fri, 19 Aug 2022 15:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 254E0B82920;
        Fri, 19 Aug 2022 22:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996E9C433C1;
        Fri, 19 Aug 2022 22:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660949092;
        bh=s8PKxoj54nX65XSLJWvwOlsXTFX9oxeU7c5M0X//TrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JHseprvTKx73mTepc3ANX5VSFgNTx8dSF5hSyR7qMWkHxt3k3vypwaBGHlaF4Ch0n
         fq1HKIH4bvo2I6lHUYEXuLDORyil74A4LhL/rQbxtrRUxOX9kZSJwiShKVrdH6YBY8
         IiK/D3zRr+Yqts1mWu+fPpcStMeL8msluSQwfzAg=
Date:   Fri, 19 Aug 2022 15:44:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     gregkh@linuxfoundation.org, badari.pulavarty@intel.com,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/dbgfs: avoid duplicate context directory
 creation
Message-Id: <20220819154451.9f424d9d563969d9cc6437f7@linux-foundation.org>
In-Reply-To: <20220819211631.16658-1-sj@kernel.org>
References: <20220819140809.1e3929fd8f50bfc32cae31d3@linux-foundation.org>
        <20220819211631.16658-1-sj@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022 21:16:31 +0000 SeongJae Park <sj@kernel.org> wrote:

> > It would be simpler (and less racy) to check the debugfs_create_dir()
> > return value for IS_ERR()?
> 
> I was merely following Greg's previous advice for ignoring the return value[1]
> of the function, but I might misunderstanding his intention, so CC-ing Greg.
> Greg, may I ask your opinion?
> 
> [1] https://lore.kernel.org/linux-mm/YB1kZaD%2F7omxXztF@kroah.com/

Thing is, the correct functioning of the debugfs interfaces is utterly
critical to damon.  And that's apart from these memory leak and
oops-we-killed-damon issues.

So damon simply cannot ignore the state of its debugfs interfaces and
keep going along - because if something goes wrong at the debugfs
layer, damon is dead and useless and the machine needs a reboot.

Perhaps this means that damon should not be using debugfs for its
interfaces at all.  Or it means that the debugfs interfaces are
misdesigned.  I go with the latter, which, alas, also affirms the
former.

From a quick scan it appears that a significant minority (20%?) of
drivers are checking the debugfs_create_dir() return value.
