Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F767529ED6
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245072AbiEQKIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343767AbiEQKGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD6E11147;
        Tue, 17 May 2022 03:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E09615A1;
        Tue, 17 May 2022 10:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A6EC385B8;
        Tue, 17 May 2022 10:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652781976;
        bh=nrWHF6l7uVq8ZHQkdWkkCFxu0w4eyZo6b16CWXfYuA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ufYKC8u82/D8v3M2j5bcuFJLTIhJlOZys4GxKIK9Iq7X4uDGArMQbwo72pELRcppv
         AOJR3NHEWscpmZxRLvkJ9w8iflTotdq+2Th2+/O1w0JDy9QilASlW74BzZQeBWTFr6
         4lazJqHWQ31Y9U5r1ofIXalvwCgEtYGyrZd3rbOk=
Date:   Tue, 17 May 2022 12:06:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: fix a potential infinite loop
Message-ID: <YoNzlPyQEXBk2k4/@kroah.com>
References: <20220517095809.7791-1-ruc_gongyuanjun@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517095809.7791-1-ruc_gongyuanjun@163.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 05:58:09PM +0800, Yuanjun Gong wrote:
> From: Gong Yuanjun <ruc_gongyuanjun@163.com>
> 
> In the for-loop in _rtl92e_update_rxcounts(),
> i is a u8 counter while priv->rtllib->LinkDetectInfo.SlotNum is
> a u16 num, there is a potential infinite loop if SlotNum is larger
> than u8_max.

can SlotNum ever get larger than that?  If not, then why not just change
that type instead?

And you forgot to list the driver name in the subject line and cc: all
the right people that scripts/get_maintainer.pl will tell you to cc:

Please fix that up and resend a v2.

thanks,

greg k-h
