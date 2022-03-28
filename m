Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315F64E8D99
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 07:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiC1FwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 01:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiC1FwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 01:52:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA913D7A
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 22:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE5BDB80E48
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 05:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FDEC340F0;
        Mon, 28 Mar 2022 05:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648446633;
        bh=4I9Qz/fC3E7FFjza0IGwWyBpwF2J2nxSi4k0FQo9kUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DIXNGjBv5e4hxvPGz1U1WggFQshv9dKOrtSTa1RIkHuzhgAqCSvgHyiYcjIbrRuxx
         VblQw1VwvHhUiEIfz02kIae2Ux+qvli5NxsORzW8UB48yo7krVOxGd9CCQc0MXBdBh
         WWIjgt+V3XcoV+xnTu/qX7Xra/L/w+rLW4vS2eG0=
Date:   Mon, 28 Mar 2022 07:50:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Vlad Buslov <vladbu@mellanox.com>, stable@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>, Daniel.Fleischer@orbit.de,
        Marcel.Krause@orbit.de, christian.hampe@telekom.de,
        haye.haehne@telekom.de, keith.lloyd@telekom.de
Subject: Re: v4.19.221 breaks qdisc modules
Message-ID: <YkFMoe4t1dRkHlEX@kroah.com>
References: <919153d5-a79a-de71-9584-10179ae586d@tarent.de>
 <425d1b7-abb9-903c-4ae4-11f27ef06313@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <425d1b7-abb9-903c-4ae4-11f27ef06313@tarent.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 11:44:59PM +0200, Thorsten Glaser wrote:
> On Sun, 27 Mar 2022, Thorsten Glaser wrote:
> 
> > But this makes it more tricky… or can I “just” change this
> > to KERNEL_VERSION(4, 19, 221) ?
> 
> Well, of course not:
> 
> $ cat /usr/src/linux-headers-4.19.0-19-amd64/include/generated/uapi/linux/version.h
> #define LINUX_VERSION_CODE 267263
> #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
> $ print $(((267263 >> 16) & 0xFF)).$(((267263 >> 8) & 0xFF)).$((267263 & 0xFF))
> 4.19.255
> 
> Whose bright idea was *that*?
> 
> How can I make this module compatible with *both* 4.19 variants?

Ah, external code, sorry, you are on your own.

As for how to test for larger numbers, see the answer in the email
archives, others have done this successfully.

good luck!

greg k-h
