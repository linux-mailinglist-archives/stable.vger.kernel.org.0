Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7B723C34C
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 04:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgHECIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 22:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHECIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 22:08:01 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4238FC06174A;
        Tue,  4 Aug 2020 19:08:01 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k38qH-009WtO-2V; Wed, 05 Aug 2020 02:07:45 +0000
Date:   Wed, 5 Aug 2020 03:07:45 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     macro@wdc.com, linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr' access
Message-ID: <20200805020745.GL1236603@ZenIV.linux.org.uk>
References: <alpine.DEB.2.20.2007232213510.4462@tpp.orcam.me.uk>
 <mhng-611be025-6e03-46a1-8a8a-6f6eeea04f57@palmerdabbelt-glaptop1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-611be025-6e03-46a1-8a8a-6f6eeea04f57@palmerdabbelt-glaptop1>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 07:01:01PM -0700, Palmer Dabbelt wrote:

> > We currently have @start_pos fixed at 0 across all calls, which works as
> > a result of the implementation, in particular because we have no padding
> > between the FP general registers and the FP control and status register,
> > but appears not to have been the intent of the API and is not what other
> > ports do, requiring one to study the copy handlers to understand what is
> > going on here.

start_pos *is* fixed at 0 and it's going to go away, along with the
sodding user_regset_copyout() very shortly.  ->get() is simply a bad API.
See vfs.git#work.regset for replacement.  And ->put() is also going to be
taken out and shot (next cycle, most likely).
