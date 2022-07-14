Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4E8575430
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiGNRnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiGNRnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FE65509E;
        Thu, 14 Jul 2022 10:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9FEC6211C;
        Thu, 14 Jul 2022 17:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB438C34114;
        Thu, 14 Jul 2022 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657820600;
        bh=kg/rfOig8h7zvTG7CNWOXFC1hHSgJ1pLQcsSmugFb5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ+VUlWJUp5+YLlUY9qfYouLMLqn4F16jWarpGPKd+69HFdrNfB50/i02Y/OY01pw
         MfEJ8xmGRlv5rMsVXeV1r5xGa81iSoRlwa8jkOI+bf1uutaBhaZ4pxyGYdwvFmsoqn
         Zxnww++1pVdCDKl3PvuHdmlF4Ar0SXcbNOrf4wMSSZeABmpDWQN+4/jnLMxiYdqkvE
         gLvlwuU57XLt6DjwKTDlvGrdS2FS8sW/fBN/QvJ1hHpj1P4iJscgnYEUu34CMGcqIp
         cmhkxp/01DvksvPbi5b8myZXgI96zKJueXLOwQO6H0xI+naLjKDIbe0wXUOO6HAbsH
         l2ZCcr93eOV0A==
From:   SeongJae Park <sj@kernel.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     Jianglei Nie <niejianglei2021@163.com>, akpm@linux-foundation.org,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()
Date:   Thu, 14 Jul 2022 17:43:17 +0000
Message-Id: <20220714174317.49994-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220714164427.157184-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Jianglei,

On Thu, 14 Jul 2022 16:44:27 +0000 SeongJae Park <sj@kernel.org> wrote:

> Hello Jianglei,
> 
> On Thu, 14 Jul 2022 14:37:46 +0800 Jianglei Nie <niejianglei2021@163.com> wrote:
> 
> > damon_reclaim_init() allocates a memory chunk for ctx with
> > damon_new_ctx(). When damon_select_ops() fails, ctx is not released, which
> > will lead to a memory leak.

I realized this issue is also in DAMON_LRU_SORT, so posted a patch:
https://lore.kernel.org/damon/20220714170458.49727-1-sj@kernel.org/

I mistakenly forgot CC-ing you, so letting you know here.


Thanks,
SJ
