Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799E24E94FE
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbiC1Ljo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbiC1Lik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:38:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE77A3;
        Mon, 28 Mar 2022 04:36:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t13so10794352pgn.8;
        Mon, 28 Mar 2022 04:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lFPVATAPP8SMQnO5b+dcn4/0YVMSr84BOSW0pJSfP8E=;
        b=irGRDrAjp4zX6St2s5LcSWL8OmrwDBpc7vD4dqEDZ8J+XVvrel1X5rmUE0vWO3CgEF
         0ReKZpfJEF/YIZ78vx1yb87ss3EX6UCjnhHHMVRVkNioNZB6o4nnCvL6OE15DbXsTYEq
         e9PDXV0wk0zWeNcEmiXE54xDbNW9cSFLfU92XVJxB8VpwHWtdwwzTxuRG9OTub6daSQi
         i/9hvxED6silsojaj8EO9OQJBOusbPWphxRHwmRg3xY9+QhgFBQN12aMemQiefnY5nBh
         5UbSpdfVb1wY3oRDnpP5gP/YT5PVDXwPM/Ns9SeVH3B1ntuGqCEBm90jQtlTQg86+ys1
         X69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lFPVATAPP8SMQnO5b+dcn4/0YVMSr84BOSW0pJSfP8E=;
        b=z9qiZyiRGrjn525jwFwq3ptc3TRTOKYScFaHaybOYaZdEbDy2xsACjsmTO5/yvQO/q
         aDJmITl0W1K2eFdFgorIeAoohQa8ffV54tkZsNwoJtY5qMoz/nRumsxQXFezW5azzfr+
         H/YJrKkfgwcb1hXdhiPBecRuQJx/3k3tn+YIUkAakPE71RWsFcxlJMnfRIYCtszEsuLx
         2uaWJGdsqhIgD0F7uAagfeH/71YzEe3w2eCNKkUWlwiZXLVDBMN8H1CnzJzwlpcWL910
         j5tWvjxp5ZDLydObkPFC4abkmYO60HJro7MKk5JxNZPZhFSOfcozJBrDK9vZpwWGmp19
         1Ubw==
X-Gm-Message-State: AOAM530/Zh/4S0NY6+dB/lAjUVNZg3HB8tfYr9FPYWzJvuwl51o6lx6q
        aO1VFphr1rm7KGXTdUmIVs8=
X-Google-Smtp-Source: ABdhPJw64G8PpX8+aM3/JsmFXrPMZQqjdTv75fuE2nnC185upZaEgw9PH9QeCF4aog4SrbFcNHlqfw==
X-Received: by 2002:a65:6a08:0:b0:382:1af5:a4cb with SMTP id m8-20020a656a08000000b003821af5a4cbmr9823627pgu.398.1648467371142;
        Mon, 28 Mar 2022 04:36:11 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id nl17-20020a17090b385100b001c70883f6ccsm23359509pjb.36.2022.03.28.04.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 04:36:10 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     sj@kernel.org
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] damon: vaddr-test: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 19:36:04 +0800
Message-Id: <20220328113604.31373-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220328075104.31125-1-sj@kernel.org>
References: <20220328075104.31125-1-sj@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On  Mon, 28 Mar 2022 07:51:04 +0000, SJ wrote:
> On Sun, 27 Mar 2022 16:03:45 +0800 Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> 
> > The bug is here:
> > 	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
> > 	KUNIT_EXPECT_EQ(test, r->ar.end, end);
> > 
> > For the damon_for_each_region(), just like list_for_each_entry(),
> > the list iterator 'drm_crtc' will point to a bogus position
> > containing HEAD if the list is empty or no element is found.
> > This case must be checked before any use of the iterator,
> > otherwise it will lead to a invalid memory access.
> 
> We ensure 'damon_va_evenly_split_region()' successes before executing the loop,
> so the issue cannot occur.  That said, I think this patch makes code better to
> read.  Could you please resend this patch after fixing the commit message?

Yes, you should be right. I have resend this patch with the commit message changed.
Please check it, thank you.

--
Xiaomeng Tong
