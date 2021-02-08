Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92E2313D70
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhBHS1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbhBHS0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 13:26:17 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF44C061786;
        Mon,  8 Feb 2021 10:25:31 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l9BDz-000AHc-Jg; Mon, 08 Feb 2021 19:25:27 +0100
Message-ID: <69e7fbb93740c0116c358a2f40aadb2dbde702fe.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] init/gcov: allow CONFIG_CONSTRUCTORS on
 UML to fix module gcov
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 08 Feb 2021 19:25:21 +0100
In-Reply-To: <20210208180000.2092497-4-sashal@kernel.org>
References: <20210208180000.2092497-1-sashal@kernel.org>
         <20210208180000.2092497-4-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-02-08 at 18:00 +0000, Sasha Levin wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> [ Upstream commit 55b6f763d8bcb5546997933105d66d3e6b080e6a ]
> 
> On ARCH=um, loading a module doesn't result in its constructors getting
> called, which breaks module gcov since the debugfs files are never
> registered.  On the other hand, in-kernel constructors have already been
> called by the dynamic linker, so we can't call them again.
> 
> Get out of this conundrum by allowing CONFIG_CONSTRUCTORS to be
> selected, but avoiding the in-kernel constructor calls.
> 
> Also remove the "if !UML" from GCOV selecting CONSTRUCTORS now, since we
> really do want CONSTRUCTORS, just not kernel binary ones.
> 
> Link: https://lkml.kernel.org/r/20210120172041.c246a2cac2fb.I1358f584b76f1898373adfed77f4462c8705b736@changeid
> 


While I don't really *object* to this getting backported, it's also a
(development) corner case that somebody wants gcov and modules in
ARCH=um ... I'd probably not backport this.

johannes

