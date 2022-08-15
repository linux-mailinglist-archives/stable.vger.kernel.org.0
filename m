Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE4592F22
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242291AbiHOMo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242372AbiHOMo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:44:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D07DEED
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 05:44:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 26C65372BA;
        Mon, 15 Aug 2022 12:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660567495;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXf6r32wj1p2GHLn0u62xN2Gd5AiwdzyzA2rjC57cu8=;
        b=Iu+GMgwz6o2eTlFevdhiyUjAQVbH3A4hOK/+a/5I8xpCXiMaDVHK8fdGYHNqpaEYEY86Xn
        Hp5y5u9LylY1sxObP/Q29MLP4drEJ3ufB1JoD74EmCXosdVNLTAjf4ye7S+lW9Zm0a0Y1Q
        8ZjWyhHirsfHcbqGk3iTJP60hhNYwi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660567495;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXf6r32wj1p2GHLn0u62xN2Gd5AiwdzyzA2rjC57cu8=;
        b=RpjG6HY+ViQtvf9LiQVCedRkz+fTZEG+0fvJZ0NbMEctM0lZQkv4vOARtlNX6J1VBOi+OB
        HEs4ClxwL7mGhaCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC87F13A99;
        Mon, 15 Aug 2022 12:44:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mbcIMMY/+mKJMgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 15 Aug 2022 12:44:54 +0000
Date:   Mon, 15 Aug 2022 14:44:53 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        William Roche <william.roche@oracle.com>, ltp@lists.linux.it
Subject: Re: Backport d4ae9916ea29 ("mm: soft-offline: close the race against
 page allocation") to 4.14 and 4.9
Message-ID: <Yvo/xaNup1PJCCEv@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <Yvopj0gK5Dg95u+b@pevik>
 <YvowLH8GvMxMWcHH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvowLH8GvMxMWcHH@kroah.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, Aug 15, 2022 at 01:10:07PM +0200, Petr Vorel wrote:
> > Hi all,

> > I wonder if there was an attempt to backport d4ae9916ea29 ("mm: soft-offline:
> > close the race against page allocation") from 4.19 to 4.14 and 4.9 (patch does
> > not apply, haven't found anything on stable ML, nor in stable tree git,
> > therefore I assume it was left as not easily fixable).

> As it didn't apply, why not try creating a backport to test this
> yourself?  I'll gladly accept such a thing into the trees if you make
> it.

Hi Greg,

thanks for info, I might give it a try.

Kind regards,
Petr

> thanks,

> greg k-h
