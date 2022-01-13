Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7102948DAC3
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 16:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbiAMPjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 10:39:54 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:42638 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiAMPjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 10:39:53 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C2BBE21129;
        Thu, 13 Jan 2022 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642088392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RamtjMZmYeqrBKQKHp7tfhwMa3yuK1SmuUxjb3OJF60=;
        b=Zdsw5mAME/ZeqwydUqClaAmejCFg1Diufxt8jJVlbprocdOT3/5atQv86F5iJArdObxokL
        zg40Qfu5B47No00ab57EJ5QqNVsKjOpOgtXI73lYBTkr+m3YVbJmeK8UUXiUgAAnCMoX40
        UdL2qmLmXdrlWjWgN1KcWHuqr7/yZtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642088392;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RamtjMZmYeqrBKQKHp7tfhwMa3yuK1SmuUxjb3OJF60=;
        b=L/GFLxmj4uWfzgGd4p/XrtJzEfY4L7SaRZOlFeswhxz7BcGqdr/v9L22ZRiNnLHPe9f4p/
        H5BJE38OSpXosgAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ABDA41330C;
        Thu, 13 Jan 2022 15:39:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id J0uoKMhH4GEBHQAAMHmgww
        (envelope-from <bp@suse.de>); Thu, 13 Jan 2022 15:39:52 +0000
Date:   Thu, 13 Jan 2022 16:40:00 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "x86/mce: Remove noinstr annotation from mce_setup()" has
 been added to the 5.15-stable tree
Message-ID: <YeBH0Pui5SD0Tf3T@zn.tnic>
References: <164207874020173@kroah.com>
 <YeAnLb7OkkmTWtf/@zn.tnic>
 <YeA31erBrPKu755G@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YeA31erBrPKu755G@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 03:31:49PM +0100, Greg KH wrote:
> Any hints on how to get rid of this?  More patches in the series this
> one came from?

Unfortunately, a whole series:

https://lore.kernel.org/r/20211208111343.8130-1-bp@alien8.de

and the 0day bot guys recently managed to trigger another warning there,
which means even more fixes, even to generic code.

So what that warning tells you is that you call into instrumentable
context from non-instrumentable one. But that has relevance only when
someone traces the MCE code - and up until now I haven't received a
single sensible use case for why that would make any sense.

So long story short, you can safely ignore it and if someone complains,
ask her/him about the use case first and CC me.

:-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Ivo Totev, HRB 36809, AG Nürnberg
