Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E69512AA07
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 04:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLZDfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Dec 2019 22:35:34 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:49492 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLZDfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Dec 2019 22:35:34 -0500
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Dec 2019 22:35:33 EST
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23991197AbfLZDBGcj560 (ORCPT
        <rfc822;stable@vger.kernel.org> + 2 others);
        Thu, 26 Dec 2019 04:01:06 +0100
Date:   Thu, 26 Dec 2019 03:01:06 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Paul Burton' <paulburton@kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] MIPS: Use __copy_{to,from}_user() for emulated FP
 loads/stores
In-Reply-To: <e220ba9a19da41abba599b5873afa494@AcuMS.aculab.com>
Message-ID: <alpine.LFD.2.21.1912260251520.3762799@eddie.linux-mips.org>
References: <20191203204933.1642259-1-paulburton@kernel.org> <f5e09155580d417e9dcd07b1c20786ed@AcuMS.aculab.com> <20191204154048.eotzglp4rdlx4yzl@lantea.localdomain> <e220ba9a19da41abba599b5873afa494@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Dec 2019, David Laight wrote:

> > We used to have separate get_user_unaligned() & put_user_unaligned()
> > which would suggest that it's expected that get_user() & put_user()
> > require their accesses be aligned, but they were removed by commit
> > 3170d8d226c2 ("kill {__,}{get,put}_user_unaligned()") in v4.13.
> > 
> > But perhaps we should just take the second AdEL exception & recover via
> > the fixups table. We definitely don't right now... Needs further
> > investigation...
> 
> get/put_user can fault because the user page is absent (etc).
> So there must be code to 'expect' a fault on those instructions.

 As I recall we only emulate unaligned accesses with a subset of integer 
load/store instructions (and then only if TIF_FIXADE is set, which is the 
default), and never with FP load/store instructions.  Consequently I see 
no point in doing this in the FP emulator either and I think these ought 
to just send SIGBUS instead.  Otherwise you'll end up with user code that 
works differently depending on whether the FP hardware is real or 
emulated, which is really bad.

 FWIW,

  Maciej
