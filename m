Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7182D11587E
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 22:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfLFVSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 16:18:43 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:43791 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFVSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 16:18:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YhwINRPF/DR2qVd4V05+XHQkRxdjPjCjqg8j4UAkqdc=; b=MjFQMi7MPcgPJYuyL7OSd5mPBx
        xWfTQ42QTTHTNNschD6UHeHsSGzxTE1eJeY8z/NY+LbWajpJ3SOQj4NuwuBhgC3fKQYLkxj4sfjNj
        WOYJg9usOMATDKMiVs1+VbA2aDXCpZfj82Vy8qoKxUG2A+I9D9comFJ68ZfwtqsdNYG365+6WPEBr
        QaDCtHFR1XCiaUxELCSfRcoqmu/xc/MKQfCQ9BJ3qqMCFedAPl2hZOxQQJ6jCWuwpPoGhT67p6VBq
        Xz+EDNQJ0xpqwvt9mi+No5FsRQk5HKs9sB3rfItWiWqLek0ec42nSgmArOFkusfVgV+4k97GmlpsJ
        GNF3rlkA==;
Received: from 91-154-92-5.elisa-laajakaista.fi ([91.154.92.5] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1idKzj-0002Bb-LB; Fri, 06 Dec 2019 23:18:35 +0200
Date:   Fri, 6 Dec 2019 23:18:34 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
Message-ID: <20191206211834.GD9971@linux.intel.com>
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
 <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
 <20191127205800.GA14290@linux.intel.com>
 <20191127205912.GB14290@linux.intel.com>
 <20191128012055.f3a6gq7bjpvuierx@cantor>
 <20191129235322.GB21546@linux.intel.com>
 <20191130001253.rtovohtfbg25uifm@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191130001253.rtovohtfbg25uifm@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 91.154.92.5
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 05:12:53PM -0700, Jerry Snitselaar wrote:
> On Sat Nov 30 19, Jarkko Sakkinen wrote:
> > On Wed, Nov 27, 2019 at 06:20:55PM -0700, Jerry Snitselaar wrote:
> > > There also was that other issue reported on the list about
> > > tpm_tis_core_init failing when calling tpm_get_timeouts due to the
> > > power gating changes.
> > 
> > Please add a (lore.ko) link for reference to this thread.
> > 
> > /Jarkko
> > 
> 
> https://lore.kernel.org/linux-integrity/a60dadce-3650-44ce-8785-2f737ab9b993@www.fastmail.com/

tpm_chip_stop() probably causes the issue. That is why tpm2_probe()
works and failure happens after that.

tpm_chip_stop() should be called once at the end of the function.

/Jarkko
