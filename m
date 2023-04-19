Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4000A6E73F6
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjDSH00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjDSH0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:26:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA5783F2
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 00:25:51 -0700 (PDT)
Date:   Wed, 19 Apr 2023 09:25:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681889148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=puhDZ9O+Qj5gPpenARJZlMfM9hbc1gC4N4ICbzdxw1E=;
        b=FQUbb8Fydsvph6HBlvrXDAbRic06NZYM+wbhKy5sa6dT3cEfe7VSMRVaVzVTCn39wEmavR
        8HrhG3y5J6lzUyAQa/HG72Zq/4waPaAPAIh2U7dkMd/GbRWH6AZVU/VrnZ072nsz6uwngD
        tiXa8tBR2Ukbc6bU23ctnUr8aCla0gZ6zSthRbB+nTQROIoXklFs7q50hDU8Rvv5zheGn9
        l1E9zbthX3QgszcuZTXIhD0NSlOoGHscJN5qpt6l39cePSkOyDea0X8Yeu+ZlVGnANd4OB
        ooB5kM6be6owOnojsTCKUxYHUoidqcyaegQjWOwyIEbI9SWOwHUvDXUKH/A+8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681889148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=puhDZ9O+Qj5gPpenARJZlMfM9hbc1gC4N4ICbzdxw1E=;
        b=YO1jfvsZqgp8tp1M9H0vySscokLpzQ1L4VW+TxHyMwvTpOoNB7wTiaoR9K3u+WHL73qpA7
        9beliNLOeAqM0lBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
Message-ID: <20230419072546.gD_YO2-K@linutronix.de>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2023041854-cranium-prone-b9fa@gregkh>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-04-18 18:25:48 [+0200], Greg KH wrote:
> > Could this be please backported to 5.15 and earlier? It is already part
> > of the 6.X kernels. I asked about this by the end of January and I'm
> > kindly asking again ;)
> 
> I thought this was only an issues when using the out-of-tree RT patches
> with these kernels, right?  Or is it relevant for 5.15.y from kernel.org
> without anything else?

The out-of-tree RT patches make extensive use of the code. Since it is
upstream code, I assumed it should go via the official stable trees.
Without RT, the code is limited the rt_mutex_lock() used by I2C and the
RCU booster-mutex. 
Since this might not be enough to trigger the problem, let me route this
via rt-stable trees.

> greg k-h

Sebastian
