Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2DF6ED963
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 02:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjDYAqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 20:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDYAql (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 20:46:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EDB59CA;
        Mon, 24 Apr 2023 17:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A20F620AA;
        Tue, 25 Apr 2023 00:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D839BC433D2;
        Tue, 25 Apr 2023 00:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682383599;
        bh=+qr4ONusJbqoWW6hCqya8fbiWqMGkDydQpxJxUyRNfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrwM9F5yndFDH3wOW39f2+1chzS7om4r893EUqTAj43JUaqLxqKuZyFXqV3/+xsqr
         Argg42Enc6mKX8gKaGb5o//tCQFmmxWEbgiwxBGIvSR6afSwtsyvgSY/VkRkiOpHfp
         7AGyM4DOQDxkFfjBhgokAx7HfsXo6PbLwCjFPyJkn1nHNrSahV1CY7xBEL7ChUExYq
         UH7m0agyvD8Ead3C+6e9XFbMbpDcr5+o+uhXadWgKTALYFT/Spx9+pHJEbYQh0oMpD
         yvDOTl3q8cyxEK96GH/odwp6hNg9Y0DS5ahRdlnOGOosKlt//x5RL3rPdNrhKpaxcV
         PAdAcInrdzEjw==
From:   SeongJae Park <sj@kernel.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        sj38.park@gmail.com, akpm@linux-foundation.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH v2] selftests/kselftest/runner/run_one(): Allow running non-executable files
Date:   Tue, 25 Apr 2023 00:46:37 +0000
Message-Id: <20230425004637.156064-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810164534.25902-1-sj38.park@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

On Tue, 10 Aug 2021 16:45:34 +0000 SeongJae Park <sj38.park@gmail.com> wrote:

> From: SeongJae Park <sjpark@amazon.de>
> 
> When running a test program, 'run_one()' checks if the program has the
> execution permission and fails if it doesn't.  However, it's easy to
> mistakenly missing the permission, as some common tools like 'diff'
> don't support the permission change well[1].  Compared to that, making
> mistakes in the test program's path would only rare, as those are
> explicitly listed in 'TEST_PROGS'.  Therefore, it might make more sense
> to resolve the situation on our own and run the program.
> 
> For the reason, this commit makes the test program runner function to
> still print the warning message but try parsing the interpreter of the
> program and explicitly run it with the interpreter, in the case.
> 
> [1] https://lore.kernel.org/mm-commits/YRJisBs9AunccCD4@kroah.com/
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: SeongJae Park <sjpark@amazon.de>

This patch has merged into the mainline by the commit 303f8e2d0200
("selftests/kselftest/runner/run_one(): allow running non-executable files").
However, this patch has not added to v5.15.y, while there are some selftests
having no execution permission, including that for DAMON.  As a result, the
selftests always fail unless this patch is manually applied.  Could you please
add this patch to v5.15.y?  I confirmed this patch can cleanly cherry-picked on
the latest v5.15.y.


Thanks,
SJ
