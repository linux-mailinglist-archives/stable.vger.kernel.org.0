Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6EA664EE0
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 23:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjAJWjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 17:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjAJWjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 17:39:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183F75BA3A;
        Tue, 10 Jan 2023 14:39:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8DB3B8188D;
        Tue, 10 Jan 2023 22:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A9BC433D2;
        Tue, 10 Jan 2023 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390345;
        bh=CHV3wwF6DRpaVUpB9BEe80Xrl4JvAJr5u96YALmTzjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eaUHeTEWYPqreOnP20L2U8R5bn9na6PsL8f3eeAjPKpgzeY9Ss/z105ON1NeTtH3U
         LOQ/JKk3844xaKVU6gBB9b3nqlu98xJnOHHT+N/XVyhtfhiINpCvg814FmfAZj2gnU
         SWkX61vnOLYoL2tiq0tSUCce6yw1PictDWdWOi/A=
Date:   Tue, 10 Jan 2023 14:39:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org
Subject: Re: [PATCH] aio: fix mremap after fork null-deref
Message-Id: <20230110143904.8f8c6c0f80aa01c938326446@linux-foundation.org>
In-Reply-To: <20221104212519.538108-1-sethjenkins@google.com>
References: <20221104212519.538108-1-sethjenkins@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  4 Nov 2022 17:25:19 -0400 Seth Jenkins <sethjenkins@google.com> wrote:

> Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
> a null-deref if mremap is called on an old aio mapping after fork as
> mm->ioctx_table will be set to NULL.
> 

Is this a theoretical thing, or has this oops actually been observed?
